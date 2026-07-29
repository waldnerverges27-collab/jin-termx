package ui

import (
	"fmt"
	"strings"

	"github.com/waldnerverges27-collab/jin-termx/tui/internal/models"
	"github.com/waldnerverges27-collab/jin-termx/tui/internal/ui/components"
)

// PGState tracks the PostgreSQL manager screen.
type PGState struct {
	Databases []models.Database
	Running   bool
	Uptime    string
	Query     string
}

func renderPG(m *Model, width int) string {
	if m.pg == nil {
		m.pg = &PGState{}
	}

	var b strings.Builder

	// Server controls
	statusText := "stopped"
	if m.pg.Running {
		statusText = "running"
	}
	b.WriteString(AccentStyle.Render(fmt.Sprintf("● %s  ·  uptime: %s", statusText, m.pg.Uptime)))
	b.WriteString("\n")

	controls := []string{
		SuccessStyle.Render("[ ▶ Start ]"),
		MutedStyle.Render("[ ■ Stop ]"),
		MutedStyle.Render("[ ↻ Restart ]"),
	}
	b.WriteString(strings.Join(controls, "  "))
	b.WriteString("\n\n")

	// Database list
	b.WriteString(MutedStyle.Render("DATABASES"))
	b.WriteString("\n")
	for _, db := range m.pg.Databases {
		badge := components.StatusOK
		badgeLabel := "ok"
		if !db.Running {
			badge = components.StatusWarning
			badgeLabel = "warning"
		}
		card := components.RenderCard(components.CardData{
			Title:      db.Name,
			Subtitle:   fmt.Sprintf("%s  ·  %d tables", db.Size, db.TableCount),
			Badge:      badge,
			BadgeLabel: badgeLabel,
		}, width-2)
		b.WriteString(card)
		b.WriteString("\n")
	}

	// Quick query
	b.WriteString("\n")
	b.WriteString(MutedStyle.Render("QUICK QUERY"))
	b.WriteString("\n")
	b.WriteString(CardStyle.Width(width - 2).Render(fmt.Sprintf(
		"⏵ SELECT\n  * FROM table_name\n  WHERE condition;\n\n%s",
		AccentStyle.Render("[ ▶ Run ]"),
	)))

	return b.String()
}