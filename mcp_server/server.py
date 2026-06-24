#!/usr/bin/env python3
#
# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

"""DiscoPoP MCP Server

A Model Context Protocol server that exposes DiscoPoP functionality to LLM Agents.
Allows an LLM to drive the full instrumentation pipeline — compile, profile,
detect patterns, and retrieve patches — without human intervention.
"""

import logging
import sys
from typing import Any, Callable

from mcp.server import Server
from mcp.types import TextContent, Tool

from mcp_server.setup_mcp import MCPSetup

from mcp_server.tools import (
    check_configurations_status,
    check_hotspot_analysis_status,
    check_hotspot_profiling_status,
    check_parallelization_status,
    check_profiling_status,
    create_execution_configuration,
    get_configurations,
    get_execution_results,
    get_parallelization_patches,
    initialize_discopop_directory,
    instrument_for_hotspot_detection,
    instrument_project,
    run_hotspot_analysis,
    run_hotspot_profiling,
    run_instrumented_binary,
    run_pattern_detection,
    set_compile_script,
)
from mcp_server.tools.helpers import ToolContext

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(name)s - %(levelname)s - %(message)s",
)
logger = logging.getLogger("discopop-mcp")

_ALL_TOOLS = [
    check_configurations_status,
    check_profiling_status,
    check_parallelization_status,
    check_hotspot_profiling_status,
    check_hotspot_analysis_status,
    get_configurations,
    get_execution_results,
    initialize_discopop_directory,
    set_compile_script,
    create_execution_configuration,
    instrument_for_hotspot_detection,
    run_hotspot_profiling,
    run_hotspot_analysis,
    instrument_project,
    run_instrumented_binary,
    run_pattern_detection,
    get_parallelization_patches,
]


class DiscoPopMCPServer:
    def __init__(self, debug: bool = False):
        self.server = Server("discopop_mcp_server")
        self.debug = debug
        if debug:
            logger.setLevel(logging.DEBUG)
        self._ctx = ToolContext(debug=debug)
        self._register_tools()

    def _register_tools(self) -> None:
        _dispatch: dict[str, Callable[[dict[str, Any], ToolContext], list[TextContent]]] = {
            mod.TOOL.name: mod.handle for mod in _ALL_TOOLS
        }

        @self.server.call_tool()  # type: ignore[misc, untyped-decorator]
        async def handle_tool_call(name: str, arguments: dict[str, Any]) -> list[TextContent]:
            self._ctx.log_call(name, arguments)
            handler = _dispatch.get(name)
            if handler:
                return handler(arguments, self._ctx)
            error_msg = f"Unknown tool: {name}"
            logger.error(error_msg)
            return [TextContent(type="text", text=error_msg)]

        @self.server.list_tools()  # type: ignore[misc, untyped-decorator]
        async def list_tools() -> list[Tool]:
            tools = [mod.TOOL for mod in _ALL_TOOLS]
            logger.debug(f"Listed {len(tools)} available tools")
            return tools

    async def run(self) -> None:
        """Run the server using stdio transport."""
        from mcp.server.stdio import stdio_server

        logger.info("Starting DiscoPoP MCP Server (stdio mode)")
        async with stdio_server() as (read_stream, write_stream):
            await self.server.run(read_stream, write_stream, self.server.create_initialization_options())


def main() -> None:
    import argparse
    import asyncio

    agent_choices = list(MCPSetup.AGENTS.keys())

    parser = argparse.ArgumentParser(
        description="DiscoPoP MCP Server - Exposes DiscoPoP functionality to Claude",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog=f"""
Examples:
  %(prog)s                        # Start the MCP server (stdio mode)
  %(prog)s --debug                # Start with debug logging
  %(prog)s --setup <agent>        # Configure a specific agent
  %(prog)s --setup <agent> --debug  # Configure with debug logging enabled
  %(prog)s --setup-all            # Configure all agents
  %(prog)s --verify <agent>       # Verify agent setup
  %(prog)s --status               # Show current setup status

Available agents: {', '.join(agent_choices)}
        """,
    )

    parser.add_argument(
        "--debug",
        action="store_true",
        help="Enable debug logging (server mode) or configure server with debug logging (setup mode)",
    )

    setup_group = parser.add_argument_group("setup")
    setup_group.add_argument(
        "--setup",
        choices=agent_choices,
        metavar="AGENT",
        help=f"Configure MCP server for a specific agent (choices: {', '.join(agent_choices)})",
    )
    setup_group.add_argument(
        "--setup-all",
        action="store_true",
        help="Configure MCP server for all available agents",
    )
    setup_group.add_argument(
        "--verify",
        choices=agent_choices,
        metavar="AGENT",
        help="Verify MCP server setup for a specific agent",
    )
    setup_group.add_argument(
        "--status",
        action="store_true",
        help="Show current setup status",
    )
    setup_group.add_argument(
        "--full-path",
        action="store_true",
        help="Use full path to discopop_mcp_server instead of just the command name",
    )
    setup_group.add_argument(
        "-v",
        "--verbose",
        action="store_true",
        help="Enable verbose output during setup",
    )

    args = parser.parse_args()

    is_setup_mode = any([args.setup, args.setup_all, args.verify, args.status])

    if is_setup_mode:
        setup = MCPSetup(verbose=args.verbose)
        try:
            if args.status:
                setup.show_status()
                sys.exit(0)

            if args.setup:
                success = setup.setup_agent(args.setup, use_debug=args.debug, use_full_path=args.full_path)
                sys.exit(0 if success else 1)

            if args.setup_all:
                all_success = all(
                    setup.setup_agent(
                        agent, use_debug=args.debug, use_full_path=args.full_path, skip_if_not_installed=True
                    )
                    for agent in MCPSetup.AGENTS
                )
                sys.exit(0 if all_success else 1)

            if args.verify:
                success = setup.verify_setup(args.verify)
                sys.exit(0 if success else 1)

        except KeyboardInterrupt:
            print("Setup cancelled by user")
            sys.exit(130)
        except Exception as e:
            print(f"Setup failed: {e}", file=sys.stderr)
            if args.verbose:
                import traceback

                traceback.print_exc()
            sys.exit(1)
    else:
        server = DiscoPopMCPServer(debug=args.debug)
        try:
            asyncio.run(server.run())
        except KeyboardInterrupt:
            logger.info("Server shutting down...")
            sys.exit(0)
        except Exception as e:
            logger.error(f"Fatal error: {e}", exc_info=True)
            sys.exit(1)


if __name__ == "__main__":
    main()
