# CodeGraph

Analyzes your codebase structure and dependencies to improve navigation

**Package:** codegraph  
**Author:** JinDev  
**Repository:** https://github.com/waldnerverges27-collab/jin-termx  
**Official:** https://github.com/colbymchenry/codegraph  
**Type:** Code analysis tool (Binary)  
**License:** MIT

## Description

CodeGraph analyzes your codebase structure and dependencies to improve navigation. It generates interactive graphs showing relationships between files, functions, classes, and modules, making it easier to navigate and refactor large projects.

## Dependencies

- nodejs-lts, ripgrep, sqlite, git, clang, make, curl

## Install

```bash
jinx install ai --codegraph
```

## Uninstall

```bash
jinx uninstall ai --codegraph
```

## Update

```bash
jinx update ai --codegraph
```

## Notes

- Downloads the latest ARM64 binary from GitHub releases
- Wrapper script installed to `$PREFIX/bin/codegraph`
- Data stored in `$JINX_DATA/codegraph-linux-arm64/`

