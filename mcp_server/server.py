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

import asyncio
import json
import logging
import sys
import time
from typing import Any, Callable, Optional

from mcp.server import Server
from mcp.types import TextContent, Tool

from mcp_server.setup_mcp import MCPSetup

from mcp_server.tools import (
    check_configurations_status,
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

_SERVER_INSTRUCTIONS = (
    "All DiscoPoP data must be accessed exclusively through the tool calls provided by this server. "
    "Do not read, list, or inspect .discopop directories or their contents directly via file reads, "
    "directory listings, or shell commands. "
    "Those directories contain large binary files, intermediate artefacts, and serialised objects "
    "that are expensive to parse and consume a large number of tokens. "
    "The MCP tools return pre-processed, structured summaries at a fraction of the token cost. "
    "If information appears to be missing, use the tool that produces it "
    "(e.g. run run_pattern_detection before calling get_parallelization_patches) "
    "rather than reading the underlying files directly."
)

_ALL_TOOLS = [
    check_configurations_status,
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

DEFAULT_DAEMON_PORT = 7777


def _is_daemon_running(port: int) -> bool:
    import socket

    try:
        with socket.create_connection(("localhost", port), timeout=0.5):
            return True
    except OSError:
        return False


async def _wait_for_daemon(port: int, max_wait: float = 5.0) -> bool:
    import time

    deadline = time.monotonic() + max_wait
    while time.monotonic() < deadline:
        if _is_daemon_running(port):
            return True
        await asyncio.sleep(0.25)
    return False


def _try_spawn_daemon(port: int, debug: bool) -> bool:
    import os
    import shlex
    import shutil
    import subprocess

    if not os.environ.get("DISPLAY") and not os.environ.get("WAYLAND_DISPLAY"):
        logger.debug("No display available, skipping daemon terminal spawn")
        return False

    daemon_exe = shutil.which("discopop_mcp_server") or sys.argv[0]
    daemon_args = [daemon_exe, "--daemon", "--daemon-port", str(port)]
    if debug:
        daemon_args.append("--debug")
    daemon_cmd = shlex.join(daemon_args)
    shell_cmd = (
        'printf "\\033]0;DiscoPoP MCP Server Daemon\\007"; '
        f"{daemon_cmd}; "
        'echo; echo "DiscoPoP MCP daemon stopped. Press Enter to close."; read'
    )

    terminals = [
        ["gnome-terminal", "--", "bash", "-c", shell_cmd],
        ["xterm", "-e", "bash", "-c", shell_cmd],
        ["konsole", "-e", "bash", "-c", shell_cmd],
        ["alacritty", "-e", "bash", "-c", shell_cmd],
        ["kitty", "--", "bash", "-c", shell_cmd],
        ["xfce4-terminal", "--", "bash", "-c", shell_cmd],
        ["mate-terminal", "--", "bash", "-c", shell_cmd],
        ["tilix", "-e", "bash", "-c", shell_cmd],
        ["lxterminal", "-e", f"bash -c {shlex.quote(shell_cmd)}"],
    ]

    for cmd in terminals:
        if shutil.which(cmd[0]):
            try:
                subprocess.Popen(
                    cmd,
                    close_fds=True,
                    start_new_session=True,
                    stdout=subprocess.DEVNULL,
                    stderr=subprocess.DEVNULL,
                )
                logger.info(f"Spawned DiscoPoP MCP daemon terminal using {cmd[0]}")
                return True
            except OSError:
                continue

    logger.warning("No suitable terminal emulator found for daemon spawn")
    return False


class DiscoPopMCPServer:
    def __init__(self, debug: bool = False):
        self.server = Server("discopop_mcp_server", instructions=_SERVER_INSTRUCTIONS)
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
            if not handler:
                error_msg = f"Unknown tool: {name}"
                logger.error(error_msg)
                raise Exception(error_msg)

            logger.info(f"▶ Executing: {name}")
            start_time = time.time()
            try:
                result = handler(arguments, self._ctx)
                elapsed = time.time() - start_time
                # Raise on tool errors so the MCP client receives isError=true.
                # The exception message is the JSON payload, preserving all error detail.
                if result:
                    try:
                        data = json.loads(result[0].text)
                        if isinstance(data, dict) and data.get("status") == "error":
                            logger.info(f"✗ Failed: {name} ({elapsed:.2f}s)")
                            raise Exception(result[0].text)
                    except json.JSONDecodeError:
                        pass
                logger.info(f"✓ Completed: {name} ({elapsed:.2f}s)")
                return result
            except Exception:
                elapsed = time.time() - start_time
                logger.info(f"✗ Failed: {name} ({elapsed:.2f}s)")
                raise

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


class DiscoPopMCPProxy:
    """Default stdio entry point.

    The daemon is not contacted at startup. On the first actual tool call the
    proxy checks whether a daemon is already listening on ``daemon_port``. If
    not, it attempts to spawn one in a new terminal window. Once a daemon is
    reachable, a single ClientSession is kept open for the lifetime of this
    process and all subsequent tool calls are forwarded through it — giving the
    daemon's ToolContext a chance to keep expensive data structures (e.g.
    DetectionResult) in memory between calls.

    If the daemon cannot be reached (no display, spawn timeout, connection
    error), every tool call falls back to inline execution so that the server
    remains fully functional without a daemon.
    """

    def __init__(self, daemon_port: int = DEFAULT_DAEMON_PORT, debug: bool = False):
        self.daemon_port = daemon_port
        self.debug = debug
        self._session: Optional[Any] = None  # mcp.client.session.ClientSession when connected
        # Inline fallback components (used when daemon is unavailable)
        self._ctx = ToolContext(debug=debug)
        self._dispatch: dict[str, Callable[[dict[str, Any], ToolContext], list[TextContent]]] = {
            mod.TOOL.name: mod.handle for mod in _ALL_TOOLS
        }
        self.server = Server("discopop_mcp_server", instructions=_SERVER_INSTRUCTIONS)
        # Lazy daemon connection state
        self._tg: Optional[Any] = None  # anyio task group set by run()
        self._daemon_init_started: bool = False
        self._daemon_session_ready: Optional[asyncio.Event] = None
        self._register_tools()

    def _register_tools(self) -> None:
        @self.server.list_tools()  # type: ignore[misc, untyped-decorator]
        async def list_tools() -> list[Tool]:
            # Tool list is static — no daemon connection needed for discovery.
            return [mod.TOOL for mod in _ALL_TOOLS]

        @self.server.call_tool()  # type: ignore[misc, untyped-decorator]
        async def handle_tool_call(name: str, arguments: dict[str, Any]) -> list[TextContent]:
            await self._ensure_daemon()
            if self._session is not None:
                try:
                    result = await self._session.call_tool(name, arguments)
                    return result.content  # type: ignore[no-any-return]
                except Exception:
                    logger.warning(f"Daemon disconnected during {name}, switching to inline execution")
                    self._session = None
            # Inline fallback — identical error-handling to DiscoPopMCPServer
            self._ctx.log_call(name, arguments)
            handler = self._dispatch.get(name)
            if not handler:
                error_msg = f"Unknown tool: {name}"
                logger.error(error_msg)
                raise Exception(error_msg)
            inline_result = handler(arguments, self._ctx)
            if inline_result:
                try:
                    data = json.loads(inline_result[0].text)
                    if isinstance(data, dict) and data.get("status") == "error":
                        raise Exception(inline_result[0].text)
                except json.JSONDecodeError:
                    pass
            return inline_result

    async def _ensure_daemon(self) -> None:
        """Connect to (or spawn) the daemon on the first tool call. Idempotent.

        Safe to call concurrently: Python's cooperative scheduler guarantees no
        context switch between the flag check and the flag set (no await in
        between), so at most one caller proceeds to initialisation.
        """
        if self._daemon_init_started:
            if self._daemon_session_ready is not None:
                await self._daemon_session_ready.wait()
            return

        self._daemon_init_started = True
        self._daemon_session_ready = asyncio.Event()

        running = _is_daemon_running(self.daemon_port)
        if not running:
            if _try_spawn_daemon(self.daemon_port, self.debug):
                running = await _wait_for_daemon(self.daemon_port)
                if not running:
                    logger.warning("Daemon spawn timed out; using inline execution")

        if running and self._tg is not None:
            self._tg.start_soon(self._daemon_conn)
            await self._daemon_session_ready.wait()
        else:
            self._daemon_session_ready.set()

    async def _daemon_conn(self) -> None:
        """Background task that holds the SSE connection to the daemon alive."""
        import anyio
        from mcp.client.session import ClientSession
        from mcp.client.sse import sse_client

        daemon_url = f"http://localhost:{self.daemon_port}/sse"
        try:
            async with sse_client(daemon_url) as (r, w):
                async with ClientSession(r, w) as session:
                    await session.initialize()
                    self._session = session
                    logger.info(f"Connected to DiscoPoP MCP daemon on port {self.daemon_port}")
                    if self._daemon_session_ready is not None:
                        self._daemon_session_ready.set()
                    # Keep the session open until cancelled by the stdio loop finishing.
                    await anyio.Event().wait()
        except Exception as e:
            logger.warning(f"Daemon connection error: {e}; remaining calls will use inline execution")
            self._session = None
            if self._daemon_session_ready is not None and not self._daemon_session_ready.is_set():
                self._daemon_session_ready.set()

    async def run(self) -> None:
        import anyio
        from mcp.server.stdio import stdio_server

        async with stdio_server() as (read, write):
            async with anyio.create_task_group() as tg:
                self._tg = tg

                async def _stdio_loop() -> None:
                    try:
                        await self.server.run(read, write, self.server.create_initialization_options())
                    finally:
                        tg.cancel_scope.cancel()

                tg.start_soon(_stdio_loop)


def _run_daemon(port: int, debug: bool) -> None:
    """Run as a persistent SSE daemon that keeps ToolContext (and its caches) alive."""
    import uvicorn
    from starlette.applications import Starlette
    from starlette.requests import Request
    from starlette.responses import Response
    from starlette.routing import Mount, Route

    from mcp.server.sse import SseServerTransport

    mcp_instance = DiscoPopMCPServer(debug=debug)
    sse = SseServerTransport("/messages/")

    async def handle_sse(request: Request) -> Response:
        async with sse.connect_sse(request.scope, request.receive, request._send) as streams:
            await mcp_instance.server.run(
                streams[0],
                streams[1],
                mcp_instance.server.create_initialization_options(),
            )
        return Response()

    app = Starlette(
        routes=[
            Route("/sse", endpoint=handle_sse),
            Mount("/messages/", app=sse.handle_post_message),
        ]
    )

    logger.info(f"Starting DiscoPoP MCP daemon on port {port}")
    uvicorn.run(app, host="127.0.0.1", port=port, log_level="warning")


def main() -> None:
    import argparse

    agent_choices = list(MCPSetup.AGENTS.keys())

    parser = argparse.ArgumentParser(
        description="DiscoPoP MCP Server - Exposes DiscoPoP functionality to Claude",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog=f"""
Examples:
  %(prog)s                             # Start (proxy → daemon if running, else inline)
  %(prog)s --debug                     # Start with debug logging
  %(prog)s --daemon                    # Start as a persistent daemon (keeps state in memory)
  %(prog)s --daemon --daemon-port 8888 # Daemon on a custom port
  %(prog)s --setup <agent>             # Configure a specific agent
  %(prog)s --setup <agent> --debug     # Configure with debug logging enabled
  %(prog)s --setup-all                 # Configure all agents
  %(prog)s --verify <agent>            # Verify agent setup
  %(prog)s --status                    # Show current setup status

Available agents: {', '.join(agent_choices)}
        """,
    )

    parser.add_argument(
        "--debug",
        action="store_true",
        help="Enable debug logging",
    )
    parser.add_argument(
        "--daemon",
        action="store_true",
        help="Run as a persistent SSE daemon that keeps ToolContext alive between calls",
    )
    parser.add_argument(
        "--daemon-port",
        type=int,
        default=DEFAULT_DAEMON_PORT,
        metavar="PORT",
        help=f"Port used by the daemon (and checked by the proxy). Default: {DEFAULT_DAEMON_PORT}",
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
    elif args.daemon:
        try:
            _run_daemon(args.daemon_port, args.debug)
        except KeyboardInterrupt:
            logger.info("Daemon shutting down...")
            sys.exit(0)
        except Exception as e:
            logger.error(f"Daemon fatal error: {e}", exc_info=True)
            sys.exit(1)
    else:
        proxy = DiscoPopMCPProxy(daemon_port=args.daemon_port, debug=args.debug)
        try:
            asyncio.run(proxy.run())
        except KeyboardInterrupt:
            logger.info("Server shutting down...")
            sys.exit(0)
        except Exception as e:
            logger.error(f"Fatal error: {e}", exc_info=True)
            sys.exit(1)


if __name__ == "__main__":
    main()
