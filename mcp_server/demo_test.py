#!/usr/bin/env python3
#
# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

"""Demo test showing the MCP server tools in action"""

import json
import sys

# Add parent to path
sys.path.insert(0, ".")

from server import DiscoPopMCPServer


def demo() -> None:
    """Demonstrate the MCP server tools"""
    print("\n" + "=" * 70)
    print("DiscoPoP MCP Server - Demo Test")
    print("=" * 70 + "\n")

    server = DiscoPopMCPServer(debug=True)

    # Test 1: get_profiling_info
    print("📊 TEST 1: Get Profiling Info")
    print("-" * 70)
    result = server._handle_profiling_info({"profile_path": "./example/.discopop", "info_type": "summary"})
    print("Response:", json.loads(result[0].text))
    print()

    # Test 2: execute_analysis
    print("🔍 TEST 2: Execute Analysis")
    print("-" * 70)
    result = server._handle_analysis({"profile_path": "./example/.discopop", "analysis_type": "patterns"})
    print("Response:", json.loads(result[0].text))
    print()

    # Test 3: list_available_data
    print("📁 TEST 3: List Available Data")
    print("-" * 70)
    result = server._handle_list_data({"base_path": "./example"})
    print("Response:", json.loads(result[0].text))
    print()

    # Test 4: Error handling
    print("⚠️  TEST 4: Error Handling")
    print("-" * 70)
    try:
        result = server._handle_profiling_info({"profile_path": "/nonexistent/path"})
        print("Result:", json.loads(result[0].text)["message"])
    except Exception as e:
        print(f"Error handled: {str(e)}")
    print()

    print("=" * 70)
    print("✅ All tests completed successfully!")
    print("=" * 70 + "\n")


if __name__ == "__main__":
    demo()
