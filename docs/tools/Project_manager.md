---
layout: default
title: Project manager
parent: Tools
nav_order: 9
---

# DiscoPoP project manager
## Executable
`discopop_project_manager` (`discopop` opens the same tool with its graphical interface, equivalent to `--gui`)

## Purpose
Initialize a project for use with the DiscoPoP framework and manage its *execution configurations*: named descriptions of how the project is built, how it is run, and how the correctness of a run is checked. Configurations are consumed by the project manager itself and by the [empirical autotuner](Autotuner.md), which compiles, executes and validates candidate parallelizations through them.

## Required input
- A project that can be copied to a sibling directory and built there
- A configuration directory below `.discopop`, created via `--init`

## Configuration directory
All configurations live below `.discopop/project/configs/`:

```
.discopop/project/configs/
├── compile.sh                  # shared build
├── compile_validate.sh         # optional: shared build used for validation only
├── seq_settings.json           # compilers and flags per mode
├── dp_settings.json
├── hd_settings.json
├── par_settings.json
└── <configuration_name>/
    ├── execute.sh              # required: the timed run
    ├── validate.sh             # optional: untimed correctness check
    ├── execution_time.json     # optional: read the runtime from the program's output
    ├── compile.sh              # optional: build override for this configuration
    └── compile_validate.sh     # optional: validation build override for this configuration
```

Every script is executed with the project root as its working directory, so relative paths may be used as if already in the project root. Each script must exit `0` on success. The following environment variables are available:

| Variable | Meaning |
|---|---|
| `$CC`, `$CXX` | compiler executables, taken from the settings file of the active mode |
| `$CFLAGS`, `$CXXFLAGS` | compiler flags, likewise from the settings file |
| `$DP_PROJECT_ROOT_DIR` | absolute path of the (possibly copied) project root |
| `$DOT_DISCOPOP` | absolute path of the `.discopop` directory inside that root |
| `$OMP_NUM_THREADS` | thread count of the current run |

Build scripts must use `$CC` / `$CXX` and `$CFLAGS` / `$CXXFLAGS` rather than hard-coded compiler names. The same script is reused for sequential builds, DiscoPoP instrumentation, hotspot detection and parallel builds; only the settings file changes between them.

### Execution modes
A run selects one of four modes, each backed by its own settings file:

| Mode | Purpose | Scripts executed |
|---|---|---|
| `seq` | sequential baseline | build → `execute.sh` → *validation* |
| `par` | parallelized code | build → `execute.sh` → *validation* |
| `dp` | DiscoPoP instrumentation | build → `execute.sh` |
| `hd` | hotspot detection instrumentation | build → `execute.sh` |

Only `execute.sh` is timed, and its duration is what the autotuner compares. The validation step is skipped entirely for `dp` and `hd`, which are profiling runs: re-running an instrumented binary would regenerate its profiling data.

### Measured runtime
By default the runtime of a run is the wall clock time of `execute.sh`. That also covers setup and teardown, reading input files and writing results — work that is often not what a parallelization is meant to speed up, and that dilutes every speedup computed from it.

When the program prints the duration of the region that actually matters, that value can be measured instead. The search is configured per configuration in `execution_time.json`, next to the `execute.sh` it applies to:

```json
{
  "enabled": true,
  "regex": "Total time:\\s*([0-9.]+)"
}
```

`regex` is a regular expression whose **first capture group** holds the value; the example above reads `1.234` out of `Total time: 1.234 seconds`. Leaving the file out, or setting `enabled` to `false`, measures the wall clock time as before — the stored pattern is kept either way, so switching the search off does not discard it. The default pattern looks for `<DP_EXEC_TIME>1.234</DP_EXEC_TIME>`, a tag a program can print regardless of how the rest of its output is formatted.

Both output streams are searched (`stdout` first, then `stderr`), and of several matches the **last** one is used, so a program printing a time per phase may end with the total. Only `execute.sh` is searched: `compile.sh` and `validate.sh` produce no measurement.

`--execution-time-regex` overrides the stored setting of every configuration for a single run:

| Given as | Effect |
|---|---|
| *(omitted)* | each configuration's `execution_time.json` applies |
| `--execution-time-regex` | search for the `<DP_EXEC_TIME>` tag |
| `--execution-time-regex 'Total time:\s*([0-9.]+)'` | search for that pattern |
| `--execution-time-regex ''` | measure the wall clock time, even where a configuration enables the search |

