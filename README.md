# vs_build.vim
Build and run Visual Studio projects from vim.

Currently builds only x64 projects

## Commands
* `VSBuild` Builds the project in the current configuration mode (default: release)
* `VSRun` Runs the first executable found in the project
* `VSBuildAndRun` Builds the project then runs the first executable found
* `VSBuildMode(mode)` Sets a build configuration mode
* `VSAddBuildMode(mode) | VSRemoveBuildMode(mode)` Adds/Removes a build configuration mode <em>(temporary solution)</em>
