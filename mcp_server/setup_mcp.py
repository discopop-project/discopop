#!/usr/bin/env python3
#
# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

"""Agent configuration helper for the DiscoPoP MCP Server.

Provides MCPSetup, which handles reading and writing agent configuration files
(e.g. ~/.claude.json) so that agents can discover and launch discopop_mcp_server.

This module is imported by server.py and its functionality is exposed through
the discopop_mcp_server CLI via the --setup / --status / --verify flags.
"""

import json
import os
import subprocess
import sys
from pathlib import Path
from typing import Any, Callable, Dict, Optional


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
            "server_name": "discopop_mcp_server",
        }
    }

    def __init__(self, verbose: bool = False):
        self.verbose = verbose
        self._venv_path = self._detect_venv()

    def log(self, message: str, level: str = "INFO") -> None:
        if level == "DEBUG" and not self.verbose:
            return
        prefix = f"[{level}]" if level != "INFO" else ""
        print(f"{prefix} {message}".strip())

    def _detect_venv(self) -> Optional[Path]:
        venv_env = os.environ.get("VIRTUAL_ENV")
        if venv_env:
            venv_path = Path(venv_env)
            if venv_path.is_dir():
                self.log(f"Detected venv: {venv_path}", "DEBUG")
                return venv_path

        if hasattr(sys, "base_prefix") and sys.prefix != sys.base_prefix:
            venv_path = Path(sys.prefix)
            self.log(f"Detected venv from sys.prefix: {venv_path}", "DEBUG")
            return venv_path

        self.log("Not running inside a virtual environment", "DEBUG")
        return None

    def _get_venv_executable_path(self, executable_name: str) -> Optional[str]:
        if not self._venv_path:
            return None

        bin_dir = "Scripts" if sys.platform == "win32" else "bin"
        executable_path = self._venv_path / bin_dir / executable_name

        if executable_path.is_file() or executable_path.with_suffix(".exe").is_file():
            return str(executable_path)

        self.log(f"Executable {executable_name} not found in venv {self._venv_path}", "DEBUG")
        return None

    def find_server_path(self) -> Optional[str]:
        try:
            result = subprocess.run(
                ["which", "discopop_mcp_server"],
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
    ) -> Dict[str, Any]:
        if "mcpServers" not in config:
            config["mcpServers"] = {}

        server_config: Dict[str, Any] = {"command": command}
        if args:
            server_config["args"] = args

        config["mcpServers"][server_name] = server_config
        return config

    def setup_agent(self, agent: str, use_debug: bool = False, use_full_path: bool = False) -> bool:
        if agent not in self.AGENTS:
            self.log(f"✗ Unknown agent: {agent}", "ERROR")
            return False

        agent_info = self.AGENTS[agent]
        self.log(f"Setting up {agent_info['name']}...")

        if use_full_path:
            server_command = self.find_server_path()
            if not server_command:
                self.log("✗ Could not find discopop_mcp_server in PATH", "ERROR")
                return False
        else:
            venv_executable = self._get_venv_executable_path("discopop_mcp_server")
            if venv_executable:
                self.log(f"Using executable from virtual environment: {venv_executable}", "DEBUG")
                server_command = venv_executable
            else:
                server_command = "discopop_mcp_server"

        config_dir_func: Callable[[], Path] = agent_info["config_dir"]
        config_path = config_dir_func() / agent_info["config_file"]

        try:
            config = self.load_config(config_path)
            config = self.merge_mcp_server_config(
                config,
                agent_info["server_name"],
                server_command,
                args=["--debug"] if use_debug else None,
            )
            self.save_config(config_path, config)
            self.log(f"✓ {agent_info['name']} is now configured")
            return True
        except Exception as e:
            self.log(f"✗ Failed to setup {agent_info['name']}: {e}", "ERROR")
            if self.verbose:
                import traceback

                traceback.print_exc()
            return False

    def verify_setup(self, agent: str) -> bool:
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
                self.log("✗ DiscoPoP MCP server not found in configuration", "WARN")
                return False
        except Exception as e:
            self.log(f"✗ Failed to verify setup: {e}", "ERROR")
            return False

    def show_status(self) -> None:
        self.log("DiscoPoP MCP Server Setup Status")
        self.log("=" * 40)
        self.log(f"Server Location: {self.find_server_path() or 'not found in PATH'}")
        self.log("\nAgent Configurations:")
        for agent_key in self.AGENTS:
            if self.verify_setup(agent_key):
                self.log(f"  {agent_key}: ✓ Configured")
            else:
                self.log(f"  {agent_key}: ✗ Not configured")
