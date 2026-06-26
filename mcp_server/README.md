<!--
This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)

Copyright (c) 2020, Technische Universitaet Darmstadt, Germany

This software may be modified and distributed under the terms of
the 3-Clause BSD License.  See the LICENSE file in the package base
directory for details.
-->

# DiscoPoP MCP Server

A Model Context Protocol (MCP) server that exposes DiscoPoP functionality to Claude, enabling Claude to execute instrumented code locally and request analysis of profiling data.

## Overview

The DiscoPoP MCP Server bridges the gap between Claude and DiscoPoP's profiling and analysis tools. It allows Claude to:

- Retrieve profiling information from executed instrumented code
- Execute pattern analysis on profiled data
- List and discover available profiling data
- Process results and provide recommendations

## Features

- **Standalone CLI executable** - Run independently via command line
- **Local deployment** - Uses stdio for direct Claude integration
- **Persistent daemon mode** - Optional long-running server that keeps analysis data in memory between calls
- **Automatic daemon launch** - Spawns a daemon terminal on the first tool call when none is running
- **Transparent fallback** - Falls back to inline execution when no daemon is available
- **Comprehensive logging** - View all incoming calls and outgoing responses
- **Type-safe** - Full type hints throughout
- **Extensible** - Easy to add new tools and capabilities

## Installation

### Option 1: Install from source (Recommended for development)

```bash
cd mcp_server
pip install -e ".[dev]"
```

### Option 2: Install as standalone package

```bash
pip install .
```

### Option 3: Direct script usage

```bash
python mcp_server/server.py --debug
```

## Quick Start

### Run the server

```bash
discopop_mcp_server --debug
```

This starts the server in stdio mode, which is used by Claude. The `--debug` flag enables verbose logging.

## Usage Examples

### From the command line

```bash
# Default mode — proxy that routes to daemon if available, otherwise runs inline
discopop_mcp_server

# With debug logging
discopop_mcp_server --debug

# Persistent daemon — keeps analysis data in memory between calls
discopop_mcp_server --daemon

# Daemon on a custom port (default: 7777)
discopop_mcp_server --daemon --daemon-port 8888
```

### Integration with Claude Code

Use the built-in setup flag for easy integration:

```bash
discopop_mcp_server --setup claude_code
```

This automatically configures Claude Code to use the server, handling virtual environment detection, configuration directory creation, and path resolution.

See [SETUP_GUIDE.md](SETUP_GUIDE.md) for more options or [CLAUDE_INTEGRATION.md](CLAUDE_INTEGRATION.md) for detailed setup instructions.

## Available Tools

### 1. `get_configurations`

Retrieves the list of defined execution configurations from a target project.

**Parameters:**
- `project_path` (string, required): Path to the target project

Looks for configuration directories under `<project_path>/.discopop/project/configs/`.

**Example:**
```json
{
  "project_path": "./my_project"
}
```

### 2. `get_execution_results`

Retrieves execution results from prior program executions.

**Parameters:**
- `project_path` (string, required): Path to the target project

Reads `<project_path>/.discopop/project/execution_results.json`.

**Example:**
```json
{
  "project_path": "./my_project"
}
```

## Logging Output

The server logs all incoming and outgoing communication:

```
2026-05-19 10:30:00 - discopop-mcp - INFO - Starting DiscoPoP MCP Server (stdio mode)
2026-05-19 10:30:05 - discopop-mcp - INFO - → Incoming call: get_configurations
2026-05-19 10:30:05 - discopop-mcp - DEBUG - Arguments: {"project_path": "./my_project"}
2026-05-19 10:30:05 - discopop-mcp - INFO - ← Outgoing response: get_configurations
```

Enable `--debug` for full argument/response logging.

## Testing

Run the test suite:

```bash
python -m unittest discover -s mcp_server -p "test_*.py" -v
```

Or with pytest:

```bash
pytest mcp_server/test_server.py -v
```

## Guidelines for LLM Agents

> **LLM agents must not inspect `.discopop` directories directly** (e.g. via file reads, directory listings, or shell commands). All DiscoPoP data must be accessed exclusively through the `discopop_mcp_server` tool calls.

Reading raw files from `.discopop` is wasteful and unreliable: the directory contains large binary files, intermediate artefacts, and serialised objects that are expensive to parse and consume a significant number of tokens. The MCP tools return pre-processed, structured summaries that contain exactly the information needed — at a fraction of the token cost.

If a piece of information appears to be missing from the available tools, the correct response is to use the tool that produces it (e.g. run `run_pattern_detection` before calling `get_parallelization_patches`) rather than reading the underlying files directly.

## Daemon Mode

By default, Claude Code spawns a fresh `discopop_mcp_server` process for each session. This is stateless — every tool call starts from scratch and any data loaded during the session (such as the `DetectionResult` produced by `run_pattern_detection`) is discarded when the session ends.

**Daemon mode** (`--daemon`) solves this by running a single long-lived server process that keeps its internal state alive across multiple tool calls and across multiple Claude sessions.

### How it works

When Claude Code runs `discopop_mcp_server` (the default, no flags), the process acts as a **proxy**. No daemon connection is attempted at startup — the check is deferred until the first actual tool call, so idle sessions consume no extra resources.

