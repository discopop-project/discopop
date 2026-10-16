#
# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

"""DiscoPoP MCP Server - Model Context Protocol server for DiscoPoP profiling tools."""

from importlib.metadata import PackageNotFoundError, version

try:
    __version__ = version("discopop_mcp_server")
except PackageNotFoundError:  # run from a source checkout without installing
    __version__ = "unknown"


def cli() -> None:
    """CLI entry point"""
    from .server import main

    main()


__all__ = ["cli"]
