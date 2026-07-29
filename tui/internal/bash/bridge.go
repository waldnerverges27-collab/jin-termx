package bash

import (
	"context"
	"fmt"

	"github.com/waldnerverges27-collab/jin-termx/tui/internal/models"
)

// Bridge provides a high-level API over jinx subprocess calls.
type Bridge struct {
	exec *Executor
}

// NewBridge creates a Bridge, resolving jinx path on init.
func NewBridge() (*Bridge, error) {
	exec, err := NewExecutor()
	if err != nil {
		return nil, fmt.Errorf("jinx not found: %w", err)
	}
	return &Bridge{exec: exec}, nil
}

// ListModules returns all available modules.
func (b *Bridge) ListModules(ctx context.Context) ([]models.Module, error) {
	out, err := b.exec.Run(ctx, "list", "--json")
	if err != nil {
		return nil, err
	}
	return ParseModules(out)
}

// ListTools returns tools for a module.
func (b *Bridge) ListTools(ctx context.Context, module string) ([]models.Tool, error) {
	out, err := b.exec.Run(ctx, "list", module, "--json")
	if err != nil {
		return nil, err
	}
	return ParseTools(out)
}

// Install starts an installation and streams progress.
func (b *Bridge) Install(ctx context.Context, module string, tools []string, progress chan<- models.InstallProgress) error {
	args := []string{"install", module}
	for _, t := range tools {
		args = append(args, "--"+t)
	}
	return b.exec.RunStream(ctx, progress, args...)
}

// Doctor returns system health check results.
func (b *Bridge) Doctor(ctx context.Context) (string, error) {
	return b.exec.Run(ctx, "doctor", "--json")
}

// BrainList returns all brain memories.
func (b *Bridge) BrainList(ctx context.Context) ([]models.Memory, error) {
	out, err := b.exec.Run(ctx, "brain", "ls", "--json")
	if err != nil {
		return nil, err
	}
	return ParseMemories(out)
}

// PGList returns all PostgreSQL databases.
func (b *Bridge) PGList(ctx context.Context) ([]models.Database, error) {
	out, err := b.exec.Run(ctx, "pg", "list", "--json")
	if err != nil {
		return nil, err
	}
	return ParseDatabases(out)
}
