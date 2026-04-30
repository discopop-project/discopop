# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

"""
PEP 517 build backend wrapper.

Checks for required system executables and apt packages before delegating
all build hooks to scikit_build_core.build.
"""
import shutil
import sys
from typing import Any

from requirements import REQUIRED_EXECUTABLES


def _check_system_dependencies() -> None:
    missing_exe: list[str] = [exe for exe in REQUIRED_EXECUTABLES if shutil.which(exe) is None]

    if not missing_exe:
        return

    lines = ["", "Missing executables on path:", ""]
    for exe in missing_exe:
        lines.append(f"  - executable '{exe}'")
    lines += [
        "",
        "Please refer to the installation instruction for prerequisites discribed in the README.md to prepare your environment and re-run the build.",
        "GitHub: https://github.com/discopop-project/discopop",
        "",
    ]
    print("\n".join(lines), file=sys.stderr)
    sys.exit(1)


# ---------------------------------------------------------------------------
# PEP 517 hooks — delegate everything to scikit_build_core after the check
# ---------------------------------------------------------------------------

from scikit_build_core.build import (  # noqa: E402  (import after guard logic)
    build_wheel as _build_wheel,
    build_sdist as _build_sdist,
    get_requires_for_build_wheel as _get_requires_for_build_wheel,
    get_requires_for_build_sdist as _get_requires_for_build_sdist,
)

# Try importing optional hooks; they may not exist in older versions.
try:
    from scikit_build_core.build import build_editable as _build_editable
    from scikit_build_core.build import get_requires_for_build_editable as _get_requires_for_build_editable
    from scikit_build_core.build import prepare_metadata_for_build_editable as _prepare_metadata_for_build_editable

    _has_editable = True
except ImportError:
    _has_editable = False

try:
    from scikit_build_core.build import prepare_metadata_for_build_wheel as _prepare_metadata_for_build_wheel

    _has_prepare_wheel = True
except ImportError:
    _has_prepare_wheel = False


def get_requires_for_build_wheel(config_settings: Any = None) -> list[str]:
    return _get_requires_for_build_wheel(config_settings)  # type: ignore


def get_requires_for_build_sdist(config_settings: Any = None) -> list[str]:
    return _get_requires_for_build_sdist(config_settings)  # type: ignore


def build_wheel(wheel_directory: str, config_settings: Any = None, metadata_directory: Any = None) -> str:
    _check_system_dependencies()
    return _build_wheel(wheel_directory, config_settings, metadata_directory)  # type: ignore


def build_sdist(sdist_directory: str, config_settings: Any = None) -> str:
    _check_system_dependencies()
    return _build_sdist(sdist_directory, config_settings)  # type: ignore


if _has_prepare_wheel:

    def prepare_metadata_for_build_wheel(metadata_directory: str, config_settings: Any = None) -> str:
        return _prepare_metadata_for_build_wheel(metadata_directory, config_settings)  # type: ignore


if _has_editable:

    def get_requires_for_build_editable(config_settings: Any = None) -> list[str]:
        return _get_requires_for_build_editable(config_settings)  # type: ignore

    def build_editable(wheel_directory: str, config_settings: Any = None, metadata_directory: Any = None) -> str:
        _check_system_dependencies()
        return _build_editable(wheel_directory, config_settings, metadata_directory)  # type: ignore

    def prepare_metadata_for_build_editable(metadata_directory: str, config_settings: Any = None) -> str:
        return _prepare_metadata_for_build_editable(metadata_directory, config_settings)  # type: ignore
