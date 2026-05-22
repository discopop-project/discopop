# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

import json
import os
import tkinter as tk
from tkinter import ttk
from typing import Any, Callable, Dict, List, Optional, Tuple

from discopop_library.ProjectManager.gui.widgets import CATPPUCCIN_OUTPUT_BG, CATPPUCCIN_FG

_CHECKED = "☑"
_UNCHECKED = "☐"
_TRISTATE = "▣"


def _get_patch_display_name(patch_path: str) -> str:
    """Extract the source filename from a patch's --- header line."""
    try:
        with open(patch_path, "r") as f:
            for line in f:
                if line.startswith("---"):
                    parts = line[4:].split("\t")
                    name = os.path.basename(parts[0].strip())
                    if name:
                        return name
    except IOError:
        pass
    return os.path.basename(patch_path)


class SuggestionBrowserDialog:
    def __init__(
        self,
        parent: Any,
        dot_dp_path: str,
        on_selection_changed: Optional[Callable[[], None]] = None,
    ) -> None:
        self.parent = parent
        self.dot_dp_path = dot_dp_path
        self.on_selection_changed = on_selection_changed

        self._patches: Dict[str, List[str]] = {}
        self._patch_display_names: Dict[Tuple[str, str], str] = {}
        self._selection: Dict[str, List[str]] = {}

        self._tree: Optional[ttk.Treeview] = None
        self._sid_to_item: Dict[str, str] = {}
        self._file_to_item: Dict[Tuple[str, str], str] = {}
        self._item_to_sid: Dict[str, str] = {}
        self._item_to_file: Dict[str, Tuple[str, str]] = {}

        self._current_patch_path: Optional[str] = None
        self._current_text_modified = False
        self._text_content_on_load = ""
        self._resetting_modified = False

        self._load_patches()
        self._load_selection()
        self._merge_new_patches()
        self._save_selection(notify=False)
        self._build_dialog()

    def _get_selection_path(self) -> str:
        return os.path.join(self.dot_dp_path, "project", "manager", "selected_suggestions.json")

    def _load_patches(self) -> None:
        patch_gen_dir = os.path.join(self.dot_dp_path, "patch_generator")
        if not os.path.isdir(patch_gen_dir):
            return
        for suggestion_id in sorted(
            os.listdir(patch_gen_dir),
            key=lambda x: int(x) if x.isdigit() else x,
        ):
            sid_dir = os.path.join(patch_gen_dir, suggestion_id)
            if not os.path.isdir(sid_dir):
                continue
            patch_files = sorted(f for f in os.listdir(sid_dir) if f.endswith(".patch"))
            if patch_files:
                self._patches[suggestion_id] = patch_files
                for filename in patch_files:
                    patch_path = os.path.join(sid_dir, filename)
                    self._patch_display_names[(suggestion_id, filename)] = _get_patch_display_name(patch_path)

    def _load_selection(self) -> None:
        path = self._get_selection_path()
        if os.path.exists(path):
            try:
                with open(path, "r") as f:
                    data = json.load(f)
                self._selection = data.get("selected", {})
            except (json.JSONDecodeError, IOError):
                self._selection = {}

    def _merge_new_patches(self) -> None:
        """Newly discovered suggestions default to fully selected; known suggestions preserve user choices."""
        for sid, files in self._patches.items():
            if sid not in self._selection:
                self._selection[sid] = list(files)

    def _save_selection(self, notify: bool = True) -> None:
        path = self._get_selection_path()
        os.makedirs(os.path.dirname(path), exist_ok=True)
        try:
            with open(path, "w") as f:
                json.dump({"selected": self._selection}, f, indent=2)
        except IOError:
            pass
        if notify and self.on_selection_changed:
            self.on_selection_changed()

    def _build_dialog(self) -> None:
        self.dialog = tk.Toplevel(self.parent)
        self.dialog.title("Browse Parallelization Suggestions")
        self.dialog.geometry("1200x800")
        self.dialog.minsize(800, 500)

        pw = self.parent.winfo_width()
        ph = self.parent.winfo_height()
        px = self.parent.winfo_rootx()
        py = self.parent.winfo_rooty()
        w, h = 1200, 800
        self.dialog.geometry(f"{w}x{h}+{px + (pw - w) // 2}+{py + (ph - h) // 2}")

        main_paned = tk.PanedWindow(self.dialog, orient=tk.HORIZONTAL, sashrelief=tk.RAISED)
        main_paned.pack(fill=tk.BOTH, expand=True, padx=5, pady=5)

        left_frame = tk.Frame(main_paned)
        main_paned.add(left_frame, minsize=180)

        right_frame = tk.Frame(main_paned)
        main_paned.add(right_frame, minsize=350)

        self._build_left_panel(left_frame)
        self._build_right_panel(right_frame)

        self.dialog.transient(self.parent)
        self.dialog.grab_set()

    def _build_left_panel(self, parent: tk.Frame) -> None:
        tk.Label(
            parent,
            text=f"Suggestions ({len(self._patches)})",
            font=("Arial", 9, "bold"),
        ).pack(anchor=tk.W, padx=5, pady=(5, 2))

        container = tk.Frame(parent)
        container.pack(fill=tk.BOTH, expand=True)

        self._tree = ttk.Treeview(
            container,
            show="tree",
            selectmode="browse",
        )
        self._tree.column("#0", stretch=True)

        scrollbar = ttk.Scrollbar(container, orient=tk.VERTICAL, command=self._tree.yview)
        self._tree.configure(yscrollcommand=scrollbar.set)
        scrollbar.pack(side=tk.RIGHT, fill=tk.Y)
        self._tree.pack(side=tk.LEFT, fill=tk.BOTH, expand=True)

        if not self._patches:
            self._tree.insert("", "end", text="No suggestions found.")
        else:
            for sid in sorted(self._patches.keys(), key=lambda x: int(x) if x.isdigit() else x):
                self._build_tree_suggestion(sid)

        self._tree.bind("<Button-1>", self._on_tree_click)

        self.selection_count_label = tk.Label(parent, text="", font=("Arial", 8), fg="gray")
        self.selection_count_label.pack(anchor=tk.W, padx=5, pady=2)
        self._update_selection_count()

    def _build_tree_suggestion(self, sid: str) -> None:
        assert self._tree is not None
        item = self._tree.insert("", "end", text=f"{self._suggestion_select_char(sid)}  Suggestion {sid}", open=True)
        self._sid_to_item[sid] = item
        self._item_to_sid[item] = sid

        for filename in self._patches[sid]:
            display_name = self._patch_display_names.get((sid, filename), filename)
            fitem = self._tree.insert(item, "end", text=f"{self._file_select_char(sid, filename)}  {display_name}")
            self._file_to_item[(sid, filename)] = fitem
            self._item_to_file[fitem] = (sid, filename)

    def _suggestion_select_char(self, sid: str) -> str:
        files = self._patches[sid]
        selected = self._selection.get(sid, [])
        n_checked = sum(1 for f in files if f in selected)
        if n_checked == 0:
            return _UNCHECKED
        elif n_checked == len(files):
            return _CHECKED
        else:
            return _TRISTATE

    def _file_select_char(self, sid: str, filename: str) -> str:
        return _CHECKED if filename in self._selection.get(sid, []) else _UNCHECKED

    def _on_tree_click(self, event: Any) -> None:
        assert self._tree is not None
        item = self._tree.identify_row(event.y)
        if not item:
            return
        if self._tree.identify_element(event.x, event.y) == "indicator":
            return  # let Treeview handle expand/collapse natively

        if item in self._item_to_sid:
            self._toggle_suggestion(self._item_to_sid[item])
        elif item in self._item_to_file:
            sid, filename = self._item_to_file[item]
            self._toggle_file(sid, filename)
            patch_path = os.path.join(self.dot_dp_path, "patch_generator", sid, filename)
            self._load_patch_in_editor(patch_path)

    def _toggle_suggestion(self, sid: str) -> None:
        assert self._tree is not None
        files = self._patches[sid]
        selected = self._selection.get(sid, [])
        if all(f in selected for f in files):
            self._selection[sid] = []
        else:
            self._selection[sid] = list(files)

        self._tree.item(self._sid_to_item[sid], text=f"{self._suggestion_select_char(sid)}  Suggestion {sid}")
        for filename in files:
            fitem = self._file_to_item.get((sid, filename))
            if fitem:
                display_name = self._patch_display_names.get((sid, filename), filename)
                self._tree.item(fitem, text=f"{self._file_select_char(sid, filename)}  {display_name}")

        self._save_selection()
        self._update_selection_count()

    def _toggle_file(self, sid: str, filename: str) -> None:
        assert self._tree is not None
        if sid not in self._selection:
            self._selection[sid] = []
        if filename in self._selection[sid]:
            self._selection[sid].remove(filename)
        else:
            self._selection[sid].append(filename)

        fitem = self._file_to_item.get((sid, filename))
        if fitem:
            display_name = self._patch_display_names.get((sid, filename), filename)
            self._tree.item(fitem, text=f"{self._file_select_char(sid, filename)}  {display_name}")
        self._tree.item(self._sid_to_item[sid], text=f"{self._suggestion_select_char(sid)}  Suggestion {sid}")

        self._save_selection()
        self._update_selection_count()

    def _update_selection_count(self) -> None:
        total = sum(len(files) for files in self._patches.values())
        selected = sum(len(sel) for sel in self._selection.values())
        if hasattr(self, "selection_count_label"):
            self.selection_count_label.config(text=f"{selected} of {total} selected for execution")

    def _build_right_panel(self, parent: tk.Frame) -> None:
        header_frame = tk.Frame(parent)
        header_frame.pack(fill=tk.X, padx=5, pady=(5, 2))

        self.save_button = tk.Button(
            header_frame, text="Save File", command=self._save_current_patch, state=tk.DISABLED, width=10
        )
        self.save_button.pack(side=tk.LEFT)

        editor_frame = tk.Frame(parent)
        editor_frame.pack(fill=tk.BOTH, expand=True, padx=5, pady=2)

        self.editor_text = tk.Text(
            editor_frame,
            wrap=tk.NONE,
            font=("Courier New", 10),
            bg=CATPPUCCIN_OUTPUT_BG,
            fg=CATPPUCCIN_FG,
            insertbackground=CATPPUCCIN_FG,
            relief=tk.FLAT,
            bd=0,
            state=tk.DISABLED,
        )

        y_scroll = ttk.Scrollbar(editor_frame, orient=tk.VERTICAL, command=self.editor_text.yview)
        x_scroll = ttk.Scrollbar(editor_frame, orient=tk.HORIZONTAL, command=self.editor_text.xview)
        self.editor_text.configure(yscrollcommand=y_scroll.set, xscrollcommand=x_scroll.set)

        y_scroll.pack(side=tk.RIGHT, fill=tk.Y)
        x_scroll.pack(side=tk.BOTTOM, fill=tk.X)
        self.editor_text.pack(fill=tk.BOTH, expand=True)

        self.editor_text.tag_config("diff_add", foreground="#a6e3a1")
        self.editor_text.tag_config("diff_remove", foreground="#f38ba8")
        self.editor_text.tag_config("diff_header", foreground="#89b4fa")
        self.editor_text.tag_config("diff_hunk", foreground="#f9e2af")

        self.editor_text.bind("<<Modified>>", self._on_text_modified)

    def _load_patch_in_editor(self, patch_path: str) -> None:
        if self._current_text_modified and self._current_patch_path:
            from discopop_library.ProjectManager.gui.mixins.helpers import ask_yes_no

            if ask_yes_no(self.dialog, "Unsaved Changes", "You have unsaved changes. Save before switching?"):
                self._save_current_patch()

        self._current_patch_path = patch_path
        self._current_text_modified = False

        try:
            with open(patch_path, "r") as f:
                content = f.read()
        except IOError as e:
            content = f"Error reading file: {e}"

        self._text_content_on_load = content

        self.editor_text.config(state=tk.NORMAL)
        self.editor_text.delete("1.0", tk.END)
        self.editor_text.insert("1.0", content)
        self._apply_diff_highlighting()
        self._resetting_modified = True
        self.editor_text.edit_modified(False)
        self._resetting_modified = False

        self.save_button.config(text="Save File", state=tk.NORMAL)

    def _apply_diff_highlighting(self) -> None:
        for tag in ("diff_add", "diff_remove", "diff_header", "diff_hunk"):
            self.editor_text.tag_remove(tag, "1.0", tk.END)
        content = self.editor_text.get("1.0", tk.END)
        for i, line in enumerate(content.split("\n"), start=1):
            start = f"{i}.0"
            end = f"{i}.end"
            if line.startswith("+++") or line.startswith("---"):
                self.editor_text.tag_add("diff_header", start, end)
            elif line.startswith("+"):
                self.editor_text.tag_add("diff_add", start, end)
            elif line.startswith("-"):
                self.editor_text.tag_add("diff_remove", start, end)
            elif line.startswith("@@"):
                self.editor_text.tag_add("diff_hunk", start, end)

    def _on_text_modified(self, event: Any) -> None:
        if self._resetting_modified:
            return
        self._resetting_modified = True
        self.editor_text.edit_modified(False)
        self._resetting_modified = False

        current = self.editor_text.get("1.0", "end-1c")
        if current != self._text_content_on_load:
            self._current_text_modified = True
            self.save_button.config(text="Save File *")
        else:
            self._current_text_modified = False
            self.save_button.config(text="Save File")

    def _save_current_patch(self) -> None:
        if not self._current_patch_path:
            return
        content = self.editor_text.get("1.0", "end-1c")
        try:
            with open(self._current_patch_path, "w") as f:
                f.write(content)
            self._text_content_on_load = content
            self._current_text_modified = False
            self._resetting_modified = True
            self.editor_text.edit_modified(False)
            self._resetting_modified = False
            self.save_button.config(text="Save File")
            self._apply_diff_highlighting()
        except IOError as e:
            from discopop_library.ProjectManager.gui.mixins.helpers import show_error

            show_error(self.dialog, "Save Error", f"Could not save file: {e}")

    def _on_close(self) -> None:
        if self._current_text_modified:
            from discopop_library.ProjectManager.gui.mixins.helpers import ask_yes_no

            if ask_yes_no(self.dialog, "Unsaved Changes", "You have unsaved changes. Save before closing?"):
                self._save_current_patch()
        self.dialog.destroy()
