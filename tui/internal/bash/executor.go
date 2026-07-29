// Package bash provides a bridge between the Go TUI and existing jinx Bash scripts.
//
// It executes jinx commands as subprocesses, captures stdout/stderr in real-time,
// and parses JSON output into Go types. All Bash scripts remain untouched.
package bash

import (
	"bufio"
	"context"
	"os"
	"os/exec"
	"sync"

	"github.com/waldnerverges27-collab/jin-termx/tui/internal/models"
)

// Executor runs jinx commands and streams output.
type Executor struct {
	jinxPath string
}

// NewExecutor creates an Executor by finding the jinx binary.
// Uses os.Stat instead of exec.LookPath to avoid the faccessat2 syscall
// which is blocked by Android's seccomp filter (causes SIGSYS crash).
func NewExecutor() (*Executor, error) {
	path := findJinx()
	if path == "" {
		return nil, &RunError{Stderr: "jinx not found in PATH"}
	}
	return &Executor{jinxPath: path}, nil
}

// findJinx locates the jinx binary by checking common paths with os.Stat.
func findJinx() string {
	candidates := []string{
		"/data/data/com.termux/files/usr/bin/jinx",
		"/usr/bin/jinx",
		"/usr/local/bin/jinx",
	}
	// Also check PREFIX if set
	if prefix := os.Getenv("PREFIX"); prefix != "" {
		candidates = append([]string{prefix + "/bin/jinx"}, candidates...)
	}
	for _, p := range candidates {
		if fi, err := os.Stat(p); err == nil && !fi.IsDir() {
			return p
		}
	}
	return ""
}

// Run executes a jinx command and returns stdout as a string.
func (e *Executor) Run(ctx context.Context, args ...string) (string, error) {
	cmd := exec.CommandContext(ctx, e.jinxPath, args...)
	out, err := cmd.Output()
	if err != nil {
		if ee, ok := err.(*exec.ExitError); ok {
			return string(out), &RunError{Stderr: string(ee.Stderr), ExitCode: ee.ExitCode()}
		}
		return string(out), err
	}
	return string(out), nil
}

// RunStream executes a command and streams stdout line by line.
// Lines are sent to the lineCh channel. The final models.InstallProgress with Done=true
// is sent when the process completes.
func (e *Executor) RunStream(ctx context.Context, lineCh chan<- models.InstallProgress, args ...string) error {
	defer close(lineCh)

	cmd := exec.CommandContext(ctx, e.jinxPath, args...)

	stdout, err := cmd.StdoutPipe()
	if err != nil {
		return err
	}
	stderr, err := cmd.StderrPipe()
	if err != nil {
		return err
	}

	var wg sync.WaitGroup
	wg.Add(2)

	// Stream stdout
	go func() {
		defer wg.Done()
		scanner := bufio.NewScanner(stdout)
		for scanner.Scan() {
			lineCh <- models.InstallProgress{Line: scanner.Text()}
		}
	}()

	// Stream stderr
	go func() {
		defer wg.Done()
		scanner := bufio.NewScanner(stderr)
		for scanner.Scan() {
			lineCh <- models.InstallProgress{Line: scanner.Text()}
		}
	}()

	if err := cmd.Start(); err != nil {
		return err
	}
	wg.Wait()
	err = cmd.Wait()
	lineCh <- models.InstallProgress{Done: true}
	return err
}

// RunError represents a failed subprocess execution.
type RunError struct {
	Stderr   string
	ExitCode int
}

func (e *RunError) Error() string {
	return e.Stderr
}
