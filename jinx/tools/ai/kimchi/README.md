# Kimchi

Terminal coding agent powered by Kimchi's multi-model orchestration

**Package:** kimchi
**Author:** DevCoreX
**Repository:** https://github.com/waldnerverges27-collab/jin-termx
**Official:** https://github.com/getkimchi/kimchi
**Type:** AI coding agent (Binary + glibc bootstrapper)
**License:** MIT

## Description

A coding agent CLI powered by kimchi. Built on the pi-mono coding agent SDK, kimchi gives you an AI-powered development assistant in your terminal that connects to kimchi's LLM infrastructure

## Dependencies

- **Native mode:** glibc-repo, glibc, clang, git, ripgrep, jq, nodejs-lts, curl, tar
- **Proot mode:** proot-distro, curl, ca-certificates, tar

## Install

```bash
jinx install ai --kimchi
```

You will be prompted to choose:

1. **Native (recommended)** — Compiles a glibc bootstrapper and downloads the latest Kimchi binary from GitHub releases
2. **Proot-distro (alternative)** — Runs Kimchi inside an Ubuntu proot-distro container

## Uninstall

```bash
jinx uninstall ai --kimchi
```

## Update

```bash
jinx update ai --kimchi
```

## Notes

- **Native mode** requires `glibc-repo`, `glibc`, `clang`, and other dependencies (installed automatically)
- The native binary is stored in `~/.local/share/jin-termx-data/kimchi/`
- A small C bootstrapper (`kimchi_helper.c`) handles ELF loading via the glibc dynamic linker
- Auxiliary files are symlinked to `~/.local/share/kimchi/` for Kimchi to find themes and config
- **Proot mode** uses `proot-distro ubuntu` and downloads the binary directly from GitHub releases
- Data directory: `~/.local/share/jin-termx-data/kimchi/`
