package components

import (
	"strings"

	"github.com/charmbracelet/lipgloss"
)

type PillItem struct {
	Label string
	ID    string
}

func RenderPills(items []PillItem, activeID string) string {
	var b strings.Builder
	for _, p := range items {
		if p.ID == activeID {
			b.WriteString(activeTabStyleLocal.Copy().Background(lipgloss.Color(accent)).Foreground(lipgloss.Color(bgDark)).Padding(0, 2).Render(p.Label))
		} else {
			b.WriteString(inactiveTabStyleLocal.Copy().Background(lipgloss.Color(bgSurface2)).Padding(0, 2).Render(p.Label))
		}
		b.WriteString(" ")
	}
	return strings.TrimRight(b.String(), " ")
}
