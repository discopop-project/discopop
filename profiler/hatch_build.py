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
import subprocess
import sys
from typing import Any

from requirements import REQUIRED_EXECUTABLES, REQUIRED_APT_PACKAGES


def _is_apt_package_installed(package: str) -> bool:
    """Return True if dpkg considers the package installed. Skips check on non-dpkg systems."""
    if shutil.which("dpkg-query") is None:
        return True  # can't check; assume present on non-Debian systems
    try:
        result = subprocess.run(
            ["dpkg-query", "-W", "-f=${Status}", package],
            stdout=subprocess.PIPE,
            stderr=subprocess.DEVNULL,
            check=False,
        )
        # dpkg-query concatenates one status line per installed architecture with no
        # separator, so a multi-arch package like libc6 yields
        # "install ok installedinstall ok installed".  Split on the known prefix
        # and verify every chunk reports the package as installed.
        raw = result.stdout.decode().strip()
        chunks = [s for s in raw.split("install ok ") if s]
        return bool(chunks) and all(c == "installed" for c in chunks)
    except OSError:
        return True


def _check_system_dependencies() -> None:
    missing_exe: list[tuple[str, str]] = [
        (name, exe) for name, exe in REQUIRED_EXECUTABLES.items() if shutil.which(exe) is None
    ]
    missing_apt: list[tuple[str, str]] = [
        (name, pkg) for name, pkg in REQUIRED_APT_PACKAGES.items() if not _is_apt_package_installed(pkg)
    ]

    if not missing_exe and not missing_apt:
        return

    lines = ["", "Missing required system dependencies:", ""]
    for name, exe in missing_exe:
        # Prefer an explicit apt package name when one is listed, else use the exe name.
        apt_pkg = REQUIRED_APT_PACKAGES.get(name, name)
        lines.append(f"  - {name} (executable '{exe}')  →  sudo apt install {apt_pkg}")
    for name, pkg in missing_apt:
        lines.append(f"  - {name} (apt package '{pkg}')  →  sudo apt install {pkg}")
    lines += ["", "Install the packages above and re-run the build.", ""]
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
