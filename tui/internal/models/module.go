package models

// Module represents a Jin-TermX module.
type Module struct {
	Name        string `json:"name"`
	Description string `json:"description"`
	ToolCount   int    `json:"tool_count"`
	Installed   int    `json:"installed"`
	Version     string `json:"version,omitempty"`
}

// Tool represents an installable tool within a module.
type Tool struct {
	Name        string `json:"name"`
	Flag        string `json:"flag"`
	Description string `json:"description"`
	Installed   bool   `json:"installed"`
	Version     string `json:"version,omitempty"`
}

// InstallProgress represents a live installation progress update.
type InstallProgress struct {
	Tool       string  `json:"tool"`
	Percentage float64 `json:"percentage"`
	Speed      string  `json:"speed,omitempty"`
	ETA        string  `json:"eta,omitempty"`
	Line       string  `json:"line,omitempty"`
	Done       bool    `json:"done"`
	Error      string  `json:"error,omitempty"`
}
