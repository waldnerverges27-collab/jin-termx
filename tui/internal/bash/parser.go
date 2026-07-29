package bash

import (
	"encoding/json"

	"github.com/waldnerverges27-collab/jin-termx/tui/internal/models"
)

// ParseModules parses JSON output from `jinx list --json`.
func ParseModules(data string) ([]models.Module, error) {
	var modules []models.Module
	if err := json.Unmarshal([]byte(data), &modules); err != nil {
		return nil, parseError("modules", data, err)
	}
	return modules, nil
}

// ParseTools parses JSON output of tool listing.
func ParseTools(data string) ([]models.Tool, error) {
	var tools []models.Tool
	if err := json.Unmarshal([]byte(data), &tools); err != nil {
		return nil, parseError("tools", data, err)
	}
	return tools, nil
}

// ParseMemories parses JSON output from `jinx brain --json`.
func ParseMemories(data string) ([]models.Memory, error) {
	var memories []models.Memory
	if err := json.Unmarshal([]byte(data), &memories); err != nil {
		return nil, parseError("memories", data, err)
	}
	return memories, nil
}

// ParseDatabases parses JSON output from `jinx pg --json`.
func ParseDatabases(data string) ([]models.Database, error) {
	var databases []models.Database
	if err := json.Unmarshal([]byte(data), &databases); err != nil {
		return nil, parseError("databases", data, err)
	}
	return databases, nil
}

func parseError(kind, raw string, err error) error {
	return &ParseError{
		Kind: kind,
		Raw:  raw[:min(len(raw), 200)],
		Err:  err,
	}
}

func min(a, b int) int {
	if a < b {
		return a
	}
	return b
}

// ParseError describes a JSON parsing failure.
type ParseError struct {
	Kind string
	Raw  string
	Err  error
}

func (e *ParseError) Error() string {
	return "failed to parse " + e.Kind + ": " + e.Err.Error()
}

func (e *ParseError) Unwrap() error {
	return e.Err
}
