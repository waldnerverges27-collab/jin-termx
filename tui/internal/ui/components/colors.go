package components

import "github.com/charmbracelet/lipgloss"

// Simplified colors — no backgrounds, just text colors for Termux compatibility
const (
	accent     = "#89b4fa"
	green      = "#a6e3a1"
	yellow     = "#f9e2af"
	red        = "#f38ba8"
	textMuted  = "#6c7086"
)

var (
	cardStyle        = lipgloss.NewStyle().Padding(0, 1)
	tabStyle         = lipgloss.NewStyle().Padding(0, 1)
	activeTabStyle   = lipgloss.NewStyle().Foreground(lipgloss.Color(accent)).Padding(0, 1)
	mutedStyle       = lipgloss.NewStyle().Foreground(lipgloss.Color(textMuted))
	accentStyle      = lipgloss.NewStyle().Foreground(lipgloss.Color(accent))
	successStyle     = lipgloss.NewStyle().Foreground(lipgloss.Color(green))
	warningStyle     = lipgloss.NewStyle().Foreground(lipgloss.Color(yellow))
	errorStyle       = lipgloss.NewStyle().Foreground(lipgloss.Color(red))
	statusBarStyle   = lipgloss.NewStyle().Foreground(lipgloss.Color(textMuted))
)