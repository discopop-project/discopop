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
discopop-mcp-server --debug
```

This starts the server in stdio mode, which is used by Claude. The `--debug` flag enables verbose logging.

## Usage Examples

### From the command line

```bash
# Basic usage
discopop-mcp-server

# With debug logging
discopop-mcp-server --debug

# SSE mode on custom port
discopop-mcp-server --mode sse --port 9000
```

### Integration with Claude Code

To use this server with Claude Code, add it to `~/.claude/settings.json`:

```json
{
  "mcpServers": {
    "discopop": {
      "command": "discopop-mcp-server",
      "args": ["--debug"]
    }
  }
}
```

See [CLAUDE_INTEGRATION.md](CLAUDE_INTEGRATION.md) for detailed setup instructions.

## Available Tools

### 1. `get_profiling_info`

Retrieves profiling information from DiscoPoP results.

**Parameters:**
- `profile_path` (string, required): Path to the DiscoPoP profile data directory
- `info_type` (string, optional): Type of information to retrieve
  - `"summary"` - High-level summary
  - `"detailed"` - Detailed metrics
  - `"statistics"` - Statistical data

**Example:**
```json
{
  "profile_path": "./example/.discopop",
  "info_type": "summary"
}
```

### 2. `execute_analysis`

Executes pattern analysis on profiled data.

**Parameters:**
- `profile_path` (string, required): Path to the DiscoPoP profile data
- `analysis_type` (string, required): Type of analysis to perform
  - `"patterns"` - Detect parallelization patterns
  - `"dependencies"` - Analyze data dependencies
  - `"recommendations"` - Generate optimization recommendations

**Example:**
```json
{
  "profile_path": "./example/.discopop",
  "analysis_type": "patterns"
}
```

### 3. `list_available_data`

Lists available profiling data and analysis results.

**Parameters:**
- `base_path` (string, required): Base path to search for DiscoPoP data

**Example:**
```json
{
  "base_path": "./example"
}
```

## Logging Output

The server logs all incoming and outgoing communication:

```
2026-05-19 10:30:00 - discopop-mcp - INFO - Starting DiscoPoP MCP Server (stdio mode)
2026-05-19 10:30:05 - discopop-mcp - INFO - → Incoming call: get_profiling_info
2026-05-19 10:30:05 - discopop-mcp - DEBUG - Arguments: {"profile_path": "./example/.discopop"}
2026-05-19 10:30:05 - discopop-mcp - INFO - ← Outgoing response: get_profiling_info
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

## Architecture

### Transport Mode

Uses **Stdio Mode** for local Claude integration:
- Bidirectional communication via stdin/stdout
- Lightweight, no additional dependencies
- Direct integration with Claude Desktop

### Tool Handler Flow

1. Claude calls a tool
2. Server logs the incoming call with arguments
3. Handler processes the request
4. Server logs the outgoing response
5. Response returned to Claude

## Shipping to Users

### Method 1: PyPI Package (Recommended)

1. Update version in `pyproject.toml`
2. Build: `python -m build`
3. Publish: `python -m twine upload dist/*`
4. Users install: `pip install discopop-mcp-server`

### Method 2: Source Distribution

Include in your DiscoPoP repository:
```bash
pip install git+https://github.com/discopop-tool/discopop.git#subdirectory=mcp_server
```

### Method 3: Bundled Binary

Use PyInstaller to create standalone executables:
```bash
pip install pyinstaller
pyinstaller --onefile mcp_server/server.py --name discopop-mcp-server
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
def _handle_your_tool(self, arguments: dict[str, Any]) -> ToolResponse:
    self._log_call("your_tool", arguments)
    # Implementation here
    self._log_response("your_tool", result)
    return ToolResponse(content=[TextContent(type="text", text=json.dumps(result))])
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

## Configuration

The server supports the following environment variables:

- `MCP_DEBUG` - Enable debug logging
- `MCP_LOG_LEVEL` - Set log level (DEBUG, INFO, WARNING, ERROR)

## Troubleshooting

### Server won't start
- Check Python version (requires 3.8+)
- Verify MCP package is installed: `pip show mcp`
- Run with `--debug` for detailed error messages

### Claude can't connect
- Verify server is running: `discopop-mcp-server --debug`
- Check claude configuration points to correct command
- Ensure stdio mode is being used (default)

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
