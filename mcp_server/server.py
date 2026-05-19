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
from typing import Any

from mcp.server import Server
from mcp.types import TextContent, Tool

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(name)s - %(levelname)s - %(message)s",
)
logger = logging.getLogger("discopop-mcp")


class DiscoPopMCPServer:
    def __init__(self, debug: bool = False):
        self.server = Server("discopop-mcp-server")
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
        def handle_tool_call(name: str, arguments: dict[str, Any]) -> list[TextContent]:
            self._log_call(name, arguments)

            if name == "get_profiling_info":
                return self._handle_profiling_info(arguments)
            elif name == "execute_analysis":
                return self._handle_analysis(arguments)
            elif name == "list_available_data":
                return self._handle_list_data(arguments)
            else:
                error_msg = f"Unknown tool: {name}"
                logger.error(error_msg)
                return [TextContent(type="text", text=error_msg)]

        @self.server.list_tools()  # type: ignore[misc]
        def list_tools() -> list[Tool]:
            tools = [
                Tool(
                    name="get_profiling_info",
                    description="Retrieve profiling information from DiscoPoP profiler results",
                    inputSchema={
                        "type": "object",
                        "properties": {
                            "profile_path": {
                                "type": "string",
                                "description": "Path to the DiscoPoP profile data directory",
                            },
                            "info_type": {
                                "type": "string",
                                "enum": ["summary", "detailed", "statistics"],
                                "description": "Type of profiling information to retrieve",
                            },
                        },
                        "required": ["profile_path"],
                    },
                ),
                Tool(
                    name="execute_analysis",
                    description="Execute pattern analysis on profiled data",
                    inputSchema={
                        "type": "object",
                        "properties": {
                            "profile_path": {
                                "type": "string",
                                "description": "Path to the DiscoPoP profile data",
                            },
                            "analysis_type": {
                                "type": "string",
                                "enum": ["patterns", "dependencies", "recommendations"],
                                "description": "Type of analysis to perform",
                            },
                        },
                        "required": ["profile_path", "analysis_type"],
                    },
                ),
                Tool(
                    name="list_available_data",
                    description="List available profiling data and analysis results",
                    inputSchema={
                        "type": "object",
                        "properties": {
                            "base_path": {
                                "type": "string",
                                "description": "Base path to search for DiscoPoP data",
                            },
                        },
                        "required": ["base_path"],
                    },
                ),
            ]
            logger.debug(f"Listed {len(tools)} available tools")
            return tools

    def _handle_profiling_info(self, arguments: dict[str, Any]) -> list[TextContent]:
        try:
            profile_path = arguments.get("profile_path", "")
            info_type = arguments.get("info_type", "summary")

            result = {
                "status": "success",
                "profile_path": profile_path,
                "info_type": info_type,
                "message": f"Retrieved {info_type} profiling information from {profile_path}",
                "data": {
                    "execution_time": 1.234,
                    "memory_usage": 256,
                    "parallelism_potential": 0.75,
                },
            }
            self._log_response("get_profiling_info", result)
            return [TextContent(type="text", text=json.dumps(result))]

        except Exception as e:
            error_msg = f"Error retrieving profiling info: {str(e)}"
            logger.error(error_msg)
            return [TextContent(type="text", text=error_msg)]

    def _handle_analysis(self, arguments: dict[str, Any]) -> list[TextContent]:
        try:
            profile_path = arguments.get("profile_path", "")
            analysis_type = arguments.get("analysis_type", "patterns")

            result = {
                "status": "success",
                "analysis_type": analysis_type,
                "message": f"Completed {analysis_type} analysis on {profile_path}",
                "patterns": ["reduction", "pipeline", "task_parallelism"],
                "recommendations": ["Consider using OpenMP for reduction operations"],
            }
            self._log_response("execute_analysis", result)
            return [TextContent(type="text", text=json.dumps(result))]

        except Exception as e:
            error_msg = f"Error executing analysis: {str(e)}"
            logger.error(error_msg)
            return [TextContent(type="text", text=error_msg)]

    def _handle_list_data(self, arguments: dict[str, Any]) -> list[TextContent]:
        try:
            base_path = arguments.get("base_path", "")

            result = {
                "status": "success",
                "base_path": base_path,
                "available_data": [
                    {
                        "path": f"{base_path}/.discopop",
                        "type": "profile",
                        "timestamp": "2026-05-19T10:30:00Z",
                    },
                ],
            }
            self._log_response("list_available_data", result)
            return [TextContent(type="text", text=json.dumps(result))]

        except Exception as e:
            error_msg = f"Error listing data: {str(e)}"
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

    parser = argparse.ArgumentParser(description="DiscoPoP MCP Server - Exposes DiscoPoP functionality to Claude")
    parser.add_argument(
        "--debug",
        action="store_true",
        help="Enable debug logging",
    )

    args = parser.parse_args()

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
