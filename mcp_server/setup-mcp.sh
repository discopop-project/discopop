#!/bin/bash
#
# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
#
# Shell wrapper for DiscoPoP MCP Server setup
# This script locates and runs the Python setup script with proper environment

set -e

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SETUP_SCRIPT="$SCRIPT_DIR/setup_mcp.py"

# Check if Python setup script exists
if [ ! -f "$SETUP_SCRIPT" ]; then
    echo "Error: setup_mcp.py not found in $SCRIPT_DIR"
    exit 1
fi

# Find Python 3
if ! command -v python3 &> /dev/null; then
    echo "Error: Python 3 not found in PATH"
    echo "Please install Python 3 and try again"
    exit 1
fi

# Run the setup script with all arguments passed through
python3 "$SETUP_SCRIPT" "$@"
