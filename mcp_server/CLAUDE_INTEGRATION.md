<!--
This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)

Copyright (c) 2020, Technische Universitaet Darmstadt, Germany

This software may be modified and distributed under the terms of
the 3-Clause BSD License.  See the LICENSE file in the package base
directory for details.
-->

# Integrating DiscoPoP MCP Server with Claude

This guide shows how to configure Claude Code to use the DiscoPoP MCP Server.

## Prerequisites

1. Install the DiscoPoP MCP Server:
```bash
pip install discopop_mcp_server
```

2. Verify installation:
```bash
discopop_mcp_server --help
```

## Quick Setup (Recommended)

Run the built-in setup command:

```bash
discopop_mcp_server --setup claude_code
```

This will:
- ✓ Automatically detect your virtual environment (if any)
- ✓ Create the configuration directory
- ✓ Merge configuration with any existing settings
- ✓ Use the correct executable path

Verify the setup:
```bash
discopop_mcp_server --verify claude_code
```

For more setup options (debug logging, status checking, etc.), see [SETUP_GUIDE.md](SETUP_GUIDE.md).

## Using with Claude Code

Once configured, you can ask Claude:
> "What tools do you have available?"

Claude will list the available DiscoPoP tools.

## Claude Code (CLI) - Manual Configuration

For advanced users who prefer manual configuration, Claude Code uses MCP server configuration stored in your local Claude directory.

### 1. Create configuration directory

```bash
mkdir -p ~/.claude
```

### 2. Add MCP server configuration

Create or edit `~/.claude/settings.json` and add the DiscoPoP server configuration:

```json
{
  "mcpServers": {
    "discopop_mcp_server": {
      "command": "discopop_mcp_server",
      "args": ["--debug"]
    }
  }
}
```

### 3. Verify the configuration

Test that the server starts:
```bash
discopop_mcp_server --debug
```

You should see output like:
```
2026-05-19 10:30:00 - discopop-mcp - INFO - Starting DiscoPoP MCP Server (stdio mode)
```

## Using the Server

Once configured, you can ask Claude to:

1. **Retrieve profiling data:**
   > "Show me a summary of the profiling data in ./example/.discopop"

2. **Analyze patterns:**
   > "Analyze the parallelization patterns in my profiled code"

3. **List available data:**
   > "What profiling data is available in this directory?"

Claude will use the MCP server to fetch this information and provide analysis and recommendations.

## Configuration Options

### Using the Setup Utility (Recommended)

The `--setup` flag handles these options automatically:

**Enable debug logging:**
```bash
discopop_mcp_server --setup claude_code --debug
```

**Check virtual environment detection:**
```bash
discopop_mcp_server --setup claude_code --verbose
```

It automatically:
- ✓ Detects and uses your virtual environment
- ✓ Finds the correct executable path
- ✓ Adds debug flags if requested
- ✓ Preserves other configuration

See [SETUP_GUIDE.md](SETUP_GUIDE.md) for all available options.

### Manual Configuration Options

For manual configuration, you can customize these settings:

**Enable debug logging:**
```json
{
  "mcpServers": {
    "discopop_mcp_server": {
      "command": "discopop_mcp_server",
      "args": ["--debug"]
    }
  }
}
```

**Using a custom Python environment:**
```json
{
  "mcpServers": {
    "discopop_mcp_server": {
      "command": "/path/to/venv/bin/discopop_mcp_server",
      "args": ["--debug"]
    }
  }
}
```

**Multiple MCP servers:**
```json
{
  "mcpServers": {
    "discopop_mcp_server": {
      "command": "discopop_mcp_server",
      "args": ["--debug"]
    },
    "other-server": {
      "command": "other-server-command",
      "args": []
    }
  }
}
```

## Troubleshooting

### General troubleshooting

Start with the verification and status commands:

```bash
# Check setup status
discopop_mcp_server --status

# Verify Claude Code configuration
discopop_mcp_server --verify claude_code

# Enable verbose output for debugging
discopop_mcp_server --setup claude_code --verbose
```

### Server not found

**Error:** "command not found: discopop_mcp_server"

**Solution:**
1. Install the package: `pip install discopop_mcp_server`
2. Verify installation: `which discopop_mcp_server`
3. Re-run setup, which automatically handles paths:
   ```bash
   discopop_mcp_server --setup claude_code
   ```

### Server fails to start

**Error:** Server exits with error

**Solution:**
1. Test the server directly: `discopop_mcp_server --debug`
2. Check for error messages in the output
3. Re-run setup with verbose output:
   ```bash
   discopop_mcp_server --setup claude_code --verbose
   ```
4. For manual config, verify the command path is correct

### Tools not appearing

**Error:** Claude doesn't see DiscoPoP tools

**Solution:**
1. Verify configuration:
   ```bash
   discopop_mcp_server --verify claude_code
   ```
2. Check that the server can start: `discopop_mcp_server --help`
3. Try restarting Claude Code
4. Run setup with debug:
   ```bash
   discopop_mcp_server --setup claude_code --debug
   ```

### JSON syntax errors

**Error:** "Invalid JSON in settings.json"

**Solution:**
- Re-run setup to let it handle it:
  ```bash
  discopop_mcp_server --setup claude_code
  ```
- For manual config:
  - Use a JSON validator: `cat ~/.claude/settings.json | python -m json.tool`
  - Ensure all strings use double quotes `"`
  - Check that all commas and braces are balanced

## Configuration Format

The MCP server configuration uses this format:

```json
{
  "mcpServers": {
    "server-name": {
      "command": "executable-name",
      "args": ["arg1", "arg2"],
      "env": {
        "OPTIONAL_ENV_VAR": "value"
      }
    }
  }
}
```

**Fields:**
- `command` (required): The executable to run
- `args` (optional): Array of command-line arguments
- `env` (optional): Environment variables to pass to the process

## Examples

### Example 1: Basic configuration

```json
{
  "mcpServers": {
    "discopop": {
      "command": "discopop_mcp_server"
    }
  }
}
```

### Example 2: With debug logging

```json
{
  "mcpServers": {
    "discopop": {
      "command": "discopop_mcp_server",
      "args": ["--debug"]
    }
  }
}
```

### Example 3: Using full path

```json
{
  "mcpServers": {
    "discopop": {
      "command": "/home/user/venv/bin/discopop_mcp_server",
      "args": ["--debug"]
    }
  }
}
```

## See Also

- [Setup Guide](SETUP_GUIDE.md) - All `--setup` / `--verify` / `--status` options
- [Installation Guide](INSTALLATION.md) - How to install the MCP server
- [DiscoPoP Documentation](https://www.discopop.tu-darmstadt.de/)
- [Model Context Protocol (MCP)](https://modelcontextprotocol.io/)
- [Claude Documentation](https://docs.anthropic.com/)
