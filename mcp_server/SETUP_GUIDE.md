<!--
This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)

Copyright (c) 2020, Technische Universitaet Darmstadt, Germany

This software may be modified and distributed under the terms of
the 3-Clause BSD License.  See the LICENSE file in the package base
directory for details.
-->

# DiscoPoP MCP Server Setup Guide

This guide explains how to use `discopop-mcp-server` to configure the DiscoPoP MCP Server for various Claude agents.

## Quick Start

```bash
discopop-mcp-server --setup claude_code
```

### Manual Configuration

See [CLAUDE_INTEGRATION.md](./CLAUDE_INTEGRATION.md) for manual setup instructions.

---

## Installation Prerequisites

Before running the setup script, ensure you have:

1. **Python 3.8 or higher** installed
2. **DiscoPoP MCP Server** installed:
   ```bash
   pip install discopop-mcp-server
   ```

Verify installation:
```bash
discopop-mcp-server --help
```

## Virtual Environment Support

`discopop-mcp-server --setup` automatically detects and uses the active Python virtual environment. This means:

- If you run the script inside a venv, it will automatically use the MCP server executable from that venv
- No manual path configuration needed
- The correct version is always used, regardless of your system PATH

### Example: Setup with Virtual Environment

```bash
source venv/bin/activate
discopop-mcp-server --setup claude_code

# The configuration will use:
# /path/to/your/venv/bin/discopop-mcp-server
```

### Example: Setup without Virtual Environment

```bash
pip install --user discopop-mcp-server
discopop-mcp-server --setup claude_code
```

---

## Setup Overview

The `discopop-mcp-server --setup` command automates the configuration of the DiscoPoP MCP Server for different agents. It:

- ✓ Detects your operating system
- ✓ Creates or updates agent configuration files
- ✓ Handles JSON configuration merging safely
- ✓ Supports multiple agents and platforms

---

## Command Reference

### Setup Commands

#### Setup a specific agent
```bash
discopop-mcp-server --setup claude_code
```

Setup the DiscoPoP MCP Server for Claude Code. This will:
1. Create `~/.claude/settings.json` if it doesn't exist
2. Add the discopop-mcp-server configuration
3. Preserve any existing configuration in the file

#### Setup all available agents
```bash
discopop-mcp-server --setup-all
```

Configures all supported agents in one command.

#### Enable debug logging
```bash
discopop-mcp-server --setup claude_code --debug
```

Adds `--debug` flag to the MCP server arguments for verbose logging.

#### Use full path to server
```bash
discopop-mcp-server --setup claude_code --full-path
```

Uses the absolute path to `discopop-mcp-server` instead of relying on PATH. Useful if the server isn't in your PATH or you want to use a specific installation.

### Verification Commands

#### Check current setup status
```bash
discopop-mcp-server --status
```

Shows:
- Whether DiscoPoP MCP Server is installed and where
- Configuration status for each agent
- Server location

#### Verify a specific agent's setup
```bash
discopop-mcp-server --verify claude_code
```

Checks if Claude Code is properly configured and displays the configuration details.

### Help

```bash
discopop-mcp-server --help
```

Shows all available commands and options.

---

## Usage Examples

### Example 1: First-time Setup

```bash
# 1. Install the MCP server
pip install discopop-mcp-server

# 2. Verify installation
discopop-mcp-server --help

# 3. Run setup
discopop-mcp-server --setup claude_code

# 4. Verify setup
discopop-mcp-server --verify claude_code
```

### Example 2: Setup with Debug Logging

For troubleshooting MCP server communication:

```bash
discopop-mcp-server --setup claude_code --debug
```

This enables verbose logging so you can see:
- Incoming tool calls
- Arguments passed to tools
- Response data
- Any errors or warnings

### Example 3: Forcing Full Path Detection

If you need to explicitly detect and use the full path from your system PATH:

```bash
discopop-mcp-server --setup claude_code --full-path
```

This searches your PATH and uses the absolute path to `discopop-mcp-server`.

**Note:** If you're using a virtual environment, the setup script automatically detects and uses it without this flag.

### Example 4: Check Status Before Setup

```bash
# Check current state
discopop-mcp-server --status

# If not installed, install it
pip install discopop-mcp-server

# Setup
discopop-mcp-server --setup-all

# Verify
discopop-mcp-server --status
```

---

## Configuration Details

### What the script creates/modifies

The setup script manages the following configuration file:

