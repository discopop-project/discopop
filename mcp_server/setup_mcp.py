#!/usr/bin/env python3
#
# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

"""
Setup script for DiscoPoP MCP Server integration.

Configures various agents (Claude Code, etc.) to use the DiscoPoP MCP Server.
Handles JSON configuration merging and multi-agent support.
"""

import json
import sys
import argparse
import subprocess
from pathlib import Path
from typing import Optional, Dict, Any, Callable


class MCPSetup:
    """Handles MCP server setup for different agents.

    Manages configuration files for multiple agents to enable them to communicate
    with the DiscoPoP MCP Server. Supports extensible agent configuration through
    the AGENTS dictionary.
    """

    AGENTS: Dict[str, Dict[str, Any]] = {
        "claude_code": {
            "name": "Claude Code",
            "config_dir": lambda: Path.home(),
            "config_file": ".claude.json",
            "server_name": "discopop-mcp-server",
        }
    }

    def __init__(self, debug: bool = False, verbose: bool = False):
        self.debug = debug
        self.verbose = verbose

    def log(self, message: str, level: str = "INFO") -> None:
        """Print log message."""
        if level == "DEBUG" and not self.debug:
            return
        prefix = f"[{level}]" if level != "INFO" else ""
        print(f"{prefix} {message}".strip())

    def check_server_installed(self) -> bool:
        """Check if discopop-mcp-server is installed."""
        self.log("Checking if discopop-mcp-server is installed...", "DEBUG")
        try:
            result = subprocess.run(
                ["discopop-mcp-server", "--help"],
                capture_output=True,
                text=True,
                timeout=5,
            )
            if result.returncode == 0:
                self.log("✓ discopop-mcp-server is installed")
                return True
        except (subprocess.TimeoutExpired, FileNotFoundError):
            pass

        self.log(
            "✗ discopop-mcp-server not found in PATH",
            "WARN",
        )
        return False

    def find_server_path(self) -> Optional[str]:
        """Find the full path to discopop-mcp-server."""
        try:
            result = subprocess.run(
                ["which", "discopop-mcp-server"],
                capture_output=True,
                text=True,
                timeout=5,
            )
            if result.returncode == 0:
                path = result.stdout.strip()
                self.log(f"Found server at: {path}", "DEBUG")
                return path
        except (subprocess.TimeoutExpired, FileNotFoundError):
            pass

        return None

    def load_config(self, config_path: Path) -> Dict[str, Any]:
        """Load JSON config file, handling non-existent files gracefully."""
        if not config_path.exists():
            self.log(f"Creating new config file: {config_path}", "DEBUG")
            return {}

        try:
            with open(config_path, "r") as f:
                loaded: Any = json.load(f)
                return loaded if isinstance(loaded, dict) else {}
        except json.JSONDecodeError as e:
            self.log(f"✗ Invalid JSON in {config_path}: {e}", "ERROR")
            raise

    def save_config(self, config_path: Path, config: Dict[str, Any]) -> None:
        """Save JSON config file with proper formatting."""
        config_path.parent.mkdir(parents=True, exist_ok=True)
        with open(config_path, "w") as f:
            json.dump(config, f, indent=2)
        self.log(f"✓ Configuration saved to {config_path}")

    def merge_mcp_server_config(
        self,
        config: Dict[str, Any],
        server_name: str,
        command: str,
        args: Optional[list[str]] = None,
        debug: bool = False,
    ) -> Dict[str, Any]:
        """Merge MCP server configuration into existing config."""
        if "mcpServers" not in config:
            config["mcpServers"] = {}

        server_config: Dict[str, Any] = {"command": command}
        if args:
            server_config["args"] = args
        elif debug:
            server_config["args"] = ["--debug"]

        config["mcpServers"][server_name] = server_config
        return config

    def setup_agent(self, agent: str, use_debug: bool = False, use_full_path: bool = False) -> bool:
        """Setup MCP server for a specific agent."""
        if agent not in self.AGENTS:
            self.log(f"✗ Unknown agent: {agent}", "ERROR")
            return False

        agent_info = self.AGENTS[agent]
        self.log(f"Setting up {agent_info['name']}...")

        # Get server command
        if use_full_path:
            server_command = self.find_server_path()
            if not server_command:
                self.log("✗ Could not find discopop-mcp-server in PATH", "ERROR")
                return False
        else:
            server_command = "discopop-mcp-server"

        # Setup configuration directory and file
        config_dir_func: Callable[[], Path] = agent_info["config_dir"]
        config_dir = config_dir_func()
        config_path = config_dir / agent_info["config_file"]

        try:
            config = self.load_config(config_path)
            config = self.merge_mcp_server_config(
                config,
                agent_info["server_name"],
                server_command,
                args=["--debug"] if use_debug else None,
                debug=use_debug,
            )
            self.save_config(config_path, config)
            self.log(f"✓ {agent_info['name']} is now configured")
            return True
        except Exception as e:
            self.log(f"✗ Failed to setup {agent_info['name']}: {e}", "ERROR")
            if self.debug:
                import traceback

                traceback.print_exc()
            return False

    def verify_setup(self, agent: str) -> bool:
        """Verify that the agent is properly configured."""
        if agent not in self.AGENTS:
            return False

        agent_info = self.AGENTS[agent]
        config_dir_func: Callable[[], Path] = agent_info["config_dir"]
        config_path = config_dir_func() / agent_info["config_file"]

        if not config_path.exists():
            self.log(f"✗ Config file not found: {config_path}", "ERROR")
            return False

        try:
            config = self.load_config(config_path)
            if "mcpServers" in config and agent_info["server_name"] in config["mcpServers"]:
                server_config = config["mcpServers"][agent_info["server_name"]]
                command = server_config.get("command", "")
                args = server_config.get("args", [])
                self.log(f"✓ Configuration verified: {command} {' '.join(args)}")
                return True
            else:
                self.log(f"✗ DiscoPoP MCP server not found in configuration", "WARN")
                return False
        except Exception as e:
            self.log(f"✗ Failed to verify setup: {e}", "ERROR")
            return False

    def show_status(self) -> None:
        """Show current setup status."""
        self.log("DiscoPoP MCP Server Setup Status")
        self.log("=" * 40)

        # Check server installation
        if self.check_server_installed():
            self.log("Server Status: ✓ Installed")
            if path := self.find_server_path():
                self.log(f"Server Location: {path}")
        else:
            self.log("Server Status: ✗ Not installed")

        # Check agent configurations
        self.log("\nAgent Configurations:")
        for agent_key in self.AGENTS:
            if self.verify_setup(agent_key):
                self.log(f"  {agent_key}: ✓ Configured")
            else:
                self.log(f"  {agent_key}: ✗ Not configured")


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Setup DiscoPoP MCP Server for Claude agents",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  %(prog)s --setup claude_code              # Setup Claude Code
  %(prog)s --setup-all                       # Setup all agents
  %(prog)s --status                          # Show current status
  %(prog)s --verify claude_code              # Verify Claude Code setup
  %(prog)s --setup claude_code --debug       # Enable debug logging
        """,
    )

    parser.add_argument(
        "--setup",
        choices=list(MCPSetup.AGENTS.keys()),
        help="Setup MCP server for a specific agent",
    )
    parser.add_argument(
        "--setup-all",
        action="store_true",
        help="Setup MCP server for all available agents",
    )
    parser.add_argument(
        "--verify",
        choices=list(MCPSetup.AGENTS.keys()),
        help="Verify MCP server setup for a specific agent",
    )
    parser.add_argument(
        "--status",
        action="store_true",
        help="Show current setup status",
    )
    parser.add_argument(
        "--debug",
        action="store_true",
        help="Enable debug logging in the MCP server",
    )
    parser.add_argument(
        "--full-path",
        action="store_true",
        help="Use full path to discopop-mcp-server instead of just the command name",
    )
    parser.add_argument(
        "-v",
        "--verbose",
        action="store_true",
        help="Enable verbose output",
    )

    args = parser.parse_args()

    setup = MCPSetup(debug=args.verbose, verbose=args.verbose)

    # Show help if no arguments provided
    if not any([args.setup, args.setup_all, args.verify, args.status]):
        parser.print_help()
        return 0

    # Check if server is installed (not needed for verify or status)
    if args.setup or args.setup_all:
        if not setup.check_server_installed():
            setup.log(
                "Install the DiscoPoP MCP server with: pip install discopop-mcp-server",
                "ERROR",
            )
            return 1

    # Execute requested action
    try:
        if args.status:
            setup.show_status()
            return 0

        if args.setup:
            success = setup.setup_agent(args.setup, use_debug=args.debug, use_full_path=args.full_path)
            return 0 if success else 1

        if args.setup_all:
            all_success = True
            for agent in MCPSetup.AGENTS:
                success = setup.setup_agent(agent, use_debug=args.debug, use_full_path=args.full_path)
                all_success = all_success and success
            return 0 if all_success else 1

        if args.verify:
            success = setup.verify_setup(args.verify)
            return 0 if success else 1

    except KeyboardInterrupt:
        setup.log("Setup cancelled by user", "INFO")
        return 130
    except Exception as e:
        setup.log(f"Setup failed: {e}", "ERROR")
        if args.verbose:
            import traceback

            traceback.print_exc()
        return 1

    return 0


if __name__ == "__main__":
    sys.exit(main())
