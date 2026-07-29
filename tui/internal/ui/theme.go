// Package ui provides Bubble Tea components and screens for the jinx TUI.
package ui

import (
	"github.com/charmbracelet/lipgloss"
)

// Catppuccin Mocha palette
const (
	BgDark      = "#0f111a"
	BgSurface   = "#181825"
	BgSurface2  = "#1e1e2e"
	BgSurface3  = "#11111b"
	TextPrimary = "#cdd6f4"
	TextMuted   = "#6c7086"
	Accent      = "#89b4fa"
	Green       = "#a6e3a1"
	Yellow      = "#f9e2af"
	Red         = "#f38ba8"
	Purple      = "#cba6f7"
	Cyan        = "#89dceb"
	Peach       = "#fab387"
)

var (
	BaseStyle = lipgloss.NewStyle().Background(lipgloss.Color(BgDark)).Foreground(lipgloss.Color(TextPrimary))

	CardStyle = lipgloss.NewStyle().Background(lipgloss.Color(BgSurface)).Padding(0, 1).Border(lipgloss.NormalBorder()).BorderForeground(lipgloss.Color(BgSurface2))

	ActiveTabStyle = lipgloss.NewStyle().Foreground(lipgloss.Color(Accent)).Border(lipgloss.Border{Bottom: "▁"}, false, false, true, false).BorderForeground(lipgloss.Color(Accent)).Padding(0, 2)

	InactiveTabStyle = lipgloss.NewStyle().Foreground(lipgloss.Color(TextMuted)).Padding(0, 2)

	StatusBarStyle = lipgloss.NewStyle().Background(lipgloss.Color(BgSurface)).Foreground(lipgloss.Color(TextMuted)).Padding(0, 1)

	SuccessStyle = lipgloss.NewStyle().Foreground(lipgloss.Color(Green))
	WarningStyle = lipgloss.NewStyle().Foreground(lipgloss.Color(Yellow))
	ErrorStyle   = lipgloss.NewStyle().Foreground(lipgloss.Color(Red))
	AccentStyle  = lipgloss.NewStyle().Foreground(lipgloss.Color(Accent))
	MutedStyle   = lipgloss.NewStyle().Foreground(lipgloss.Color(TextMuted))

	ProgressBarFilled = lipgloss.NewStyle().Background(lipgloss.Color(Accent)).Foreground(lipgloss.Color(BgDark))
	ProgressBarEmpty  = lipgloss.NewStyle().Background(lipgloss.Color(BgSurface2))
)