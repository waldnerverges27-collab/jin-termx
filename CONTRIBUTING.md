# Contributing to Jin-TermX TUI

## Development Setup

1. Ensure Go 1.22+ is installed: `pkg install golang`
2. Clone the repo: `git clone https://github.com/waldnerverges27-collab/jin-termx-tui.git`
3. Enter TUI directory: `cd jin-termx-tui/tui`
4. Build: `go build -o jinx-tui ./cmd/jinx-tui/`
5. Run: `./jinx-tui`

Note: On Termux, `go build` may fail from sdcard (FUSE filesystem lacks RLock).
Copy to internal storage first:
```bash
cp -r jin-termx/tui /data/data/com.termux/files/home/tui-build
cd /data/data/com.termux/files/home/tui-build
go build -o jinx-tui ./cmd/jinx-tui/
```

## Project Structure

```
tui/
├── cmd/jinx-tui/main.go       # Entry point
├── internal/
│   ├── models/                # Data types (module, memory, database, state)
│   ├── bash/                  # Bash bridge (executor, parser)
│   └── ui/
│       ├── components/        # Reusable widgets (tabbar, card, progress, etc.)
│       ├── app.go             # Root Bubble Tea model
│       ├── dashboard.go       # Home screen
│       ├── installer.go       # Module installer screen
│       ├── brain.go           # Brain explorer screen
│       ├── pg.go              # PostgreSQL manager screen
│       ├── doctor.go          # Diagnostic screen
│       └── config.go          # Settings screen
```

## Code Guidelines

- Follow standard Go project layout (cmd/, internal/)
- Use Catppuccin Mocha theme colors from ui/theme.go
- No Nerd Font icons — use Unicode symbols only
- Tests required for all parser/bridge functions
- Run `gofmt -s` before committing

## Pull Request Process

1. `go test ./... -v -count=1` — all tests pass
2. `golangci-lint run ./...` — no lint errors
3. After merge to main, recompile and commit the binary:
   ```bash
   cd tui
   go build -ldflags="-s -w" -o ../bin/jinx-tui-arm64 ./cmd/jinx-tui/
   cd ..
   git add bin/
   git commit -m "chore: update pre-compiled binary"
   ```
   The install script at `install-tui.sh` downloads from `bin/jinx-tui-{arch}` directly.

## Reporting Issues

Include: Termux version, Go version, and the output from `~/.cache/jin-termx/tui-error.log`
