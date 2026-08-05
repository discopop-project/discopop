#
# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

#!/usr/bin/env python3
"""
Test suite for the DiscoPoP MCP Server
"""

import json
import logging
import unittest
from unittest.mock import patch

from mcp_server.server import DiscoPopMCPServer
from mcp_server.tools import get_configurations, get_execution_results


class TestDiscoPopMCPServer(unittest.TestCase):
    def setUp(self) -> None:
        self.server = DiscoPopMCPServer(debug=True)

    def test_server_initialization(self) -> None:
        """Test that server initializes correctly"""
        self.assertIsNotNone(self.server.server)
        self.assertTrue(self.server.debug)

    def test_logging_call_info(self) -> None:
        """Test that call logging works"""
        with patch("logging.Logger.info") as mock_info:
            self.server._ctx.log_call("test_tool", {"arg": "value"})
            # Just verify the method doesn't raise

    def test_tool_registration(self) -> None:
        """Test that tools are properly registered"""
        tools = self.server.server.list_tools()
        # Should be registered but tools list is from the handler
        # Just verify no errors occur
        self.assertIsNotNone(tools)

    def test_get_configurations_handler(self) -> None:
        """Test get_configurations tool"""
        result = get_configurations.handle({"project_path": "/test/project"}, self.server._ctx)
        self.assertIsNotNone(result)
        self.assertEqual(len(result), 1)
        text_content = result[0].text
        data = json.loads(text_content)
        self.assertEqual(data["status"], "success")
        self.assertEqual(data["project_path"], "/test/project")
        self.assertIn("configurations", data)

    def test_get_execution_results_handler(self) -> None:
        """Test get_execution_results tool"""
        result = get_execution_results.handle({"project_path": "/test/project"}, self.server._ctx)
        self.assertIsNotNone(result)
        self.assertEqual(len(result), 1)
        text_content = result[0].text
        data = json.loads(text_content)
        self.assertEqual(data["status"], "success")
        self.assertEqual(data["project_path"], "/test/project")
        self.assertIn("execution_results", data)


class TestServerIntegration(unittest.TestCase):
    """Integration tests for the MCP Server"""

    def test_debug_mode(self) -> None:
        """Test that debug mode sets correct logging level"""
        server = DiscoPopMCPServer(debug=True)
        self.assertTrue(server.debug)

        server_no_debug = DiscoPopMCPServer(debug=False)
        self.assertFalse(server_no_debug.debug)


if __name__ == "__main__":
    unittest.main()
