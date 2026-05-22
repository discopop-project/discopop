# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

import json
import os
import subprocess
import sys
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
        self._applied_suggestions: List[str] = []

        self._expanded: Dict[str, bool] = {}
        self._expand_buttons: Dict[str, tk.Button] = {}
        self._check_buttons: Dict[str, tk.Button] = {}
        self._file_check_buttons: Dict[Tuple[str, str], tk.Button] = {}
        self._action_buttons: Dict[str, tk.Button] = {}
        self._child_frames: Dict[str, tk.Frame] = {}
        self._row_frames: Dict[str, tk.Frame] = {}

        self._current_patch_path: Optional[str] = None
        self._current_text_modified = False
        self._text_content_on_load = ""
        self._resetting_modified = False

        self._load_patches()
        self._load_selection()
        self._merge_new_patches()
        self._save_selection(notify=False)
        self._applied_suggestions = self._load_applied_suggestions()
        self._build_dialog()

    # ── persistence helpers ──────────────────────────────────────────────────

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

    def _save_selection(self, notify: bool = False) -> None:
        path = self._get_selection_path()
        os.makedirs(os.path.dirname(path), exist_ok=True)
        try:
            with open(path, "w") as f:
                json.dump({"selected": self._selection}, f, indent=2)
        except IOError:
            pass
        if notify and self.on_selection_changed:
            self.on_selection_changed()

    def _load_applied_suggestions(self) -> List[str]:
        applied_file = os.path.join(self.dot_dp_path, "patch_applicator", "applied_suggestions.json")
        if not os.path.exists(applied_file):
            return []
        try:
            with open(applied_file, "r") as f:
                data = json.load(f)
            return list(data.get("applied", []))
        except (json.JSONDecodeError, IOError):
            return []

    def _register_for_execution(self) -> None:
        self._save_selection(notify=True)

    # ── dialog construction ──────────────────────────────────────────────────

    def _build_dialog(self) -> None:
        self.dialog = tk.Toplevel(self.parent)
        self.dialog.title("Browse Parallelization Suggestions")
        self.dialog.geometry("1200x800")
        self.dialog.minsize(800, 500)

        # Probe default button foreground so we can restore it for the "not applied" state
        _probe = tk.Button(self.dialog)
        self._default_btn_fg: str = str(_probe.cget("fg"))
        _probe.destroy()

        pw = self.parent.winfo_width()
        ph = self.parent.winfo_height()
        px = self.parent.winfo_rootx()
        py = self.parent.winfo_rooty()
        w, h = 1200, 800
        self.dialog.geometry(f"{w}x{h}+{px + (pw - w) // 2}+{py + (ph - h) // 2}")

        bottom_bar = tk.Frame(self.dialog)
        bottom_bar.pack(side=tk.BOTTOM, fill=tk.X, padx=5, pady=(0, 5))
        tk.Button(
            bottom_bar,
            text="Register suggestions for execution",
            command=self._register_for_execution,
        ).pack(side=tk.LEFT, padx=(0, 10))
        tk.Button(
            bottom_bar,
            text="Apply selected to code",
            command=self._apply_selected_to_code,
        ).pack(side=tk.LEFT, padx=(0, 5))
        tk.Button(
            bottom_bar,
            text="Reset all applied patches",
            command=self._reset_all_applied,
        ).pack(side=tk.LEFT)

        main_paned = tk.PanedWindow(self.dialog, orient=tk.HORIZONTAL, sashrelief=tk.RAISED)
        main_paned.pack(fill=tk.BOTH, expand=True, padx=5, pady=5)

        left_frame = tk.Frame(main_paned)
        # stretch="always": window growth goes to the left (suggestions) panel first;
        # minsize=420 ensures buttons/checkboxes are never clipped
        main_paned.add(left_frame, minsize=420, stretch="always")

        right_frame = tk.Frame(main_paned)
        # stretch="never": editor does not absorb window resize — left panel does
        main_paned.add(right_frame, minsize=300, stretch="never")

        self._build_left_panel(left_frame)
        self._build_right_panel(right_frame)

        # Place sash so left starts with more space than its minimum
        self.dialog.after(10, lambda: main_paned.sash_place(0, 500, 0))  # type: ignore[misc]

        self.dialog.transient(self.parent)
        self.dialog.grab_set()

    def _build_left_panel(self, parent: tk.Frame) -> None:
        tk.Label(
            parent,
            text=f"Suggestions ({len(self._patches)})",
            font=("Arial", 9, "bold"),
        ).pack(anchor=tk.W, padx=5, pady=(5, 2))

        list_outer = tk.Frame(parent)
        list_outer.pack(fill=tk.BOTH, expand=True)

        self._list_canvas = tk.Canvas(list_outer, highlightthickness=0)
        scrollbar = ttk.Scrollbar(list_outer, orient=tk.VERTICAL, command=self._list_canvas.yview)
        self._list_inner = tk.Frame(self._list_canvas)

        self._list_canvas.configure(yscrollcommand=scrollbar.set)
        scrollbar.pack(side=tk.RIGHT, fill=tk.Y)
        self._list_canvas.pack(side=tk.LEFT, fill=tk.BOTH, expand=True)

        self._list_window = self._list_canvas.create_window((0, 0), window=self._list_inner, anchor="nw")

        def _on_inner_configure(event: Any) -> None:
            self._list_canvas.configure(scrollregion=self._list_canvas.bbox("all"))

        def _on_canvas_resize(event: Any) -> None:
            self._list_canvas.itemconfig(self._list_window, width=event.width)

        self._list_inner.bind("<Configure>", _on_inner_configure)
        self._list_canvas.bind("<Configure>", _on_canvas_resize)

        if not self._patches:
            tk.Label(self._list_inner, text="No suggestions found.", fg="gray").pack(anchor=tk.W, padx=10, pady=5)
        else:
            for sid in sorted(self._patches.keys(), key=lambda x: int(x) if x.isdigit() else x):
                self._expanded[sid] = True
                self._add_suggestion_row(self._list_inner, sid)

        self.selection_count_label = tk.Label(parent, text="", font=("Arial", 8), fg="gray")
        self.selection_count_label.pack(anchor=tk.W, padx=5, pady=2)
        self._update_selection_count()

    def _add_suggestion_row(self, container: tk.Frame, sid: str) -> None:
        row = tk.Frame(container, relief=tk.FLAT)
        row.pack(fill=tk.X, padx=2, pady=1)
        self._row_frames[sid] = row

        expand_btn = tk.Button(
            row, text="▼", width=2, relief=tk.FLAT, bd=0, command=lambda s=sid: self._toggle_expand(s)  # type: ignore[misc]
        )
        expand_btn.pack(side=tk.LEFT)
        self._expand_buttons[sid] = expand_btn

        check_char = self._suggestion_select_char(sid)
        check_btn = tk.Button(
            row,
            text=check_char,
            width=2,
            relief=tk.FLAT,
            bd=0,
            command=lambda s=sid: self._on_suggestion_checkbox_click(s),  # type: ignore[misc]
        )
        check_btn.pack(side=tk.LEFT)
        self._check_buttons[sid] = check_btn

        name_label = tk.Label(row, text=f"Suggestion {sid}", anchor=tk.W, cursor="hand2")
        name_label.pack(side=tk.LEFT, fill=tk.X, expand=True)
        name_label.bind("<Button-1>", lambda e, s=sid: self._load_all_patches_in_editor(s))  # type: ignore[misc]

        is_applied = sid in self._applied_suggestions
        btn_container = tk.Frame(row, width=90)
        btn_container.pack_propagate(False)
        btn_container.pack(side=tk.LEFT, padx=(5, 4))
        action_btn = tk.Button(
            btn_container,
            text="✓ Applied" if is_applied else "○ Apply",
            fg="#5ca668" if is_applied else self._default_btn_fg,
            anchor=tk.CENTER,
            command=lambda s=sid: self._on_action_button(s),  # type: ignore[misc]
        )
        action_btn.pack(fill=tk.BOTH, expand=True)
        self._action_buttons[sid] = action_btn

        children_frame = tk.Frame(container)
        children_frame.pack(fill=tk.X)
        self._child_frames[sid] = children_frame

        for filename in self._patches[sid]:
            self._add_file_row(children_frame, sid, filename)

    def _add_file_row(self, container: tk.Frame, sid: str, filename: str) -> None:
        row = tk.Frame(container)
        row.pack(fill=tk.X, padx=(28, 2), pady=1)

        check_char = self._file_select_char(sid, filename)
        check_btn = tk.Button(
            row,
            text=check_char,
            width=2,
            relief=tk.FLAT,
            bd=0,
            command=lambda s=sid, f=filename: self._on_file_checkbox_click(s, f),  # type: ignore[misc]
        )
        check_btn.pack(side=tk.LEFT)
        self._file_check_buttons[(sid, filename)] = check_btn

        display_name = self._patch_display_names.get((sid, filename), filename)
        name_label = tk.Label(row, text=display_name, anchor=tk.W, fg="#6699cc", cursor="hand2")
        name_label.pack(side=tk.LEFT, fill=tk.X, expand=True)
        patch_path = os.path.join(self.dot_dp_path, "patch_generator", sid, filename)
        name_label.bind("<Button-1>", lambda e, p=patch_path: self._load_patch_in_editor(p))  # type: ignore[misc]

    # ── expand / collapse ────────────────────────────────────────────────────

    def _toggle_expand(self, sid: str) -> None:
        self._expanded[sid] = not self._expanded[sid]
        if self._expanded[sid]:
            self._child_frames[sid].pack(fill=tk.X, after=self._row_frames[sid])
            self._expand_buttons[sid].config(text="▼")
        else:
            self._child_frames[sid].pack_forget()
            self._expand_buttons[sid].config(text="▶")

    # ── selection helpers ────────────────────────────────────────────────────

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

    def _on_suggestion_checkbox_click(self, sid: str) -> None:
        files = self._patches[sid]
        selected = self._selection.get(sid, [])
        if all(f in selected for f in files):
            self._selection[sid] = []
        else:
            self._selection[sid] = list(files)
        self._refresh_suggestion_row(sid)
        for filename in files:
            if (sid, filename) in self._file_check_buttons:
                self._file_check_buttons[(sid, filename)].config(text=self._file_select_char(sid, filename))
        self._save_selection()
        self._update_selection_count()

    def _on_file_checkbox_click(self, sid: str, filename: str) -> None:
        if sid not in self._selection:
            self._selection[sid] = []
        if filename in self._selection[sid]:
            self._selection[sid].remove(filename)
        else:
            self._selection[sid].append(filename)
        if (sid, filename) in self._file_check_buttons:
            self._file_check_buttons[(sid, filename)].config(text=self._file_select_char(sid, filename))
        self._refresh_suggestion_row(sid)
        self._save_selection()
        self._update_selection_count()

    def _refresh_suggestion_row(self, sid: str) -> None:
        if sid in self._check_buttons:
            self._check_buttons[sid].config(text=self._suggestion_select_char(sid))

    def _update_selection_count(self) -> None:
        total = sum(len(files) for files in self._patches.values())
        selected = sum(len(sel) for sel in self._selection.values())
        if hasattr(self, "selection_count_label"):
            self.selection_count_label.config(text=f"{selected} of {total} selected for execution")

    # ── applied status ───────────────────────────────────────────────────────

    def _reload_applied_status(self) -> None:
        self._applied_suggestions = self._load_applied_suggestions()
        for sid in self._patches:
            is_applied = sid in self._applied_suggestions
            if sid in self._action_buttons:
                self._action_buttons[sid].config(
                    text="✓ Applied" if is_applied else "○ Apply",
                    fg="#5ca668" if is_applied else self._default_btn_fg,
                )

    def _on_action_button(self, sid: str) -> None:
        if sid in self._applied_suggestions:
            self._rollback_suggestion(sid)
        else:
            self._apply_suggestion(sid)

    # ── patch applicator operations ──────────────────────────────────────────

    def _run_patch_applicator(self, args: List[str]) -> Tuple[int, str, str]:
        result = subprocess.run(
            [sys.executable, "-m", "discopop_library.PatchApplicator"] + args,
            cwd=self.dot_dp_path,
            capture_output=True,
            text=True,
        )
        return result.returncode, result.stdout, result.stderr

    def _apply_suggestion(self, sid: str) -> None:
        from discopop_library.ProjectManager.gui.mixins.helpers import ask_yes_no, show_error

        if not ask_yes_no(
            self.dialog,
            "Apply Suggestion",
            f"Apply Suggestion {sid} to the project code?\n\n"
            "This will modify source files in your project directory.\n"
            "Profiling results will be invalidated.",
        ):
            return
        retcode, stdout, stderr = self._run_patch_applicator(["--apply", sid])
        if retcode not in (0, 2):
            show_error(self.dialog, "Apply Failed", f"Failed to apply suggestion {sid}.\n\n{stderr or stdout}")
        self._reload_applied_status()

    def _rollback_suggestion(self, sid: str) -> None:
        from discopop_library.ProjectManager.gui.mixins.helpers import ask_yes_no, show_error

        if not ask_yes_no(
            self.dialog,
            "Rollback Suggestion",
            f"Roll back Suggestion {sid} from the project code?\n\n"
            "This will revert the changes made by this suggestion.",
        ):
            return
        retcode, stdout, stderr = self._run_patch_applicator(["--rollback", sid])
        if retcode not in (0, 3):
            show_error(self.dialog, "Rollback Failed", f"Failed to roll back suggestion {sid}.\n\n{stderr or stdout}")
        self._reload_applied_status()

    def _apply_selected_to_code(self) -> None:
        from discopop_library.ProjectManager.gui.mixins.helpers import ask_yes_no, show_error

        selected_sids = [sid for sid, files in self._selection.items() if files]
        if not selected_sids:
            from discopop_library.ProjectManager.gui.mixins.helpers import show_warning

            show_warning(self.dialog, "No Suggestions Selected", "No suggestions are currently selected for execution.")
            return
        if not ask_yes_no(
            self.dialog,
            "Apply Selected Suggestions",
            f"Apply {len(selected_sids)} selected suggestion(s) to the project code?\n\n"
            "This will directly modify source files in your project directory\n"
            "and invalidate any existing profiling results.\n\n"
            "Do you want to proceed?",
        ):
            return
        failed = []
        for sid in selected_sids:
            retcode, stdout, stderr = self._run_patch_applicator(["--apply", sid])
            if retcode not in (0, 2):
                failed.append(sid)
        self._reload_applied_status()
        if failed:
            show_error(
                self.dialog,
                "Partial Failure",
                f"The following suggestions could not be applied:\n{', '.join(failed)}",
            )

    def _reset_all_applied(self) -> None:
        from discopop_library.ProjectManager.gui.mixins.helpers import ask_yes_no, show_error

        if not self._applied_suggestions:
            from discopop_library.ProjectManager.gui.mixins.helpers import show_warning

            show_warning(self.dialog, "Nothing to Reset", "No suggestions are currently applied.")
            return
        if not ask_yes_no(
            self.dialog,
            "Reset All Applied Patches",
            f"Reset all {len(self._applied_suggestions)} applied suggestion(s)?\n\n"
            "This will revert all patch applicator changes to your project code.",
        ):
            return
        retcode, stdout, stderr = self._run_patch_applicator(["--clear"])
        if retcode not in (0, 3):
            show_error(self.dialog, "Reset Failed", f"Failed to reset applied patches.\n\n{stderr or stdout}")
        self._reload_applied_status()

    # ── right panel / editor ─────────────────────────────────────────────────

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

    def _load_all_patches_in_editor(self, sid: str) -> None:
        if self._current_text_modified and self._current_patch_path:
            from discopop_library.ProjectManager.gui.mixins.helpers import ask_yes_no

            if ask_yes_no(self.dialog, "Unsaved Changes", "You have unsaved changes. Save before switching?"):
                self._save_current_patch()

        self._current_patch_path = None
        self._current_text_modified = False

        parts = []
        for filename in self._patches.get(sid, []):
            patch_path = os.path.join(self.dot_dp_path, "patch_generator", sid, filename)
            try:
                with open(patch_path, "r") as f:
                    parts.append(f.read())
            except IOError as e:
                parts.append(f"Error reading {filename}: {e}\n")

        content = "\n".join(parts)
        self._text_content_on_load = content

        self.editor_text.config(state=tk.NORMAL)
        self.editor_text.delete("1.0", tk.END)
        self.editor_text.insert("1.0", content)
        self._apply_diff_highlighting()
        self._resetting_modified = True
        self.editor_text.edit_modified(False)
        self._resetting_modified = False

        self.editor_text.config(state=tk.DISABLED)
        self.save_button.config(text="Save File", state=tk.DISABLED)

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
