package bash

import (
	"errors"
	"testing"
)

func TestParseModules_Valid(t *testing.T) {
	data := `[{"name":"lang","description":"Languages","tool_count":9,"installed":9}]`
	modules, err := ParseModules(data)
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if len(modules) != 1 {
		t.Fatalf("expected 1 module, got %d", len(modules))
	}
	if modules[0].Name != "lang" {
		t.Errorf("expected name 'lang', got '%s'", modules[0].Name)
	}
}

func TestParseModules_Invalid(t *testing.T) {
	_, err := ParseModules(`not json`)
	if err == nil {
		t.Fatal("expected error for invalid JSON")
	}
	var pe *ParseError
	if !errors.As(err, &pe) {
		t.Errorf("expected *ParseError, got %T", err)
	}
}

func TestParseModules_Empty(t *testing.T) {
	modules, err := ParseModules(`[]`)
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if len(modules) != 0 {
		t.Fatalf("expected 0 modules, got %d", len(modules))
	}
}

func TestParseTools_Valid(t *testing.T) {
	data := `[{"name":"node","flag":"node","description":"Node.js runtime","installed":true,"version":"22.0.0"}]`
	tools, err := ParseTools(data)
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if len(tools) != 1 {
		t.Fatalf("expected 1 tool, got %d", len(tools))
	}
	if !tools[0].Installed {
		t.Errorf("expected installed=true")
	}
}

func TestParseTools_Invalid(t *testing.T) {
	_, err := ParseTools(`{broken}`)
	if err == nil {
		t.Fatal("expected error for invalid JSON")
	}
}

func TestParseMemories_Valid(t *testing.T) {
	data := `[{"title":"How to use Go","slug":"go-usage","category":"go","tags":["golang","tutorial"],"date":"2025-01-15","favorite":true}]`
	memories, err := ParseMemories(data)
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if len(memories) != 1 {
		t.Fatalf("expected 1 memory, got %d", len(memories))
	}
	if !memories[0].Favorite {
		t.Errorf("expected favorite=true")
	}
}

func TestParseDatabases_Valid(t *testing.T) {
	data := `[{"name":"jinxdb","size":"2.4 MB","table_count":12,"running":true}]`
	databases, err := ParseDatabases(data)
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if len(databases) != 1 {
		t.Fatalf("expected 1 database, got %d", len(databases))
	}
	if databases[0].Name != "jinxdb" {
		t.Errorf("expected name 'jinxdb', got '%s'", databases[0].Name)
	}
}

func TestParseDatabases_Invalid(t *testing.T) {
	_, err := ParseDatabases(`[{}]`)
	if err != nil {
		t.Fatalf("unexpected error for valid JSON with empty object: %v", err)
	}
}

func TestParseError_Unwrap(t *testing.T) {
	inner := errors.New("syntax error")
	pe := &ParseError{Kind: "test", Raw: "data", Err: inner}
	if !errors.Is(pe, inner) {
		t.Error("expected errors.Is to find inner error")
	}
	if pe.Error() != "failed to parse test: syntax error" {
		t.Errorf("unexpected error message: %s", pe.Error())
	}
}
