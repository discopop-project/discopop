<!--
This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)

Copyright (c) 2020, Technische Universitaet Darmstadt, Germany

This software may be modified and distributed under the terms of
the 3-Clause BSD License.  See the LICENSE file in the package base
directory for details.
-->

# DiscoPoP MCP Server - Quick Start

## Installation (Choose one)

### 1. From source (recommended)

```bash
cd mcp_server
pip install -e ".[dev]"
```

### 2. Minimal install

```bash
pip install mcp
```

### 3. From URL

```bash
pip install git+https://github.com/discopop-tool/discopop.git#subdirectory=mcp_server
```

### 4. Direct script

```bash
python3 mcp_server/server.py --debug
```

## Run the Server

```bash
discopop-mcp-server --debug
```

Or directly:

```bash
python3 server.py --debug
```

## Configure Claude Code

### 1. Create configuration directory

```bash
mkdir -p ~/.claude
```

### 2. Add server configuration to `~/.claude/settings.json`

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

### 3. Verify the server starts

```bash
discopop-mcp-server --debug
```

You should see startup messages with no errors.

### 4. In Claude, ask

> "What tools do you have available?"

## Tools Available

### 1. `get_configurations`

- Retrieve list of defined execution configurations from a target project
- Parameters: `project_path` (required)

### 2. `get_execution_results`

- Retrieve execution results from prior program executions
- Parameters: `project_path` (required)

## Example Usage

```
Claude: "Get the execution configurations for ./my_project"

Server logs:
   2026-05-19 10:30:05 - discopop-mcp - INFO - → Incoming call: get_configurations
   2026-05-19 10:30:05 - discopop-mcp - INFO - ← Outgoing response: get_configurations
```

## Testing

### Run tests

```bash
python -m pytest mcp_server/test_server.py -v
```

### Check type hints

```bash
python -m mypy server.py
```

### Format code

```bash
python -m black server.py
```

## Troubleshooting

### Issue: "command not found: discopop-mcp-server"

**Solution:** `pip install -e .`

### Issue: "No module named 'mcp'"

**Solution:** `pip install mcp`

### Issue: Claude can't connect

**Solution:**
- Verify server runs: `discopop-mcp-server --debug`
- Check `~/.claude/settings.json` syntax
- Check file is in correct location
- Restart Claude Code

## Documentation

| File | Content |
|------|---------|
| README.md | Features, tools, architecture |
| INSTALLATION.md | Detailed installation (6+ methods) |
| CLAUDE_INTEGRATION.md | Configure with Claude (all platforms) |
| DISTRIBUTION.md | How to ship to users |
| SETUP_SUMMARY.md | Complete overview |
| QUICKSTART.md | This file |

## What Next?

### For users

1. Install: `pip install -e .`
2. Run: `discopop-mcp-server --debug`
3. Integrate: See [CLAUDE_INTEGRATION.md](CLAUDE_INTEGRATION.md)

### For developers

1. Add DiscoPoP integration to tool handlers
2. Run tests: `pytest -v`
3. See [DISTRIBUTION.md](DISTRIBUTION.md) for release steps

### For shipping

1. Choose distribution method in [DISTRIBUTION.md](DISTRIBUTION.md)
2. Update version numbers
3. Build and publish

## Useful Commands

```bash
# Test server directly
echo '{}' | discopop-mcp-server --debug

# Check if installed
which discopop-mcp-server

# View version
discopop-mcp-server --help

# Run tests
pytest -v

# Build package
python -m build

# Publish to PyPI
python -m twine upload dist/*
```

## Info

- **Version:** 0.0.1a1 (Alpha)
- **Created:** 2026-05-19
- **License:** 3-Clause BSD (DiscoPoP)

---

For more help, see [README.md](README.md) or [INSTALLATION.md](INSTALLATION.md)

**Contact:** discopop@lists.parallel.informatik.tu-darmstadt.de
