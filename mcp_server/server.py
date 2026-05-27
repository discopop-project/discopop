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

A Model Context Protocol server that exposes DiscoPoP functionality to Claude.
Allows remote execution of instrumented code and analysis of profiling data.
"""

import json
import logging
import sys
from pathlib import Path
from typing import Any

from mcp.server import Server
from mcp.types import TextContent, Tool

from setup_mcp import MCPSetup

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(name)s - %(levelname)s - %(message)s",
)
logger = logging.getLogger("discopop-mcp")


class DiscoPopMCPServer:
    def __init__(self, debug: bool = False):
        self.server = Server("discopop_mcp_server")
        self.debug = debug
        if debug:
            logger.setLevel(logging.DEBUG)
        self._register_tools()

    def _log_call(self, tool_name: str, arguments: dict[str, Any]) -> None:
        logger.info(f"→ Incoming call: {tool_name}")
        if self.debug:
            logger.debug(f"  Arguments: {json.dumps(arguments, indent=2)}")

    def _log_response(self, tool_name: str, result: Any) -> None:
        logger.info(f"← Outgoing response: {tool_name}")
        if self.debug:
            logger.debug(f"  Result: {json.dumps(result if isinstance(result, dict) else str(result), indent=2)}")

    def _register_tools(self) -> None:
        @self.server.call_tool()  # type: ignore[misc]
        async def handle_tool_call(name: str, arguments: dict[str, Any]) -> list[TextContent]:
            self._log_call(name, arguments)

            if name == "get_configurations":
                return self._handle_get_configurations(arguments)
            elif name == "get_execution_results":
                return self._handle_get_execution_results(arguments)
            else:
                error_msg = f"Unknown tool: {name}"
                logger.error(error_msg)
                return [TextContent(type="text", text=error_msg)]

        @self.server.list_tools()  # type: ignore[misc]
        async def list_tools() -> list[Tool]:
            tools = [
                Tool(
                    name="get_configurations",
                    description="Retrieve list of defined execution configurations from a target project",
                    inputSchema={
                        "type": "object",
                        "properties": {
                            "project_path": {
                                "type": "string",
                                "description": "Path to the target project",
                            },
                        },
                        "required": ["project_path"],
                    },
                ),
                Tool(
                    name="get_execution_results",
                    description="Retrieve execution results from prior program executions",
                    inputSchema={
                        "type": "object",
                        "properties": {
                            "project_path": {
                                "type": "string",
                                "description": "Path to the target project",
                            },
                        },
                        "required": ["project_path"],
                    },
                ),
            ]
            logger.debug(f"Listed {len(tools)} available tools")
            return tools

    def _handle_get_configurations(self, arguments: dict[str, Any]) -> list[TextContent]:
        try:
            project_path = arguments.get("project_path", "")
            configs_dir = Path(project_path) / ".discopop" / "project" / "configs"

            configurations = []
            if configs_dir.exists() and configs_dir.is_dir():
                for config_name in sorted(configs_dir.iterdir()):
                    if config_name.is_dir():
                        configurations.append(config_name.name)

            result = {
                "status": "success",
                "project_path": project_path,
                "configurations": configurations,
            }
            self._log_response("get_configurations", result)
            return [TextContent(type="text", text=json.dumps(result))]

        except Exception as e:
            error_msg = f"Error retrieving configurations: {str(e)}"
            logger.error(error_msg)
            return [TextContent(type="text", text=error_msg)]

    def _handle_get_execution_results(self, arguments: dict[str, Any]) -> list[TextContent]:
        try:
            project_path = arguments.get("project_path", "")
            results_file = Path(project_path) / ".discopop" / "project" / "execution_results.json"

            execution_results = {}
            if results_file.exists() and results_file.is_file():
                with open(results_file, "r") as f:
                    execution_results = json.load(f)

            result = {
                "status": "success",
                "project_path": project_path,
                "execution_results": execution_results,
            }
            self._log_response("get_execution_results", result)
            return [TextContent(type="text", text=json.dumps(result))]

        except Exception as e:
            error_msg = f"Error retrieving execution results: {str(e)}"
            logger.error(error_msg)
            return [TextContent(type="text", text=error_msg)]

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
  %(prog)s                              # Start the MCP server (stdio mode)
  %(prog)s --debug                      # Start with debug logging
  %(prog)s --setup claude_code          # Configure Claude Code
  %(prog)s --setup-all                  # Configure all agents
  %(prog)s --status                     # Show current setup status
  %(prog)s --verify claude_code         # Verify Claude Code setup
  %(prog)s --setup claude_code --debug  # Configure with debug logging enabled
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
                    setup.setup_agent(agent, use_debug=args.debug, use_full_path=args.full_path)
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
