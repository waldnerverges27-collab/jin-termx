// Package bash provides a bridge between the Go TUI and existing jinx Bash scripts.
//
// It executes jinx commands as subprocesses, captures stdout/stderr in real-time,
// and parses JSON output into Go types. All Bash scripts remain untouched.
package bash

import (
	"bufio"
	"context"
	"os/exec"
	"sync"

	"github.com/waldnerverges27-collab/jin-termx/tui/internal/models"
)

// Executor runs jinx commands and streams output.
type Executor struct {
	jinxPath string
}

// NewExecutor creates an Executor by resolving the jinx binary path.
func NewExecutor() (*Executor, error) {
	path, err := exec.LookPath("jinx")
	if err != nil {
		return nil, err
	}
	return &Executor{jinxPath: path}, nil
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