**Linux/macOS/Windows:**
- `~/.claude/settings.json` - Claude Code configuration

### Configuration Format

The script creates or updates a configuration like this:

```json
{
  "mcpServers": {
    "discopop-mcp-server": {
      "command": "discopop-mcp-server",
      "args": ["--debug"]
    }
  }
}
```

The script intelligently merges this with any existing configuration, preserving other settings.

### Customization

After setup, you can manually edit the configuration file to:

- Add additional arguments
- Use a custom Python environment
- Change debug settings
- Configure environment variables

See [CLAUDE_INTEGRATION.md](./CLAUDE_INTEGRATION.md#configuration-options) for advanced configuration options.

---

## Troubleshooting

### "command not found" or "Python not found"

```bash
discopop-mcp-server --setup claude_code
```

### "discopop-mcp-server not found"

The MCP server is not installed or not in your PATH:

```bash
# Install it
pip install discopop-mcp-server

# Verify installation
which discopop-mcp-server

# If installed but not found, use --full-path
discopop-mcp-server --setup claude_code --full-path
```

### "Invalid JSON in settings.json"

If the configuration file has JSON syntax errors:

```bash
# Validate the JSON
python3 -m json.tool ~/.claude/settings.json

# Or reset (back up first!)
cp ~/.claude/settings.json ~/.claude/settings.json.backup
rm ~/.claude/settings.json
discopop-mcp-server --setup claude_code
```

### Tools not appearing in Claude Code

1. Verify setup completed successfully:
   ```bash
   discopop-mcp-server --verify claude_code
   ```

2. Check JSON syntax:
   ```bash
   python3 -m json.tool ~/.claude/settings.json
   ```

3. Try restarting Claude Code

4. Enable debug logging to see what's happening:
   ```bash
   discopop-mcp-server --setup claude_code --debug
   ```

### Verbose output for debugging

Use the `-v` or `--verbose` flag to see detailed information:

```bash
discopop-mcp-server --setup claude_code --verbose
```

---

## Extending for New Agents

To add support for a new agent, open `setup_mcp.py` and add a new entry to the `MCPSetup.AGENTS` dictionary:

```python
AGENTS = {
    "your_agent": {
        "name": "Your Agent Display Name",
        "config_dir": lambda: Path.home() / ".your_agent",
        "config_file": "settings.json",
        "server_name": "discopop-mcp-server",
    },
    # ... existing agents
}
```

The new agent will automatically be supported:
   ```bash
   discopop-mcp-server --setup your_agent
   discopop-mcp-server --verify your_agent
   ```

---

## Advanced Usage

### Using with Virtual Environments

`discopop-mcp-server --setup` automatically detects and uses the active virtual environment. Simply activate it and run:

```bash
source venv/bin/activate
discopop-mcp-server --setup claude_code
```

It automatically uses `/path/to/venv/bin/discopop-mcp-server` in the generated configuration.

If you need to explicitly use the full path for any reason:

```bash
# Force full path detection from PATH
discopop-mcp-server --setup claude_code --full-path
```

### Checking Configuration Before Setup

```bash
# See current status without making changes
discopop-mcp-server --status
```

### Batch Operations

```bash
# Setup all agents with debug
discopop-mcp-server --setup-all --debug

# Then verify each one
discopop-mcp-server --status
```

---

## Integration with CI/CD

You can integrate the setup into your CI/CD pipeline:

```bash
# In your deployment/setup script
discopop-mcp-server --setup-all --verbose || {
    echo "Failed to setup MCP server"
    exit 1
}

# Verify success
discopop-mcp-server --verify claude_code || {
    echo "Verification failed"
    exit 1
}
```

---

## See Also

- [CLAUDE_INTEGRATION.md](./CLAUDE_INTEGRATION.md) - Manual setup guide
- [README.md](./README.md) - MCP server overview
- [QUICKSTART.md](./QUICKSTART.md) - Quick start guide
- [DiscoPoP Documentation](https://www.discopop.tu-darmstadt.de/)
- [Model Context Protocol](https://modelcontextprotocol.io/)

---

## Questions or Issues?

For issues or questions about the setup:

1. Check the [Troubleshooting](#troubleshooting) section
2. Review [CLAUDE_INTEGRATION.md](./CLAUDE_INTEGRATION.md#troubleshooting)
3. Run with `--verbose` for detailed output
4. Check the [DiscoPoP project documentation](https://www.discopop.tu-darmstadt.de/)
