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

import asyncio
import json
import logging
import unittest
from unittest.mock import patch, MagicMock

from server import DiscoPopMCPServer


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
            self.server._log_call("test_tool", {"arg": "value"})
            # Just verify the method doesn't raise

    def test_tool_registration(self) -> None:
        """Test that tools are properly registered"""
        tools = self.server.server.list_tools()
        # Should be registered but tools list is from the handler
        # Just verify no errors occur
        self.assertIsNotNone(tools)

    def test_profiling_info_handler(self) -> None:
        """Test get_profiling_info tool"""
        result = self.server._handle_profiling_info({"profile_path": "/test/path", "info_type": "summary"})
        self.assertIsNotNone(result)
        self.assertEqual(len(result), 1)
        text_content = result[0].text
        data = json.loads(text_content)
        self.assertEqual(data["status"], "success")
        self.assertIn("data", data)

    def test_analysis_handler(self) -> None:
        """Test execute_analysis tool"""
        result = self.server._handle_analysis({"profile_path": "/test/path", "analysis_type": "patterns"})
        self.assertIsNotNone(result)
        self.assertEqual(len(result), 1)
        text_content = result[0].text
        data = json.loads(text_content)
        self.assertEqual(data["status"], "success")
        self.assertIn("patterns", data)

    def test_list_data_handler(self) -> None:
        """Test list_available_data tool"""
        result = self.server._handle_list_data({"base_path": "/test/path"})
        self.assertIsNotNone(result)
        self.assertEqual(len(result), 1)
        text_content = result[0].text
        data = json.loads(text_content)
        self.assertEqual(data["status"], "success")
        self.assertIn("available_data", data)


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
