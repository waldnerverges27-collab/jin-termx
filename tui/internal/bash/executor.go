// Package bash provides a bridge between the Go TUI and existing jinx Bash scripts.
//
// It executes jinx commands as subprocesses, captures stdout/stderr in real-time,
// and parses JSON output into Go types. All Bash scripts remain untouched.
//
// IMPORTANT: This package uses os.StartProcess + os.Pipe instead of os/exec.Command
// because Termux's Go build uses unix.Eaccess in findExecutable which calls the
// faccessat2 syscall (0x1b7) — blocked by Android's seccomp filter (SIGSYS crash).
package bash

import (
	"bufio"
	"bytes"
	"context"
	"fmt"
	"os"
	"sync"
	"syscall"
	"time"

	"github.com/waldnerverges27-collab/jin-termx/tui/internal/models"
)

// Executor runs jinx commands and streams output.
type Executor struct {
	jinxPath string
}

// NewExecutor creates an Executor by finding the jinx binary.
func NewExecutor() (*Executor, error) {
	path := findJinx()
	if path == "" {
		return nil, fmt.Errorf("jinx not found in PATH")
	}
	return &Executor{jinxPath: path}, nil
}

func findJinx() string {
	if prefix := os.Getenv("PREFIX"); prefix != "" {
		p := prefix + "/bin/jinx"
		if fi, err := os.Stat(p); err == nil && !fi.IsDir() && fi.Mode()&0111 != 0 {
			return p
		}
	}
	candidates := []string{
		"/data/data/com.termux/files/usr/bin/jinx",
		"/usr/bin/jinx",
		"/usr/local/bin/jinx",
	}
	for _, p := range candidates {
		if fi, err := os.Stat(p); err == nil && !fi.IsDir() && fi.Mode()&0111 != 0 {
			return p
		}
	}
	return ""
}

// Run executes a jinx command and returns stdout as a string.
func (e *Executor) Run(ctx context.Context, args ...string) (string, error) {
	argv := append([]string{e.jinxPath}, args...)

	stdoutR, stdoutW, err := os.Pipe()
	if err != nil {
		return "", err
	}
	defer stdoutR.Close()
	defer stdoutW.Close()

	_, err = os.StartProcess(e.jinxPath, argv, &os.ProcAttr{
		Files: []*os.File{nil, stdoutW, nil},
		Sys:   &syscall.SysProcAttr{},
	})
	if err != nil {
		return "", err
	}
	stdoutW.Close()

	var buf bytes.Buffer
	done := make(chan error, 1)
	go func() {
		_, err := buf.ReadFrom(stdoutR)
		done <- err
	}()

	select {
	case <-done:
	case <-ctx.Done():
		return buf.String(), ctx.Err()
	case <-time.After(30 * time.Second):
		return buf.String(), fmt.Errorf("timeout executing jinx")
	}

	return buf.String(), nil
}

// RunStream executes a command and streams stdout/stderr line by line.
func (e *Executor) RunStream(ctx context.Context, lineCh chan<- models.InstallProgress, args ...string) error {
	defer close(lineCh)

	argv := append([]string{e.jinxPath}, args...)

	stdoutR, stdoutW, err := os.Pipe()
	if err != nil {
		return err
	}
	stderrR, stderrW, err := os.Pipe()
	if err != nil {
		stdoutR.Close()
		stdoutW.Close()
		return err
	}

	proc, err := os.StartProcess(e.jinxPath, argv, &os.ProcAttr{
		Files: []*os.File{nil, stdoutW, stderrW},
		Sys:   &syscall.SysProcAttr{},
	})
	if err != nil {
		stdoutR.Close()
		stdoutW.Close()
		stderrR.Close()
		stderrW.Close()
		return err
	}

	stdoutW.Close()
	stderrW.Close()

	var wg sync.WaitGroup
	wg.Add(2)

	go func() {
		defer wg.Done()
		s := bufio.NewScanner(stdoutR)
		for s.Scan() {
			select {
			case lineCh <- models.InstallProgress{Line: s.Text()}:
			case <-ctx.Done():
				return
			}
		}
	}()

	go func() {
		defer wg.Done()
		s := bufio.NewScanner(stderrR)
		for s.Scan() {
			select {
			case lineCh <- models.InstallProgress{Line: s.Text()}:
			case <-ctx.Done():
				return
			}
		}
	}()

	wg.Wait()
	stdoutR.Close()
	stderrR.Close()

	state, err := proc.Wait()
	if err != nil {
		return err
	}

	lineCh <- models.InstallProgress{Done: true}

	if !state.Success() {
		return &RunError{ExitCode: state.ExitCode()}
	}
	return nil
}

// RunError represents a failed subprocess execution.
type RunError struct {
	Stderr   string
	ExitCode int
}

func (e *RunError) Error() string {
	if e.Stderr != "" {
		return e.Stderr
	}
	return fmt.Sprintf("exit code %d", e.ExitCode)
}