`discopop_auto_tuner` accepts the same option, so the search that ranks candidate patch sets measures the same time the report does.

If the pattern finds nothing, the wall clock time is measured instead and a warning is logged. Such a run is recorded with `"time_source": "wall_clock_fallback"`, so a fallback is never mistaken for a program that reported its own time. Every entry in `execution_results.json` carries the measured wall clock time as `wall_clock_time` alongside the reported `time`, whichever of the two `time` holds.

### Output validation
`validate.sh` is optional. Without it, a run counts as correct exactly when `execute.sh` exits `0`. With it, the run counts as correct only when **both** exit `0`. It is run separately from `execute.sh` so that validation work — dumping output, diffing against a reference — never enters the runtime measurement.

`validate.sh` may need a differently compiled binary than `execute.sh`: built with extra checks, against a reference implementation, or with an output-dumping flag. Provide those build instructions in `compile_validate.sh`. The full validation step is then:

```
build (compile.sh)          →  execute.sh          →  build (compile_validate.sh)  →  validate.sh
        timeout-compilation        timeout-execution         timeout-compilation           timeout-validation
```

The validation build deliberately runs *after* the timed `execute.sh`, so it can never replace the binary whose runtime is being measured. If it fails, `validate.sh` is skipped and the run counts as incorrect. A `compile_validate.sh` is ignored for configurations that define no `validate.sh`, since there would be nothing to run against that build.

### Compile script resolution
Two build scripts are resolved independently: the one used for `execute.sh` and the one used for `validate.sh`. Both fall back from specific to shared, and the validation build additionally falls back to the execute build:

**Build for `execute.sh`**
1. `<configuration_name>/compile.sh`
2. `compile.sh`

**Build for `validate.sh`**
1. `<configuration_name>/compile_validate.sh`
2. `compile_validate.sh`
3. the build resolved for `execute.sh`

Note that the *role* of a script outranks how specific it is: a shared `compile_validate.sh` is used for validation even by a configuration that has its own `compile.sh` override. Reaching step 3 means a single build serves both scripts, which is the behaviour of a project that defines no validation build at all.

| Present files | Build for `execute.sh` | Build for `validate.sh` |
|---|---|---|
| `compile.sh` | `compile.sh` | `compile.sh` |
| `compile.sh`, `foo/compile.sh` | `foo/compile.sh` | `foo/compile.sh` |
| `compile.sh`, `compile_validate.sh` | `compile.sh` | `compile_validate.sh` |
| `compile.sh`, `foo/compile.sh`, `compile_validate.sh` | `foo/compile.sh` | `compile_validate.sh` |
| `compile.sh`, `compile_validate.sh`, `foo/compile_validate.sh` | `compile.sh` | `foo/compile_validate.sh` |

### Editing configurations
- **Graphically:** `discopop` (or `discopop_project_manager --gui`). The configuration assistant creates a first configuration; afterwards the editor's sub-tabs manage `execute.sh`, `validate.sh` and the two override scripts, each with an *Add* / *Remove* button, while the *Compilation Editor* manages the shared `compile.sh`, `compile_validate.sh` and the settings files. The *execute.sh* sub-tab also carries that configuration's *Execution time* setting, with a *Test* button that applies the pattern to the output of the last recorded run without executing anything.
- **By hand:** create the files listed above and mark them executable.
- **Through an LLM agent:** the [DiscoPoP MCP server](https://github.com/discopop-project/discopop/tree/master/mcp_server) exposes `set_compile_script` (with `purpose` selecting `compile.sh` or `compile_validate.sh`) and `create_execution_configuration` (which writes `execute.sh` and optionally `validate.sh` plus the override scripts).

## Output
- Execution results of every script run, collected in `.discopop/project/execution_results.json`
- Optional reports below `.discopop/project/reports`, generated via `--report`
- Unless `--inplace` is given, each run happens in a copy of the project directory created next to it, which is removed again afterwards unless `--skip-cleanup` is given

## Note
For a more detailed description of the available run-time arguments, please refer to the help string of the respective tool.
```
discopop_project_manager --help
```
