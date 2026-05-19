<!--
This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)

Copyright (c) 2020, Technische Universitaet Darmstadt, Germany

This software may be modified and distributed under the terms of
the 3-Clause BSD License.  See the LICENSE file in the package base
directory for details.
-->

# Integrating DiscoPoP MCP Server with Claude

This guide shows how to configure Claude to use the DiscoPoP MCP Server.

## Prerequisites

1. Install the DiscoPoP MCP Server:
```bash
pip install discopop-mcp-server
```

2. Verify installation:
```bash
discopop-mcp-server --help
```

## Claude Code (CLI)

Claude Code uses MCP server configuration stored in your local Claude directory.

### 1. Create configuration directory

```bash
mkdir -p ~/.claude
```

### 2. Add MCP server configuration

Create or edit `~/.claude/settings.json` and add the DiscoPoP server configuration:

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

### 3. Verify the configuration

Test that the server starts:
```bash
discopop-mcp-server --debug
```

You should see output like:
```
2026-05-19 10:30:00 - discopop-mcp - INFO - Starting DiscoPoP MCP Server (stdio mode)
```

### 4. Use with Claude Code

When using Claude Code with MCP enabled, you can ask:
> "What tools do you have available?"

Claude will list the available DiscoPoP tools.

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

### Enable debug logging

The `--debug` flag enables verbose logging of incoming calls and responses:

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

### Using a custom Python environment

If you're using a virtual environment or conda:

```json
{
  "mcpServers": {
    "discopop": {
      "command": "/path/to/venv/bin/discopop-mcp-server",
      "args": ["--debug"]
    }
  }
}
```

### Multiple MCP servers

You can configure multiple servers in the same file:

```json
{
  "mcpServers": {
    "discopop": {
      "command": "discopop-mcp-server",
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

### Server not found

**Error:** "command not found: discopop-mcp-server"

**Solution:**
- Install the package: `pip install discopop-mcp-server`
- Verify installation: `which discopop-mcp-server`
- Use full path in config if needed: `/path/to/venv/bin/discopop-mcp-server`

### Server fails to start

**Error:** Server exits with error

**Solution:**
1. Test the server directly: `discopop-mcp-server --debug`
2. Check for error messages in the output
3. Verify the command in the config is correct
4. Try with absolute path to the server command

### Tools not appearing

**Error:** Claude doesn't see DiscoPoP tools

**Solution:**
1. Verify `~/.claude/settings.json` exists and has valid JSON syntax
2. Check that the server can start: `discopop-mcp-server --help`
3. Try restarting Claude Code
4. Run server with debug: `discopop-mcp-server --debug`

### JSON syntax errors

**Error:** "Invalid JSON in settings.json"

**Solution:**
- Use a JSON validator to check your config file syntax
- Ensure all strings use double quotes `"`
- Check that all commas and braces are balanced
- Example: `cat ~/.claude/settings.json | python -m json.tool`

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
      "command": "discopop-mcp-server"
    }
  }
}
```

### Example 2: With debug logging

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

### Example 3: Using full path

```json
{
  "mcpServers": {
    "discopop": {
      "command": "/home/user/venv/bin/discopop-mcp-server",
      "args": ["--debug"]
    }
  }
}
```

## See Also

- [DiscoPoP Documentation](https://www.discopop.tu-darmstadt.de/)
- [Model Context Protocol (MCP)](https://modelcontextprotocol.io/)
- [Claude Documentation](https://docs.anthropic.com/)
