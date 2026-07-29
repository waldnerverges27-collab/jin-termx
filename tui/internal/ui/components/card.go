package components

import (
	"strings"

	"github.com/charmbracelet/lipgloss"
)

type StatusBadge string

const (
	StatusActive  StatusBadge = "active"
	StatusPartial StatusBadge = "partial"
	StatusMissing StatusBadge = "missing"
	StatusOK      StatusBadge = "ok"
	StatusWarning StatusBadge = "warning"
	StatusError   StatusBadge = "error"
)

func badgeColor(s StatusBadge) string {
	switch s {
	case StatusActive, StatusOK:
		return green
	case StatusPartial, StatusWarning:
		return yellow
	case StatusMissing, StatusError:
		return red
	default:
		return textMuted
	}
}

type CardData struct {
	Icon       string
	Title      string
	Subtitle   string
	Metadata   string
	Badge      StatusBadge
	BadgeLabel string
}

func RenderCard(d CardData, width int) string {
	if width < 4 {
		width = 4
	}
	var b strings.Builder

	titleLine := d.Icon + " " + d.Title

	if d.BadgeLabel != "" {
		badgeStr := lipgloss.NewStyle().Foreground(lipgloss.Color(badgeColor(d.Badge))).Render(d.BadgeLabel)
		pad := width - len(titleLine) - len(d.BadgeLabel) - 2
		if pad < 0 {
			pad = 0
		}
		titleLine += strings.Repeat(" ", pad) + badgeStr
	}

	b.WriteString(accentStyle.Render(titleLine))
	if d.Subtitle != "" {
		b.WriteString("\n")
		b.WriteString(mutedStyle.Render("  " + d.Subtitle))
	}
	if d.Metadata != "" {
		b.WriteString("\n")
		b.WriteString(mutedStyle.Render("  " + d.Metadata))
	}

	return cardStyle.Width(width).Render(b.String())
}