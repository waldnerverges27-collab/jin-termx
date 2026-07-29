package components

import "github.com/charmbracelet/lipgloss"

// Catppuccin Mocha palette (local copy to avoid import cycle with ui package)
const (
	bgDark     = "#0f111a"
	bgSurface  = "#181825"
	bgSurface2 = "#1e1e2e"
	textMuted  = "#6c7086"
	accent     = "#89b4fa"
	green      = "#a6e3a1"
	yellow     = "#f9e2af"
	red        = "#f38ba8"
)

var (
	cardStyleLocal = lipgloss.NewStyle().
			Background(lipgloss.Color(bgSurface)).
			Padding(0, 1).
			Border(lipgloss.NormalBorder()).
			BorderForeground(lipgloss.Color(bgSurface2))

	activeTabStyleLocal = lipgloss.NewStyle().
				Foreground(lipgloss.Color(accent)).
				Border(lipgloss.Border{Bottom: "▁"}, false, false, true, false).
				BorderForeground(lipgloss.Color(accent)).
				Padding(0, 2)

	inactiveTabStyleLocal = lipgloss.NewStyle().
				Foreground(lipgloss.Color(textMuted)).
				Padding(0, 2)

	statusBarStyleLocal = lipgloss.NewStyle().
				Background(lipgloss.Color(bgSurface)).
				Foreground(lipgloss.Color(textMuted)).
				Padding(0, 1)

	mutedStyleLocal  = lipgloss.NewStyle().Foreground(lipgloss.Color(textMuted))
	accentStyleLocal = lipgloss.NewStyle().Foreground(lipgloss.Color(accent))
	successStyleLocal = lipgloss.NewStyle().Foreground(lipgloss.Color(green))
)
