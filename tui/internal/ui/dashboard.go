package ui

import (
	"fmt"
	"strings"

	"github.com/charmbracelet/lipgloss"
	"github.com/waldnerverges27-collab/jin-termx/tui/internal/ui/components"
)

// renderDashboard renders the home tab content.
func renderDashboard(m *Model, width int) string {
	var b strings.Builder

	// Quick status row
	stats := renderQuickStats(width)
	b.WriteString(stats)
	b.WriteString("\n\n")

	// Quick Actions grid (3 columns)
	b.WriteString(MutedStyle.Render("QUICK ACTIONS"))
	b.WriteString("\n")
	b.WriteString(renderQuickActions(width))
	b.WriteString("\n\n")

	// Module status cards
	b.WriteString(MutedStyle.Render("MODULES"))
	b.WriteString("\n")
	b.WriteString(renderModuleCards(m, width))
	b.WriteString("\n\n")

	// Recent activity
	b.WriteString(MutedStyle.Render("RECENT"))
	b.WriteString("\n")
	b.WriteString(renderRecentActivity(m, width))

	return b.String()
}

func renderQuickStats(width int) string {
	colWidth := (width - 4) / 3
	cpu := fmt.Sprintf("CPU\n%d%%", 23) // placeholder
	ram := fmt.Sprintf("RAM\n%d%%", 42)
	mod := fmt.Sprintf("Modules\n%d/%d", 6, 9)

	return strings.Join([]string{
		CardStyle.Width(colWidth).Align(lipgloss.Center).Render(cpu),
		CardStyle.Width(colWidth).Align(lipgloss.Center).Render(ram),
		CardStyle.Width(colWidth).Align(lipgloss.Center).Render(mod),
	}, "  ")
}

func renderQuickActions(width int) string {
	actions := []struct {
		icon  string
		label string
	}{
		{"⬇", "Install"}, {"🧠", "Brain"}, {"🔧", "Doctor"},
		{"🛢️", "PG"}, {"🎤", "Voice"}, {"⚙️", "Init"},
	}
	colWidth := (width - 8) / 3
	var cells []string
	for _, a := range actions {
		content := a.icon + "\n" + MutedStyle.Render(a.label)
		cells = append(cells, CardStyle.Width(colWidth).Align(lipgloss.Center).Render(content))
	}
	// 3 per row
	var rows []string
	for i := 0; i < len(cells); i += 3 {
		end := i + 3
		if end > len(cells) {
			end = len(cells)
		}
		rows = append(rows, strings.Join(cells[i:end], "  "))
	}
	return strings.Join(rows, "\n")
}

func renderModuleCards(m *Model, width int) string {
	if len(m.dashboard.Modules) == 0 {
		return "  " + MutedStyle.Render("No modules installed yet")
	}
	var b strings.Builder
	for _, mod := range m.dashboard.Modules {
		badge := components.StatusActive
		if mod.Installed < mod.ToolCount {
			badge = components.StatusPartial
		}
		card := components.RenderCard(components.CardData{
			Icon:       "📦",
			Title:      mod.Name,
			Subtitle:   mod.Description,
			Metadata:   fmt.Sprintf("%d/%d tools installed", mod.Installed, mod.ToolCount),
			Badge:      badge,
			BadgeLabel: string(badge),
		}, width-2)
		b.WriteString(card)
		b.WriteString("\n")
	}
	return b.String()
}

func renderRecentActivity(m *Model, width int) string {
	if len(m.dashboard.Recent) == 0 {
		return "  " + MutedStyle.Render("No recent activity")
	}
	var b strings.Builder
	for _, item := range m.dashboard.Recent {
		b.WriteString(CardStyle.Width(width-2).Render("  " + item))
		b.WriteString("\n")
	}
	return b.String()
}