On the **first tool call**:

1. The proxy checks whether a daemon is already listening on `localhost:7777`.
2. If no daemon is found, it attempts to **automatically spawn one** in a new terminal window using the first available terminal emulator (`gnome-terminal`, `xterm`, `konsole`, `alacritty`, `kitty`, and others).
3. Once a daemon is reachable, the proxy opens a **single persistent connection** to it and forwards all subsequent tool calls through that connection for the lifetime of the Claude session.
4. If the daemon cannot be reached (no graphical display, spawn timeout, or connection error), every tool call **falls back to inline execution** — the old stateless behaviour — so the server remains fully functional without a daemon.

### Running the daemon manually

You can start the daemon yourself instead of relying on auto-spawn:

```bash
discopop_mcp_server --daemon
```

The terminal window stays open showing daemon logs. Press `Ctrl+C` to stop it.

Use `--daemon-port` to run on a non-default port (both the daemon and the proxy must use the same value):

```bash
# Terminal 1 — daemon
discopop_mcp_server --daemon --daemon-port 8888

# Claude Code config — proxy pointing at the same port
discopop_mcp_server --daemon-port 8888
```

### Comparison

|                          | `discopop_mcp_server` (default) | `discopop_mcp_server --daemon` |
|--------------------------|--------------------------------|-------------------------------|
| Who runs it              | Claude Code (automatic)        | You, manually (or auto-spawned on first tool call) |
| Lifetime                 | One Claude session             | Until `Ctrl+C`                |
| Daemon check timing      | First tool call                | N/A                           |
| State between tool calls | None                           | Kept alive in `ToolContext`   |
| `DetectionResult` cache  | Not applicable                 | Loaded once, reused across calls |
| Fallback if unavailable  | Inline execution               | N/A                           |

### What is cached

The daemon's `ToolContext` caches the `DetectionResult` object produced by `run_pattern_detection`. On the first tool call that needs it, the result is loaded from `.discopop/explorer/detection_result_dump.json` using `jsonpickle` and kept in memory. Subsequent calls skip the deserialization step entirely. The cache is automatically invalidated when the dump file's modification time changes (i.e., after `run_pattern_detection` runs again).

## Architecture

### Transport

The default (`discopop_mcp_server`) uses **stdio** for communication with Claude Code. The daemon (`--daemon`) uses **SSE over HTTP** (Starlette + uvicorn on `localhost:7777`). The proxy bridges between the two: it presents a stdio interface to Claude Code and forwards calls to the daemon over SSE.

### Tool Handler Flow

1. Claude calls a tool via stdio
2. Proxy checks whether a daemon session is open
   - If yes: forwards the call to the daemon over SSE
   - If no: executes the tool inline
3. Server logs the incoming call and outgoing response
4. Response returned to Claude

## Shipping to Users

### Method 1: PyPI Package (Recommended)

1. Update version in `pyproject.toml`
2. Build: `python -m build`
3. Publish: `python -m twine upload dist/*`
4. Users install: `pip install discopop_mcp_server`

### Method 2: Source Distribution

Include in your DiscoPoP repository:
```bash
pip install git+https://github.com/discopop-tool/discopop.git#subdirectory=mcp_server
```

### Method 3: Bundled Binary

Use PyInstaller to create standalone executables:
```bash
pip install pyinstaller
pyinstaller --onefile mcp_server/server.py --name discopop_mcp_server
```

## Development

### Adding New Tools

1. Define tool schema in `_register_tools()`:
```python
Tool(
    name="your_tool",
    description="...",
    inputSchema={...}
)
```

2. Add handler method:
```python
def _handle_your_tool(self, arguments: dict[str, Any]) -> list[TextContent]:
    self._log_call("your_tool", arguments)
    # Implementation here
    self._log_response("your_tool", result)
    return [TextContent(type="text", text=json.dumps(result))]
```

3. Register in tool call handler:
```python
elif name == "your_tool":
    return self._handle_your_tool(arguments)
```

### Type Checking

```bash
mypy mcp_server/server.py
```

## Troubleshooting

### Claude setup issues
- Automatically configure Claude Code:
  ```bash
  discopop_mcp_server --setup claude_code
  ```
- Verify the setup with:
  ```bash
  discopop_mcp_server --verify claude_code
  ```
- See [CLAUDE_INTEGRATION.md](CLAUDE_INTEGRATION.md) for detailed troubleshooting

### Server won't start
- Check Python version (requires 3.8+)
- Verify MCP package is installed: `pip show mcp`
- Run with `--debug` for detailed error messages

### Claude can't connect
- Verify server is running: `discopop_mcp_server --debug`
- Check claude configuration points to correct command
- Ensure stdio mode is being used (default)
- Check setup status:
  ```bash
  discopop_mcp_server --status
  ```

### Missing dependencies
```bash
# Install all dependencies
pip install -e ".[dev,sse]"
```

## License

This software is part of DiscoPoP and is licensed under the 3-Clause BSD License. See the LICENSE file in the package base directory for details.

## Support

For issues, questions, or contributions:
- Email: discopop@lists.parallel.informatik.tu-darmstadt.de
- Website: https://www.discopop.tu-darmstadt.de/
- Repository: https://github.com/discopop-tool/discopop
