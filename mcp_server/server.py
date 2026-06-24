#!/usr/bin/env python3
#
# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

"""DiscoPoP MCP Server

A Model Context Protocol server that exposes DiscoPoP functionality to LLM Agents.
Allows an LLM to drive the full instrumentation pipeline — compile, profile,
detect patterns, and retrieve patches — without human intervention.
"""

import datetime
import json
import logging
import os
import shutil
import subprocess
import sys
from pathlib import Path
from typing import Any, Optional

from mcp.server import Server
from mcp.types import TextContent, Tool

from setup_mcp import MCPSetup

from discopop_library.ProjectManager.configurations.execution import execute_configuration
from discopop_library.ProjectManager.ProjectManagerArguments import ProjectManagerArguments
from discopop_library.ProjectManager.utilities.deriveSettingsFiles import derive_settings_files

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(name)s - %(levelname)s - %(message)s",
)
logger = logging.getLogger("discopop-mcp")


class DiscoPopMCPServer:
    def __init__(self, debug: bool = False):
        self.server = Server("discopop_mcp_server")
        self.debug = debug
        if debug:
            logger.setLevel(logging.DEBUG)
        self._register_tools()

    def _log_to_file(self, project_path: str, marker: str, tool_name: str, message: str) -> None:
        """Append a timestamped entry to <project_path>/.discopop/mcp_server/log.txt.
        Never raises — logging failures must not affect tool execution."""
        try:
            log_dir = Path(project_path) / ".discopop" / "mcp_server"
            log_dir.mkdir(parents=True, exist_ok=True)
            ts = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
            line = f"{ts}  {marker:<8}  {tool_name:<40}  {message}\n"
            with open(log_dir / "log.txt", "a") as f:
                f.write(line)
        except Exception:
            pass

    def _log_call(self, tool_name: str, arguments: dict[str, Any]) -> None:
        logger.info(f"→ Incoming call: {tool_name}")
        if self.debug:
            logger.debug(f"  Arguments: {json.dumps(arguments, indent=2)}")
        project_path = arguments.get("project_path", "")
        if project_path:
            args_summary = ", ".join(f"{k}={v!r}" for k, v in arguments.items() if k != "script_body")
            self._log_to_file(project_path, "→ CALL", tool_name, args_summary)

    def _log_response(self, tool_name: str, result: Any) -> None:
        logger.info(f"← Outgoing response: {tool_name}")
        if self.debug:
            logger.debug(f"  Result: {json.dumps(result if isinstance(result, dict) else str(result), indent=2)}")
        if isinstance(result, dict):
            project_path = result.get("project_path", "")
            if not project_path:
                return
            status = result.get("status", "?")
            extras = {
                k: v
                for k in (
                    "returncode",
                    "elapsed_time",
                    "patterns_found",
                    "files_created",
                    "profiling_files",
                    "created_files",
                    "patches",
                )
                if (v := result.get(k)) is not None
            }
            summary = f"status={status}" + (
                ", "
                + ", ".join(
                    f"{k}={v!r}" if not isinstance(v, list) else f"{k}=[{len(v)} items]" for k, v in extras.items()
                )
                if extras
                else ""
            )
            self._log_to_file(project_path, "← RESULT", tool_name, summary)

    def _log_action(self, project_path: str, tool_name: str, message: str) -> None:
        logger.debug(f"  Action [{tool_name}]: {message}")
        if project_path:
            self._log_to_file(project_path, "· ACTION", tool_name, message)

    def _error(self, message: str) -> list[TextContent]:
        result = {"status": "error", "message": message}
        return [TextContent(type="text", text=json.dumps(result))]

    def _make_pm_args(self, project_path: str, timeout_seconds: Optional[int] = None) -> ProjectManagerArguments:
        return ProjectManagerArguments(
            project_root=project_path,
            full_execute=False,
            list=False,
            execute_configurations="",
            execute_inplace=True,
            skip_cleanup=False,
            generate_report=False,
            show_report=False,
            initialize_directory=False,
            apply_suggestions=None,
            reset=False,
            reset_execution_results=False,
            gui=False,
            label_prefix="mcp",
            timeout_execution=float(timeout_seconds) if timeout_seconds is not None else None,
            timeout_compilation=float(timeout_seconds) if timeout_seconds is not None else None,
            log_level="WARNING",
            write_log=False,
        )

    def _register_tools(self) -> None:
        @self.server.call_tool()  # type: ignore[misc, untyped-decorator]
        async def handle_tool_call(name: str, arguments: dict[str, Any]) -> list[TextContent]:
            self._log_call(name, arguments)

            if name == "get_configurations":
                return self._handle_get_configurations(arguments)
            elif name == "get_execution_results":
                return self._handle_get_execution_results(arguments)
            elif name == "initialize_discopop_directory":
                return self._handle_initialize_discopop_directory(arguments)
            elif name == "set_compile_script":
                return self._handle_set_compile_script(arguments)
            elif name == "create_execution_configuration":
                return self._handle_create_execution_configuration(arguments)
            elif name == "instrument_project":
                return self._handle_instrument_project(arguments)
            elif name == "run_instrumented_binary":
                return self._handle_run_instrumented_binary(arguments)
            elif name == "run_pattern_detection":
                return self._handle_run_pattern_detection(arguments)
            elif name == "get_parallelization_patches":
                return self._handle_get_parallelization_patches(arguments)
            else:
                error_msg = f"Unknown tool: {name}"
                logger.error(error_msg)
                return [TextContent(type="text", text=error_msg)]

        @self.server.list_tools()  # type: ignore[misc, untyped-decorator]
        async def list_tools() -> list[Tool]:
            tools = [
                Tool(
                    name="get_configurations",
                    description=(
                        "Retrieve all execution configurations defined for a DiscoPoP project, "
                        "including the content of the shared compile.sh and each configuration's execute.sh. "
                        "\n\n"
                        "Call this to inspect what build and execution scripts are currently defined for a project, "
                        "or to check whether a project has been initialized yet — an empty configurations list and "
                        "null compile_script means initialize_discopop_directory has not been run. "
                        "\n\n"
                        "Returns:\n"
                        "  - compile_script: content of .discopop/project/configs/compile.sh, or null if absent\n"
                        "  - settings: contents of seq_settings.json and dp_settings.json, if present\n"
                        "  - configurations: list of named configurations, each with its execute.sh content\n"
                        "\n"
                        "Example output:\n"
                        '  {"status":"success","compile_script":"#!/bin/bash\\n$CXX $CXXFLAGS main.cpp -o myapp\\n",'
                        '"configurations":[{"name":"default","execute_script":"#!/bin/bash\\n./myapp\\n"}]}'
                    ),
                    inputSchema={
                        "type": "object",
                        "properties": {
                            "project_path": {
                                "type": "string",
                                "description": "Absolute path to the target project root directory.",
                            },
                        },
                        "required": ["project_path"],
                    },
                ),
                Tool(
                    name="get_execution_results",
                    description=(
                        "Retrieve stored execution results from prior DiscoPoP runs. "
                        "Call this after run_instrumented_binary to inspect timing, return codes, "
                        "and captured output from previous executions, or to check whether profiling "
                        "data has been collected. "
                        "\n\n"
                        "Results are keyed by configuration name, script name, and settings name. "
                        "Each entry contains: code (return code), time (elapsed seconds), "
                        "stdout/stderr (captured output), timeout_expired, thread_count, "
                        "and applied_suggestions (list of patch IDs applied before the run). "
                        "\n\n"
                        "Returns an empty execution_results object if no runs have been recorded yet."
                    ),
                    inputSchema={
                        "type": "object",
                        "properties": {
                            "project_path": {
                                "type": "string",
                                "description": "Absolute path to the target project root directory.",
                            },
                        },
                        "required": ["project_path"],
                    },
                ),
                Tool(
                    name="initialize_discopop_directory",
                    description=(
                        "Set up the DiscoPoP directory structure for a project. Call this as the very "
                        "first step before any other DiscoPoP tool when working with a project that has "
                        "not been initialized yet. Safe to call on an already-initialized project — "
                        "existing files are left unchanged and reported in skipped_files. "
                        "\n\n"
                        "This tool creates:\n"
                        "  - .discopop/project/configs/          — configuration directory\n"
                        "  - seq_settings.json                   — base sequential build settings (CC, CXX, CFLAGS, CXXFLAGS)\n"
                        "  - dp_settings.json                    — instrumentation settings (CC=discopop_cc, CXX=discopop_cxx)\n"
                        "  - hd_settings.json                    — hotspot detection settings\n"
                        "  - par_settings.json                   — parallel build settings\n"
                        "  - compile.sh                          — placeholder that must be replaced via set_compile_script\n"
                        "\n"
                        "After this tool succeeds, call set_compile_script to describe how to build the "
                        "project, then create_execution_configuration to describe how to run it."
                    ),
                    inputSchema={
                        "type": "object",
                        "properties": {
                            "project_path": {
                                "type": "string",
                                "description": (
                                    "Absolute path to the project root directory (the directory containing "
                                    "the source files). Example: /home/user/myproject"
                                ),
                            },
                            "base_cc": {
                                "type": "string",
                                "description": (
                                    "Base C compiler for sequential (non-instrumented) builds. "
                                    "Default: clang. Example: gcc"
                                ),
                            },
                            "base_cxx": {
                                "type": "string",
                                "description": (
                                    "Base C++ compiler for sequential (non-instrumented) builds. "
                                    "Default: clang++. Example: g++"
                                ),
                            },
                            "cflags": {
                                "type": "string",
                                "description": (
                                    "Initial CFLAGS shared across all build modes. "
                                    "Default: empty string. Example: -O2 -std=c11"
                                ),
                            },
                            "cxxflags": {
                                "type": "string",
                                "description": (
                                    "Initial CXXFLAGS shared across all build modes. "
                                    "Default: empty string. Example: -O2 -std=c++17"
                                ),
                            },
                        },
                        "required": ["project_path"],
                    },
                ),
                Tool(
                    name="set_compile_script",
                    description=(
                        "Write the shared compilation script compile.sh for a DiscoPoP project. "
                        "Call this after initialize_discopop_directory, once you know how the project is built. "
                        "\n\n"
                        "The script is executed from the project root with these environment variables available:\n"
                        "  $CC, $CXX          — compiler executables (injected from the active settings file)\n"
                        "  $CFLAGS, $CXXFLAGS — compiler flags\n"
                        "  $DP_PROJECT_ROOT_DIR — absolute path to the project root\n"
                        "  $DOT_DISCOPOP      — absolute path to the .discopop directory\n"
                        "\n"
                        "IMPORTANT: The script body MUST use $CC/$CXX for compilers AND $CFLAGS/$CXXFLAGS "
                        "for flags — never hardcode compiler names like g++ or clang++. "
                        "The same script is reused for sequential builds, DiscoPoP instrumentation, "
                        "hotspot detection, and parallel builds — the compiler and flags are selected "
                        "by the settings file, not the script. "
                        "The script must exit 0 on success. "
                        "\n\n"
                        "Examples:\n"
                        "  Single C++ file:  $CXX $CXXFLAGS main.cpp -o myapp\n"
                        "  Single C file:    $CC $CFLAGS main.c -o myapp\n"
                        "  Mixed C/C++:      $CXX $CXXFLAGS src/main.cpp && $CC $CFLAGS src/util.c -o myapp\n"
                        '  Make project:     make CC="$CC" CXX="$CXX" CFLAGS="$CFLAGS" CXXFLAGS="$CXXFLAGS"\n'
                        "  CMake project:    mkdir -p build && cmake -B build "
                        '-DCMAKE_C_COMPILER="$CC" -DCMAKE_CXX_COMPILER="$CXX" '
                        '-DCMAKE_C_FLAGS="$CFLAGS" -DCMAKE_CXX_FLAGS="$CXXFLAGS" . && cmake --build build\n'
                        "\n"
                        "After setting the compile script, call create_execution_configuration to define "
                        "how to run the compiled binary."
                    ),
                    inputSchema={
                        "type": "object",
                        "properties": {
                            "project_path": {
                                "type": "string",
                                "description": (
                                    "Absolute path to the project root. Must already be initialized "
                                    "via initialize_discopop_directory."
                                ),
                            },
                            "script_body": {
                                "type": "string",
                                "description": (
                                    "Full bash script body. Must use $CC/$CXX/$CFLAGS/$CXXFLAGS instead "
                                    "of hardcoded compiler names. Will be written to "
                                    ".discopop/project/configs/compile.sh. A #!/bin/bash shebang is "
                                    "prepended automatically if not present."
                                ),
                            },
                        },
                        "required": ["project_path", "script_body"],
                    },
                ),
                Tool(
                    name="create_execution_configuration",
                    description=(
                        "Create a named execution configuration for a DiscoPoP project. "
                        "Call this after set_compile_script to define how to run the compiled binary. "
                        "\n\n"
                        "Each configuration is a named subdirectory under .discopop/project/configs/ "
                        "containing an execute.sh script. A project can have multiple configurations "
                        "representing different execution scenarios (e.g. different input sizes or "
                        "argument sets). "
                        "\n\n"
                        "IMPORTANT — profiling overhead: The instrumented binary records every memory "
                        "access at runtime, which incurs significant overhead compared to the original "
                        "program. In particularly bad cases overhead can reach up to 100x, although "
                        "the average is far below that. If the program accepts input data or a parameter "
                        "controlling problem size, always prefer the smallest input that still exercises "
                        "the code paths of interest. Configurations with unnecessarily large workloads "
                        "may become impractically slow under instrumentation. "
                        "\n\n"
                        "The execute.sh script is executed from the project root with the same environment "
                        "variables as compile.sh: $CC, $CXX, $CFLAGS, $CXXFLAGS, $DP_PROJECT_ROOT_DIR, "
                        "$DOT_DISCOPOP, $OMP_NUM_THREADS. The script must exit 0 on success. "
                        "\n\n"
                        "Examples for script_body:\n"
                        "  Minimal:              ./myapp\n"
                        "  Small input:          ./myapp --input data/small.txt --iterations 100\n"
                        "  Multiple short runs:  ./myapp --mode A && ./myapp --mode B\n"
                        "  Piped input:          ./myapp < test_data/small_input.dat\n"
                        "\n"
                        "After creating at least one configuration, call instrument_project to compile "
                        "with DiscoPoP instrumentation."
                    ),
                    inputSchema={
                        "type": "object",
                        "properties": {
                            "project_path": {
                                "type": "string",
                                "description": "Absolute path to the project root.",
                            },
                            "config_name": {
                                "type": "string",
                                "description": (
                                    "Identifier for this configuration. Used as the subdirectory name "
                                    "under .discopop/project/configs/. Must not contain path separators. "
                                    "Examples: default, small_input, large_input"
                                ),
                            },
                            "script_body": {
                                "type": "string",
                                "description": (
                                    "Full bash script body for running the compiled binary. "
                                    "Executed from the project root. Must exit 0 on success. "
                                    "A #!/bin/bash shebang is prepended automatically if not present."
                                ),
                            },
                        },
                        "required": ["project_path", "config_name", "script_body"],
                    },
                ),
                Tool(
                    name="instrument_project",
                    description=(
                        "Compile the project with DiscoPoP instrumentation. Call this after "
                        "set_compile_script and create_execution_configuration. "
                        "\n\n"
                        "This tool runs compile.sh using dp_settings.json, which sets "
                        "CC=discopop_cc and CXX=discopop_cxx. These DiscoPoP compiler wrappers invoke "
                        "clang/clang++ with the DiscoPoP LLVM pass loaded, which injects instrumentation "
                        "code and performs static analysis. Compilation produces:\n"
                        "  .discopop/FileMapping.txt              — maps numeric file IDs to source paths\n"
                        "  .discopop/line_mapping.json            — maps instruction IDs to source lines\n"
                        "  .discopop/profiler/Data.xml            — static analysis: CUs, loops, functions\n"
                        "  .discopop/profiler/ast_dump.json       — full Abstract Syntax Tree\n"
                        "  .discopop/profiler/loop_meta.txt       — loop metadata\n"
                        "  .discopop/profiler/static_dependencies.txt\n"
                        "\n"
                        "The .discopop/profiler/ directory is deleted before each run to prevent stale "
                        "data from prior instrumentation attempts. "
                        "\n\n"
                        "After this tool succeeds, call run_instrumented_binary to collect runtime data."
                    ),
                    inputSchema={
                        "type": "object",
                        "properties": {
                            "project_path": {
                                "type": "string",
                                "description": "Absolute path to the project root.",
                            },
                            "config_name": {
                                "type": "string",
                                "description": (
                                    "Name of an existing execution configuration created via "
                                    "create_execution_configuration. Required by the project manager "
                                    "for environment setup."
                                ),
                            },
                            "timeout_seconds": {
                                "type": "integer",
                                "description": (
                                    "Maximum time in seconds allowed for compilation. "
                                    "Default: 3600. Set lower for fast projects, higher for large codebases."
                                ),
                            },
                        },
                        "required": ["project_path", "config_name"],
                    },
                ),
                Tool(
                    name="run_instrumented_binary",
                    description=(
                        "Run the instrumented binary to collect runtime data dependency traces. "
                        "Call this after instrument_project succeeds. "
                        "\n\n"
                        "This tool runs the named configuration's execute.sh using dp_settings.json "
                        "(the same settings used during instrumentation). The instrumented binary "
                        "communicates with the DiscoPoP runtime library to record every memory access "
                        "and data dependency at runtime. This produces:\n"
                        "  .discopop/profiler/dynamic_dependencies.txt  — RAW/WAR/WAW dependency traces\n"
                        "  .discopop/profiler/loop_counter_output.txt   — loop iteration counts\n"
                        "  .discopop/profiler/reduction.txt             — detected reduction operations\n"
                        "  .discopop/profiler/memory_regions.txt        — memory region data\n"
                        "\n"
                        "The recorded data dependencies are grounded in the actual observed execution "
                        "rather than being estimated or assumed from the source code. Crucially, they "
                        "are not pessimistic: only dependencies that actually occurred during the run "
                        "are recorded, not all dependencies that could theoretically occur. This makes "
                        "them a reliable and precise basis for parallelization analysis.\n"
                        "\n"
                        "NOTE: Profiling incurs significant runtime overhead — the instrumented binary "
                        "will run noticeably slower than the original. In particularly bad cases overhead "
                        "can reach up to 100x, although the average is far below that. Long execution "
                        "times must be expected. To keep profiling practical, use the smallest input or "
                        "problem size that still exercises the loops of interest. If no suitable small "
                        "input exists, increase timeout_seconds accordingly. "
                        "\n\n"
                        "The quality of pattern detection depends directly on how representative the "
                        "execution is. Multiple configurations with different inputs can be created and "
                        "run independently to profile different code paths. "
                        "\n\n"
                        "After this tool succeeds, call run_pattern_detection to analyse the collected data."
                    ),
                    inputSchema={
                        "type": "object",
                        "properties": {
                            "project_path": {
                                "type": "string",
                                "description": "Absolute path to the project root.",
                            },
                            "config_name": {
                                "type": "string",
                                "description": (
                                    "Name of the configuration whose execute.sh to run. "
                                    "Must match a directory under .discopop/project/configs/."
                                ),
                            },
                            "timeout_seconds": {
                                "type": "integer",
                                "description": (
                                    "Maximum time in seconds for the binary to run. Default: 3600. "
                                    "Set this to accommodate the expected runtime with its input."
                                ),
                            },
                        },
                        "required": ["project_path", "config_name"],
                    },
                ),
                Tool(
                    name="run_pattern_detection",
                    description=(
                        "Analyse the profiling data to detect parallelization opportunities. "
                        "Call this after run_instrumented_binary succeeds. "
                        "\n\n"
                        "This tool runs discopop_explorer from the .discopop directory. The explorer "
                        "cross-references the static analysis data (Data.xml from instrumentation) with "
                        "the runtime dependency traces (dynamic_dependencies.txt from execution) to "
                        "identify loops that can safely be parallelized with OpenMP. "
                        "Because the dependency traces reflect only dependencies that were actually "
                        "observed during execution — not pessimistic worst-case estimates — the analysis "
                        "results are grounded in real behaviour and avoid the over-approximation that "
                        "purely static analyses typically introduce. "
                        "\n\n"
                        "Detected pattern types:\n"
                        "  do_all    — loops with no loop-carried dependencies; "
                        "suitable for #pragma omp parallel for\n"
                        "  reduction — loops with reduction operations (e.g. sum += x); "
                        "suitable for reduction clauses\n"
                        "  task      — task-level parallelism candidates\n"
                        "  pipeline  — pipeline parallelism candidates\n"
                        "\n"
                        "On success creates:\n"
                        "  .discopop/explorer/patterns.json               — all detected patterns\n"
                        "  .discopop/explorer/detection_result_dump.json  — detailed detection state\n"
                        "  .discopop/patch_generator/<id>/<file>.patch    — one patch per pattern\n"
                        "\n"
                        "After this tool succeeds, call get_parallelization_patches to retrieve the patches."
                    ),
                    inputSchema={
                        "type": "object",
                        "properties": {
                            "project_path": {
                                "type": "string",
                                "description": (
                                    "Absolute path to the project root. discopop_explorer is invoked "
                                    "with <project_path>/.discopop as its working directory."
                                ),
                            },
                        },
                        "required": ["project_path"],
                    },
                ),
                Tool(
                    name="get_parallelization_patches",
                    description=(
                        "Retrieve the generated OpenMP parallelization patches. Call this after "
                        "run_pattern_detection to inspect or present the suggested code changes. "
                        "\n\n"
                        "Each detected pattern results in a unified-diff patch file stored under "
                        ".discopop/patch_generator/<pattern_id>/. The patch inserts an OpenMP pragma "
                        "(e.g. #pragma omp parallel for with appropriate clauses) directly above the "
                        "loop it applies to. Patches are in standard unified diff format and can be "
                        "applied with the patch command or via discopop_patch_applicator. "
                        "\n\n"
                        "Use the optional pattern_id parameter to retrieve a single patch when the "
                        "user asks about a specific suggestion. Omit it to retrieve all patches. "
                        "\n\n"
                        "Example patch content:\n"
                        "  --- original/main.cpp\n"
                        "  +++ main.cpp\n"
                        "  @@ -17,6 +17,7 @@\n"
                        "  +  #pragma omp parallel for firstprivate(N)\n"
                        "     for (int i = 0; i < N; i++) {\n"
                        "       Arr[i] = i % 13;\n"
                        "     }"
                    ),
                    inputSchema={
                        "type": "object",
                        "properties": {
                            "project_path": {
                                "type": "string",
                                "description": "Absolute path to the project root.",
                            },
                            "pattern_id": {
                                "type": "integer",
                                "description": (
                                    "If provided, return only the patch for this specific pattern ID "
                                    "(as shown in patterns.json). Omit to return all available patches."
                                ),
                            },
                        },
                        "required": ["project_path"],
                    },
                ),
            ]
            logger.debug(f"Listed {len(tools)} available tools")
            return tools

    # -------------------------------------------------------------------------
    # Existing tools (extended)
    # -------------------------------------------------------------------------

    def _handle_get_configurations(self, arguments: dict[str, Any]) -> list[TextContent]:
        try:
            project_path = arguments.get("project_path", "")
            p = Path(project_path)
            configs_dir = p / ".discopop" / "project" / "configs"

            compile_script: Optional[str] = None
            compile_sh = configs_dir / "compile.sh"
            if compile_sh.exists():
                compile_script = compile_sh.read_text()

            settings: dict[str, Any] = {}
            for key, filename in [("seq", "seq_settings.json"), ("dp", "dp_settings.json")]:
                settings_file = configs_dir / filename
                if settings_file.exists():
                    settings[key] = json.loads(settings_file.read_text())

            configurations = []
            if configs_dir.exists() and configs_dir.is_dir():
                for config_dir in sorted(configs_dir.iterdir()):
                    if not config_dir.is_dir():
                        continue
                    execute_sh = config_dir / "execute.sh"
                    configurations.append(
                        {
                            "name": config_dir.name,
                            "execute_script": execute_sh.read_text() if execute_sh.exists() else None,
                        }
                    )

            result = {
                "status": "success",
                "project_path": project_path,
                "compile_script": compile_script,
                "settings": settings,
                "configurations": configurations,
            }
            self._log_response("get_configurations", result)
            return [TextContent(type="text", text=json.dumps(result))]

        except Exception as e:
            error_msg = f"Error retrieving configurations: {str(e)}"
            logger.error(error_msg)
            return [TextContent(type="text", text=json.dumps({"status": "error", "message": error_msg}))]

    def _handle_get_execution_results(self, arguments: dict[str, Any]) -> list[TextContent]:
        try:
            project_path = arguments.get("project_path", "")
            results_file = Path(project_path) / ".discopop" / "project" / "execution_results.json"

            execution_results: dict[str, Any] = {}
            if results_file.exists() and results_file.is_file():
                with open(results_file, "r") as f:
                    execution_results = json.load(f)

            result = {
                "status": "success",
                "project_path": project_path,
                "execution_results": execution_results,
            }
            self._log_response("get_execution_results", result)
            return [TextContent(type="text", text=json.dumps(result))]

        except Exception as e:
            error_msg = f"Error retrieving execution results: {str(e)}"
            logger.error(error_msg)
            return [TextContent(type="text", text=json.dumps({"status": "error", "message": error_msg}))]

    # -------------------------------------------------------------------------
    # New tools
    # -------------------------------------------------------------------------

    def _handle_initialize_discopop_directory(self, arguments: dict[str, Any]) -> list[TextContent]:
        try:
            project_path = arguments.get("project_path", "")
            base_cc = arguments.get("base_cc", "clang")
            base_cxx = arguments.get("base_cxx", "clang++")
            cflags = arguments.get("cflags", "")
            cxxflags = arguments.get("cxxflags", "")

            p = Path(project_path)
            if not p.exists():
                return self._error(f"project_path does not exist: {project_path}")

            configs_dir = p / ".discopop" / "project" / "configs"
            configs_dir.mkdir(parents=True, exist_ok=True)
            self._log_action(project_path, "initialize_discopop_directory", f"Ensured directory exists: {configs_dir}")

            created: list[str] = []
            skipped: list[str] = []

            seq_settings_path = configs_dir / "seq_settings.json"
            if not seq_settings_path.exists():
                seq_settings_path.write_text(
                    json.dumps({"CC": base_cc, "CXX": base_cxx, "CFLAGS": cflags, "CXXFLAGS": cxxflags}, indent=2)
                )
                created.append(str(seq_settings_path.relative_to(p)))
                self._log_action(
                    project_path,
                    "initialize_discopop_directory",
                    f"Created seq_settings.json (CC={base_cc}, CXX={base_cxx})",
                )
            else:
                skipped.append(str(seq_settings_path.relative_to(p)))

            derive_settings_files(str(configs_dir), overwrite=False)
            self._log_action(
                project_path, "initialize_discopop_directory", "Derived dp/hd/par settings files from seq_settings.json"
            )
            for name in ("dp_settings.json", "hd_settings.json", "par_settings.json"):
                f = configs_dir / name
                if str(f.relative_to(p)) not in skipped:
                    if f.exists():
                        created.append(str(f.relative_to(p)))

            compile_sh = configs_dir / "compile.sh"
            if not compile_sh.exists():
                initial_content = (
                    "#!/bin/bash\n"
                    "# This script is executed from the project root directory.\n"
                    "# Use $CC/$CXX/$CFLAGS/$CXXFLAGS — do NOT hardcode compiler names.\n"
                    "# Replace this placeholder via the set_compile_script MCP tool.\n"
                    "echo 'compile.sh has not been configured yet. Use set_compile_script.'\n"
                    "exit 1\n"
                )
                compile_sh.write_text(initial_content)
                compile_sh.chmod(compile_sh.stat().st_mode | 0o111)
                created.append(str(compile_sh.relative_to(p)))
                self._log_action(project_path, "initialize_discopop_directory", "Created placeholder compile.sh")
            else:
                skipped.append(str(compile_sh.relative_to(p)))

            result = {
                "status": "success",
                "project_path": project_path,
                "created_files": created,
                "skipped_files": skipped,
            }
            self._log_response("initialize_discopop_directory", result)
            return [TextContent(type="text", text=json.dumps(result))]

        except Exception as e:
            error_msg = f"Error initializing DiscoPoP directory: {str(e)}"
            logger.error(error_msg, exc_info=True)
            return [TextContent(type="text", text=json.dumps({"status": "error", "message": error_msg}))]

    def _handle_set_compile_script(self, arguments: dict[str, Any]) -> list[TextContent]:
        try:
            project_path = arguments.get("project_path", "")
            script_body = arguments.get("script_body", "")

            configs_dir = Path(project_path) / ".discopop" / "project" / "configs"
            if not configs_dir.exists():
                return self._error("DiscoPoP directory not initialized. Run initialize_discopop_directory first.")

            if not script_body.startswith("#!"):
                script_body = "#!/bin/bash\n" + script_body

            compile_sh = configs_dir / "compile.sh"
            compile_sh.write_text(script_body)
            compile_sh.chmod(compile_sh.stat().st_mode | 0o111)
            self._log_action(project_path, "set_compile_script", f"Wrote compile.sh ({len(script_body)} bytes)")

            result = {
                "status": "success",
                "project_path": project_path,
                "path": str(compile_sh),
            }
            self._log_response("set_compile_script", result)
            return [TextContent(type="text", text=json.dumps(result))]

        except Exception as e:
            error_msg = f"Error writing compile script: {str(e)}"
            logger.error(error_msg, exc_info=True)
            return [TextContent(type="text", text=json.dumps({"status": "error", "message": error_msg}))]

    def _handle_create_execution_configuration(self, arguments: dict[str, Any]) -> list[TextContent]:
        try:
            project_path = arguments.get("project_path", "")
            config_name = arguments.get("config_name", "")
            script_body = arguments.get("script_body", "")

            if not config_name or os.sep in config_name or "/" in config_name:
                return self._error(
                    f"Invalid config_name '{config_name}'. Must be a plain name without path separators."
                )

            configs_dir = Path(project_path) / ".discopop" / "project" / "configs"
            if not configs_dir.exists():
                return self._error("DiscoPoP directory not initialized. Run initialize_discopop_directory first.")

            config_dir = configs_dir / config_name
            config_dir.mkdir(parents=True, exist_ok=True)
            self._log_action(project_path, "create_execution_configuration", f"Ensured config directory: {config_dir}")

            if not script_body.startswith("#!"):
                script_body = "#!/bin/bash\n" + script_body

            execute_sh = config_dir / "execute.sh"
            execute_sh.write_text(script_body)
            execute_sh.chmod(execute_sh.stat().st_mode | 0o111)
            self._log_action(
                project_path,
                "create_execution_configuration",
                f"Wrote execute.sh for config '{config_name}' ({len(script_body)} bytes)",
            )

            result = {
                "status": "success",
                "project_path": project_path,
                "config_name": config_name,
                "path": str(execute_sh),
            }
            self._log_response("create_execution_configuration", result)
            return [TextContent(type="text", text=json.dumps(result))]

        except Exception as e:
            error_msg = f"Error creating execution configuration: {str(e)}"
            logger.error(error_msg, exc_info=True)
            return [TextContent(type="text", text=json.dumps({"status": "error", "message": error_msg}))]

    def _handle_instrument_project(self, arguments: dict[str, Any]) -> list[TextContent]:
        try:
            project_path = arguments.get("project_path", "")
            config_name = arguments.get("config_name", "")
            timeout_seconds = arguments.get("timeout_seconds", 3600)

            p = Path(project_path)
            configs_dir = p / ".discopop" / "project" / "configs"
            compile_sh = configs_dir / "compile.sh"
            dp_settings = configs_dir / "dp_settings.json"
            profiler_dir = p / ".discopop" / "profiler"

            if not compile_sh.exists():
                return self._error(f"compile.sh not found at {compile_sh}. Run set_compile_script first.")
            if not dp_settings.exists():
                return self._error(f"dp_settings.json not found. Run initialize_discopop_directory first.")
            config_dir = configs_dir / config_name
            if not config_dir.exists():
                return self._error(
                    f"Configuration '{config_name}' not found. Run create_execution_configuration first."
                )

            if profiler_dir.exists():
                shutil.rmtree(str(profiler_dir))
                self._log_action(project_path, "instrument_project", "Deleted stale .discopop/profiler/ directory")

            pm_args = self._make_pm_args(project_path, timeout_seconds)

            self._log_action(
                project_path,
                "instrument_project",
                f"Launching compile.sh via dp_settings (discopop_cxx), config='{config_name}', timeout={timeout_seconds}s",
            )
            original_cwd = os.getcwd()
            try:
                exec_result = execute_configuration(
                    arguments=pm_args,
                    project_copy_root_path=project_path,
                    config_path=str(config_dir),
                    settings_path=str(dp_settings),
                    script_path=str(compile_sh),
                    thread_count=1,
                    timeout=float(timeout_seconds),
                )
            finally:
                os.chdir(original_cwd)

            if exec_result is None:
                return self._error(
                    "execute_configuration returned None — dp_settings.json may be missing or malformed."
                )

            returncode, elapsed, stdout, stderr = exec_result

            files_created = (
                [str(f.relative_to(p)) for f in profiler_dir.rglob("*") if f.is_file()] if profiler_dir.exists() else []
            )

            data_xml = p / ".discopop" / "profiler" / "Data.xml"
            if returncode != 0:
                result = {
                    "status": "error",
                    "message": f"Compilation failed with return code {returncode}.",
                    "returncode": returncode,
                    "elapsed_time": elapsed,
                    "stdout": stdout,
                    "stderr": stderr,
                }
            elif not data_xml.exists():
                result = {
                    "status": "error",
                    "message": (
                        "Compilation succeeded but Data.xml was not created. "
                        "Ensure discopop_cxx is installed and in PATH."
                    ),
                    "returncode": returncode,
                    "elapsed_time": elapsed,
                    "stdout": stdout,
                    "stderr": stderr,
                }
            else:
                result = {
                    "status": "success",
                    "returncode": returncode,
                    "elapsed_time": elapsed,
                    "stdout": stdout,
                    "stderr": stderr,
                    "files_created": files_created,
                }

            self._log_response("instrument_project", result)
            return [TextContent(type="text", text=json.dumps(result))]

        except Exception as e:
            error_msg = f"Error during instrumentation: {str(e)}"
            logger.error(error_msg, exc_info=True)
            return [TextContent(type="text", text=json.dumps({"status": "error", "message": error_msg}))]

    def _handle_run_instrumented_binary(self, arguments: dict[str, Any]) -> list[TextContent]:
        try:
            project_path = arguments.get("project_path", "")
            config_name = arguments.get("config_name", "")
            timeout_seconds = arguments.get("timeout_seconds", 3600)

            p = Path(project_path)
            configs_dir = p / ".discopop" / "project" / "configs"
            dp_settings = configs_dir / "dp_settings.json"
            execute_sh = configs_dir / config_name / "execute.sh"
            data_xml = p / ".discopop" / "profiler" / "Data.xml"

            if not execute_sh.exists():
                return self._error(
                    f"execute.sh not found for configuration '{config_name}'. "
                    "Run create_execution_configuration first."
                )
            if not data_xml.exists():
                return self._error(
                    "profiler/Data.xml not found. Run instrument_project first to compile with instrumentation."
                )
            if not dp_settings.exists():
                return self._error("dp_settings.json not found. Run initialize_discopop_directory first.")

            pm_args = self._make_pm_args(project_path, timeout_seconds)

            self._log_action(
                project_path,
                "run_instrumented_binary",
                f"Launching execute.sh for config='{config_name}' to collect runtime profiling data, timeout={timeout_seconds}s",
            )
            original_cwd = os.getcwd()
            try:
                exec_result = execute_configuration(
                    arguments=pm_args,
                    project_copy_root_path=project_path,
                    config_path=str(configs_dir / config_name),
                    settings_path=str(dp_settings),
                    script_path=str(execute_sh),
                    thread_count=1,
                    timeout=float(timeout_seconds),
                )
            finally:
                os.chdir(original_cwd)

            if exec_result is None:
                return self._error(
                    "execute_configuration returned None — dp_settings.json may be missing or malformed."
                )

            returncode, elapsed, stdout, stderr = exec_result

            profiler_dir = p / ".discopop" / "profiler"
            profiling_files = (
                [str(f.relative_to(p)) for f in profiler_dir.rglob("*") if f.is_file()] if profiler_dir.exists() else []
            )

            dyn_deps = p / ".discopop" / "profiler" / "dynamic_dependencies.txt"
            if returncode != 0:
                result = {
                    "status": "error",
                    "message": f"Binary execution failed with return code {returncode}.",
                    "returncode": returncode,
                    "elapsed_time": elapsed,
                    "stdout": stdout,
                    "stderr": stderr,
                }
            elif not dyn_deps.exists():
                result = {
                    "status": "error",
                    "message": (
                        "Binary ran but dynamic_dependencies.txt was not created. "
                        "The binary may not have been compiled with instrumentation — "
                        "re-run instrument_project and try again."
                    ),
                    "returncode": returncode,
                    "elapsed_time": elapsed,
                    "stdout": stdout,
                    "stderr": stderr,
                }
            else:
                self._log_action(
                    project_path,
                    "run_instrumented_binary",
                    f"Profiling complete in {elapsed}s: {len(profiling_files)} output files collected",
                )
                result = {
                    "status": "success",
                    "returncode": returncode,
                    "elapsed_time": elapsed,
                    "stdout": stdout,
                    "stderr": stderr,
                    "profiling_files": profiling_files,
                }

            self._log_response("run_instrumented_binary", result)
            return [TextContent(type="text", text=json.dumps(result))]

        except Exception as e:
            error_msg = f"Error running instrumented binary: {str(e)}"
            logger.error(error_msg, exc_info=True)
            return [TextContent(type="text", text=json.dumps({"status": "error", "message": error_msg}))]

    def _handle_run_pattern_detection(self, arguments: dict[str, Any]) -> list[TextContent]:
        try:
            project_path = arguments.get("project_path", "")

            p = Path(project_path)
            discopop_dir = p / ".discopop"
            data_xml = discopop_dir / "profiler" / "Data.xml"
            dyn_deps = discopop_dir / "profiler" / "dynamic_dependencies.txt"

            if not data_xml.exists():
                return self._error("profiler/Data.xml not found. Run instrument_project first.")
            if not dyn_deps.exists():
                return self._error("profiler/dynamic_dependencies.txt not found. Run run_instrumented_binary first.")

            venv_bin = os.path.dirname(sys.executable)
            env = os.environ.copy()
            if venv_bin not in env.get("PATH", ""):
                env["PATH"] = venv_bin + os.pathsep + env.get("PATH", "")

            explorer = shutil.which("discopop_explorer", path=env["PATH"])
            if not explorer:
                return self._error(
                    "discopop_explorer not found on PATH. "
                    "Ensure the DiscoPoP library package is installed: pip install ./library"
                )

            self._log_action(project_path, "run_pattern_detection", f"Invoking discopop_explorer in {discopop_dir}")
            proc = subprocess.run(
                [explorer],
                cwd=str(discopop_dir),
                capture_output=True,
                text=True,
                env=env,
            )

            patterns_json = discopop_dir / "explorer" / "patterns.json"
            pattern_types: dict[str, int] = {"do_all": 0, "reduction": 0, "task": 0, "pipeline": 0}
            patterns_found = 0
            if patterns_json.exists():
                try:
                    data = json.loads(patterns_json.read_text())
                    patterns = data.get("patterns", {})
                    for key in pattern_types:
                        count = len(patterns.get(key, []))
                        pattern_types[key] = count
                        patterns_found += count
                except Exception:
                    pass

            if proc.returncode != 0:
                result = {
                    "status": "error",
                    "message": f"discopop_explorer failed with return code {proc.returncode}.",
                    "returncode": proc.returncode,
                    "stdout": proc.stdout,
                    "stderr": proc.stderr,
                }
            else:
                self._log_action(
                    project_path,
                    "run_pattern_detection",
                    f"Pattern detection complete: {patterns_found} patterns found (do_all={pattern_types['do_all']}, reduction={pattern_types['reduction']}, task={pattern_types['task']}, pipeline={pattern_types['pipeline']})",
                )
                result = {
                    "status": "success",
                    "project_path": project_path,
                    "returncode": proc.returncode,
                    "patterns_found": patterns_found,
                    "pattern_types": pattern_types,
                    "stdout": proc.stdout,
                    "stderr": proc.stderr,
                }

            self._log_response("run_pattern_detection", result)
            return [TextContent(type="text", text=json.dumps(result))]

        except Exception as e:
            error_msg = f"Error running pattern detection: {str(e)}"
            logger.error(error_msg, exc_info=True)
            return [TextContent(type="text", text=json.dumps({"status": "error", "message": error_msg}))]

    def _handle_get_parallelization_patches(self, arguments: dict[str, Any]) -> list[TextContent]:
        try:
            project_path = arguments.get("project_path", "")
            pattern_id_filter: Optional[int] = arguments.get("pattern_id")

            p = Path(project_path)
            patch_gen_dir = p / ".discopop" / "patch_generator"

            if not patch_gen_dir.exists():
                return self._error("patch_generator directory not found. Run run_pattern_detection first.")

            patches = []
            for pattern_dir in sorted(patch_gen_dir.iterdir(), key=lambda d: d.name):
                if not pattern_dir.is_dir():
                    continue
                try:
                    pid = int(pattern_dir.name)
                except ValueError:
                    continue

                if pattern_id_filter is not None and pid != pattern_id_filter:
                    continue

                for patch_file in sorted(pattern_dir.glob("*.patch")):
                    patch_content = patch_file.read_text()
                    source_file = self._extract_source_from_patch(patch_content)
                    patches.append(
                        {
                            "pattern_id": pid,
                            "source_file": source_file,
                            "patch_content": patch_content,
                        }
                    )

            pattern_ids: list[int] = sorted({p["pattern_id"] for p in patches if isinstance(p["pattern_id"], int)})
            self._log_action(
                project_path,
                "get_parallelization_patches",
                f"Found {len(patches)} patches across {len(pattern_ids)} pattern IDs: {pattern_ids}",
            )
            result = {
                "status": "success",
                "project_path": project_path,
                "patches": patches,
            }
            self._log_response("get_parallelization_patches", result)
            return [TextContent(type="text", text=json.dumps(result))]

        except Exception as e:
            error_msg = f"Error retrieving parallelization patches: {str(e)}"
            logger.error(error_msg, exc_info=True)
            return [TextContent(type="text", text=json.dumps({"status": "error", "message": error_msg}))]

    @staticmethod
    def _extract_source_from_patch(patch_content: str) -> Optional[str]:
        """Extract the original source file path from the --- line of a unified diff."""
        for line in patch_content.splitlines():
            if line.startswith("--- "):
                path_part = line[4:].split("\t")[0].strip()
                if path_part and path_part != "/dev/null":
                    return path_part
        return None

    async def run(self) -> None:
        """Run the server using stdio transport."""
        from mcp.server.stdio import stdio_server

        logger.info("Starting DiscoPoP MCP Server (stdio mode)")
        async with stdio_server() as (read_stream, write_stream):
            await self.server.run(read_stream, write_stream, self.server.create_initialization_options())


