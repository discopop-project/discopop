---
layout: default
title: VS Code extension
parent: Setup
nav_order: 4
---

# VS Code extension

The DiscoPoP VS Code extension is an extension to the [GUI](../tools/GUI.md). It lets you browse the parallelization suggestions and the hotspots that DiscoPoP identified, and apply suggestions, inside the editor. The main way to use DiscoPoP is the GUI (`discopop_gui`) or the [command line tools](../examples/walk_through.md); the extension is an optional addition for those who prefer to stay in VS Code.

![Suggestions in the DiscoPoP VS Code extension](../assets/README/Screenshot_1.png)

## What DiscoPoP needs to provide

The extension reads results, it does not replace the analysis. Before you open a project in the extension, analyze it with DiscoPoP (GUI or command line), so that a `.discopop` directory exists in the project:

- the explorer results (run the *Pattern Detection* tab of the GUI or `discopop_explorer` inside `.discopop`) for the suggestions and their patches, and
- the results of the hotspot detection, if you want to see hotspots.

## Install the extension

1. Install [VS Code](https://code.visualstudio.com/) (Linux, or Windows with [WSL](https://code.visualstudio.com/docs/remote/wsl-tutorial)).
2. Install the [DiscoPoP extension](https://marketplace.visualstudio.com/items?itemName=TUDarmstadt-LaboratoryforParallelProgramming.discopop) from the VS Code marketplace.
3. Install DiscoPoP itself as described in [Installation](./discopop.md).

## Open the results of a project

The explorer prints this procedure when it finishes. To browse the results of an analyzed project:

1. Open the DiscoPoP view in VS Code (by default in the left sidebar).
2. In *Configurations*, add a configuration with `+` and choose *ViewOnly*.
3. Select a name and provide the path of the `.discopop` directory of your project.
4. Load the results (clock-like icon).

The [VS Code extension walk-through](../examples/walk_through_vscode.md) shows these steps with the example program.

## Troubleshooting

Use compatible versions of DiscoPoP and the extension: the latest released versions should always work together. If you run into problems, create an issue in the [extension's repository](https://github.com/discopop-project/discopop-gui-vscode/issues).
<!-- UNVERIFIED: this is the old organization name; the repository was not found under tuda-hpclab, and whether it moved is not confirmed. -->
<!-- UNVERIFIED: that the current extension version reads the results of this DiscoPoP version without the DiscoPoP build directory (the old documentation required a build in <root>/build). -->
