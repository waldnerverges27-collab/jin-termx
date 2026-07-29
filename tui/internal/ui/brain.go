package ui

import (
	"strings"

	"github.com/waldnerverges27-collab/jin-termx/tui/internal/models"
	"github.com/waldnerverges27-collab/jin-termx/tui/internal/ui/components"
)

// BrainState tracks the brain explorer screen.
type BrainState struct {
	Memories []models.Memory
	Query    string
	Category string
}

func renderBrain(m *Model, width int) string {
	if m.brain == nil {
		m.brain = &BrainState{Category: "all"}
	}

	var b strings.Builder

	// Search bar
	b.WriteString(components.RenderSearchInput(m.brain.Query, width))
	b.WriteString("\n")

	// Category pills
	categories := []components.PillItem{
		{Label: "All", ID: "all"},
		{Label: "frontend", ID: "frontend"},
		{Label: "devops", ID: "devops"},
		{Label: "linux", ID: "linux"},
		{Label: "go", ID: "go"},
		{Label: "database", ID: "database"},
	}
	b.WriteString(components.RenderPills(categories, m.brain.Category))
	b.WriteString("\n\n")

	// Memory cards
	for _, mem := range m.brain.Memories {
		tags := strings.Join(mem.Tags, " · ")
		star := "☆"
		if mem.Favorite {
			star = "★"
		}

		card := components.RenderCard(components.CardData{
			Icon:     star,
			Title:    mem.Title,
			Subtitle: mem.Date + " · " + mem.Category,
			Metadata: tags,
		}, width-2)
		b.WriteString(card)
		b.WriteString("\n")
	}

	// Empty state
	if len(m.brain.Memories) == 0 {
		b.WriteString(MutedStyle.Render("No memories yet. Press n to create one."))
		b.WriteString("\n")
	}

	// FAB: "+ New Memory" button
	b.WriteString("\n")
	b.WriteString(SuccessStyle.Render("╭──────────────────────╮"))
	b.WriteString("\n")
	b.WriteString(SuccessStyle.Render("│  +  New Memory       │"))
	b.WriteString("\n")
	b.WriteString(SuccessStyle.Render("╰──────────────────────╯"))

	// Actions row
	b.WriteString("\n\n")
	actions := []string{
		MutedStyle.Render("[ ↻ Sync ]"),
		MutedStyle.Render("[ ⊞ Graph ]"),
		MutedStyle.Render("[ ✕ Delete ]"),
	}
	b.WriteString(strings.Join(actions, "  "))

	return b.String()
}
