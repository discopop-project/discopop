---
layout: default
title: Walk-through example (VSCode)
parent: Examples
nav_order: 2
---

# Walk-through example using the DiscoPoP VS Code Extension

This example will show the complete process to generate parallel code from the provided example code using the DiscoPoP VS Code extension.

The VS Code extension is the recommended way to run DiscoPoP on any project that provides a CMake build.
If your project does not provide a CMakeLists.txt file, you can still use the extension to view the results of a manual execution of DiscoPop.

## Prerequisites

- Follow the [Setup Tutorial for the VS Code Extension](../setup/vscx.md) before continuing.

## Step 1: Create a Project Configuration

In this step we tell the extension where to find the project that is to be analyzed. Open the DiscoPoP view within VS Code. By default it is located on the left sidebar within the VS Code window.

<!-- TODO add screenshot -->

Hovering over the 'CONFIGURATIONS' section will reveal a '+' symbol. Click on it to start configuring your project.

<!-- TODO add screenshot -->

Select 'CMake' and provide the requested information. You will be asked for the following information:

- A **name for the configuration**. This can be any text to help you identify this configuration later. e.g. 'Example Project'.
- The absolute **path to the project root**. The provided directory must contain the CMakeLists.txt file to build the project. For this tutorial we provide an example within the 'example' directory of the DiscoPoP source code so lets provide the absolute path to that directory.
- The **path to a build directory**. Notice that this defaults to the "build" directory within the previously given project path. Since this is a reasonable default in this case, simply confirm using the enter key.
- **Build arguments** for the CMake build can optionally be provided. For the provided example no additional arguments are required, so you can again confirm using the enter key.
- Now the **name of the executable** needs to be specified. The CMake build-configuration provided with the example will build an executable called 'cmake_example', so type 'cmake_example' and confirm using enter.
- Now we need to specify the **executable arguments** that will be used during the execution of the instrumented application. The executable of the example project does not require any arguments, so we can simply confirm again.


## Step 2: Run DiscoPoP

Once the configuration setup is complete, it will show up in the 'CONFIGURATIONS' section of the DiscoPoP view. You can expand the list entry to view or edit the configuration.

Right click on the root of a configuration to open the context menu and select 'Run DiscoPoP'. Alternatively you can also click on the 'Run DiscoPoP' icon that shows up when hovering over the configuration root. Hover over the icons to learn what they do. Depending on your settings you might need to confirm that the build directory will be overwritten if it already exists. You can disable this warning in the extension settings.

And there you go. A notification will appear that informs you about the progress being made. Once the run is completed the results can be seen in the 'SUGGESTIONS' section of the DiscoPoP view.

Optionally you can also run the DiscoPoP optimizer from the configuration's context menu to obtain optimized results. Note that the optimizer can only be run if DiscoPoP has been run before.


## Step 3: View and Apply Suggestions

The 'SUGGESTIONS' section of the DiscoPoP view provides a list of all the found suggestions. Click on a suggestion and you can see the details in the 'SUGGESTION DETAILS' section. Also the relevant code section will be highlighted in the editor.

When you hover over a suggestion, you can click on the appearing icon to apply a suggestion (or rollback its application if it was already applied).

Alternatively, you can also open a source file in the VS Code editor. Within the source code, annotations will tell you if a suggestion for that code section has been found. Clicking on the annotation will apply it. If there are multiple suggestions for the same code section then you will be asked which suggestion to apply.


## Advanced Usage

- Within the build directory specified in a configuration, a .discopop directory will be created when DiscoPoP is run. You can open it in the terminal and use many of the discopop tools manually. Also you can take a look at the generated suggestions, patch files and much more.

- Edit the 'Executable Arguments for Hotspot Detection' of a configuration to also run the Hotspot Detection. Results can be viewed similar to the suggestions created by DiscoPoP.

- When creating configurations there are two other configuration types: ViewOnly and Script. They are quite similar to each other and allow you to view DiscoPoP and Hotspot Detection Results even for projects that do not use the CMake build system. You can specify the path to a .discopop directory and view/apply the results using the extension. If you create a script that runs DiscoPoP and outputs the results to a .discopop directory, then you can specify it in a 'Script' configuration which will allow to conveniently run it using the UI.