def main() -> None:
    import argparse
    import asyncio

    agent_choices = list(MCPSetup.AGENTS.keys())

    parser = argparse.ArgumentParser(
        description="DiscoPoP MCP Server - Exposes DiscoPoP functionality to Claude",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog=f"""
Examples:
  %(prog)s                        # Start the MCP server (stdio mode)
  %(prog)s --debug                # Start with debug logging
  %(prog)s --setup <agent>        # Configure a specific agent
  %(prog)s --setup <agent> --debug  # Configure with debug logging enabled
  %(prog)s --setup-all            # Configure all agents
  %(prog)s --verify <agent>       # Verify agent setup
  %(prog)s --status               # Show current setup status

Available agents: {', '.join(agent_choices)}
        """,
    )

    parser.add_argument(
        "--debug",
        action="store_true",
        help="Enable debug logging (server mode) or configure server with debug logging (setup mode)",
    )

    setup_group = parser.add_argument_group("setup")
    setup_group.add_argument(
        "--setup",
        choices=agent_choices,
        metavar="AGENT",
        help=f"Configure MCP server for a specific agent (choices: {', '.join(agent_choices)})",
    )
    setup_group.add_argument(
        "--setup-all",
        action="store_true",
        help="Configure MCP server for all available agents",
    )
    setup_group.add_argument(
        "--verify",
        choices=agent_choices,
        metavar="AGENT",
        help="Verify MCP server setup for a specific agent",
    )
    setup_group.add_argument(
        "--status",
        action="store_true",
        help="Show current setup status",
    )
    setup_group.add_argument(
        "--full-path",
        action="store_true",
        help="Use full path to discopop_mcp_server instead of just the command name",
    )
    setup_group.add_argument(
        "-v",
        "--verbose",
        action="store_true",
        help="Enable verbose output during setup",
    )

    args = parser.parse_args()

    is_setup_mode = any([args.setup, args.setup_all, args.verify, args.status])

    if is_setup_mode:
        setup = MCPSetup(verbose=args.verbose)
        try:
            if args.status:
                setup.show_status()
                sys.exit(0)

            if args.setup:
                success = setup.setup_agent(args.setup, use_debug=args.debug, use_full_path=args.full_path)
                sys.exit(0 if success else 1)

            if args.setup_all:
                all_success = all(
                    setup.setup_agent(
                        agent, use_debug=args.debug, use_full_path=args.full_path, skip_if_not_installed=True
                    )
                    for agent in MCPSetup.AGENTS
                )
                sys.exit(0 if all_success else 1)

            if args.verify:
                success = setup.verify_setup(args.verify)
                sys.exit(0 if success else 1)

        except KeyboardInterrupt:
            print("Setup cancelled by user")
            sys.exit(130)
        except Exception as e:
            print(f"Setup failed: {e}", file=sys.stderr)
            if args.verbose:
                import traceback

                traceback.print_exc()
            sys.exit(1)
    else:
        server = DiscoPopMCPServer(debug=args.debug)
        try:
            asyncio.run(server.run())
        except KeyboardInterrupt:
            logger.info("Server shutting down...")
            sys.exit(0)
        except Exception as e:
            logger.error(f"Fatal error: {e}", exc_info=True)
            sys.exit(1)


if __name__ == "__main__":
    main()
