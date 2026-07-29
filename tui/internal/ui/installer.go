package ui

import (
	"fmt"
	"strings"

	"github.com/waldnerverges27-collab/jin-termx/tui/internal/models"
	"github.com/waldnerverges27-collab/jin-termx/tui/internal/ui/components"
)

// InstallerState tracks the module installer screen.
type InstallerState struct {
	Modules     []models.Module
	Tools       []models.Tool
	SelectedMod string
	Selected    map[string]bool // tool name → selected
	Query       string
	Installing  bool
	Progress    models.InstallProgress
	LogLines    []string
}

func renderInstaller(m *Model, width int) string {
	if m.installer == nil {
		m.installer = &InstallerState{
			Selected: make(map[string]bool),
		}
	}

	var b strings.Builder

	// Search bar
	b.WriteString(components.RenderSearchInput(m.installer.Query, width))
	b.WriteString("\n\n")

	// Module pills (horizontal scroll)
	mods := []components.PillItem{
		{Label: "All", ID: "all"},
		{Label: "lang", ID: "lang"},
		{Label: "ai", ID: "ai"},
		{Label: "db", ID: "db"},
		{Label: "editor", ID: "editor"},
		{Label: "dev", ID: "dev"},
		{Label: "npm", ID: "npm"},
		{Label: "shell", ID: "shell"},
		{Label: "ui", ID: "ui"},
		{Label: "auto", ID: "auto"},
	}
	b.WriteString(components.RenderPills(mods, m.installer.SelectedMod))
	b.WriteString("\n\n")

	// Tool list as cards
	selCount := selectedCount(m.installer.Selected)
	b.WriteString(MutedStyle.Render(fmt.Sprintf("%d tools selected", selCount)))
	b.WriteString("\n")
	for _, tool := range m.installer.Tools {
		status := components.StatusMissing
		if tool.Installed {
			status = components.StatusActive
		}
		meta := tool.Version
		if meta == "" {
			meta = "not installed"
		}
		card := components.RenderCard(components.CardData{
			Icon:       "☐",
			Title:      tool.Name,
			Subtitle:   tool.Description,
			Metadata:   meta,
			Badge:      status,
			BadgeLabel: string(status),
		}, width-2)
		b.WriteString(card)
		b.WriteString("\n")
	}

	// Install progress
	if m.installer.Installing {
		b.WriteString("\n")
		b.WriteString(components.RenderProgressBar(m.installer.Progress.Percentage, "Installing "+m.installer.Progress.Tool, width))
		b.WriteString("\n")
		for _, line := range m.installer.LogLines {
			b.WriteString(MutedStyle.Render(line) + "\n")
		}
	}

	return b.String()
}

func selectedCount(m map[string]bool) int {
	n := 0
	for _, v := range m {
		if v {
			n++
		}
	}
	return n
}
