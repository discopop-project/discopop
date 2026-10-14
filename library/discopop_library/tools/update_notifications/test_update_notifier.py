# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

import json
import multiprocessing
from datetime import date
from pathlib import Path

import pytest

from discopop_library.tools.update_notifications import update_notifier

MODULE = "discopop"


def _paths(home: Path) -> tuple[str, str, str, str]:
    config_dir = home / ".discopop_config"
    auto_updater_dir = config_dir / "auto_updater"
    return (
        str(config_dir),
        str(auto_updater_dir),
        str(auto_updater_dir / "settings.json"),
        str(auto_updater_dir / "modules.json"),
    )


def _hammer(home: str, iterations: int) -> None:
    """What every tool start does, repeatedly; checked today, so no network access, but modules.json is rewritten."""
    config_dir, auto_updater_dir, settings_file, modules_file = _paths(Path(home))
    for _ in range(iterations):
        update_notifier.setup_folder_structure(config_dir, auto_updater_dir, settings_file, modules_file)
        update_notifier.register_current_module(modules_file, MODULE, "api", "release")
        update_notifier.check_for_updates(modules_file, settings_file)


def test_setup_and_registration(tmp_path: Path) -> None:
    config_dir, auto_updater_dir, settings_file, modules_file = _paths(tmp_path)
    update_notifier.setup_folder_structure(config_dir, auto_updater_dir, settings_file, modules_file)
    update_notifier.register_current_module(modules_file, MODULE, "api", "release")

    assert update_notifier.automatic_updates_active(settings_file)
    modules = json.loads(Path(modules_file).read_text())
    assert modules == {MODULE: {"api_url": "api", "release_url": "release", "last_checked": None, "last_result": ""}}
    assert list(Path(auto_updater_dir).glob("*.tmp")) == []


def test_concurrent_processes_share_the_configuration(tmp_path: Path) -> None:
    config_dir, auto_updater_dir, settings_file, modules_file = _paths(tmp_path)
    update_notifier.setup_folder_structure(config_dir, auto_updater_dir, settings_file, modules_file)
    update_notifier.register_current_module(modules_file, MODULE, "api", "release")
    modules = json.loads(Path(modules_file).read_text())
    modules[MODULE]["last_checked"] = str(date.today())
    Path(modules_file).write_text(json.dumps(modules))

    ctx = multiprocessing.get_context("spawn")
    processes = [ctx.Process(target=_hammer, args=(str(tmp_path), 50)) for _ in range(16)]
    for p in processes:
        p.start()
    for p in processes:
        p.join(timeout=120)
    assert [p.exitcode for p in processes] == [0] * len(processes)
    assert MODULE in json.loads(Path(modules_file).read_text())
    assert list(Path(auto_updater_dir).glob("*.tmp")) == []


def test_run_never_raises(tmp_path: Path, monkeypatch: pytest.MonkeyPatch) -> None:
    def fail(*args: object) -> None:
        raise FileNotFoundError("modules.json")

    monkeypatch.setenv("HOME", str(tmp_path))
    monkeypatch.setattr(update_notifier, "register_current_module", fail)
    update_notifier.run(MODULE, "api", "release")
