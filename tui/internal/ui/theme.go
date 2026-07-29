// Package ui provides Bubble Tea components and screens for the jinx TUI.
package ui

import "github.com/charmbracelet/lipgloss"

// Catppuccin Mocha palette — foreground colors only for Termux compatibility
const (
	Accent     = "#89b4fa"
	Green      = "#a6e3a1"
	Yellow     = "#f9e2af"
	Red        = "#f38ba8"
	TextMuted  = "#6c7086"
	TextPrimary = "#cdd6f4"
)

var (
	AccentStyle = lipgloss.NewStyle().Foreground(lipgloss.Color(Accent))
	MutedStyle  = lipgloss.NewStyle().Foreground(lipgloss.Color(TextMuted))
	SuccessStyle = lipgloss.NewStyle().Foreground(lipgloss.Color(Green))
	WarningStyle = lipgloss.NewStyle().Foreground(lipgloss.Color(Yellow))
	ErrorStyle  = lipgloss.NewStyle().Foreground(lipgloss.Color(Red))
	TabStyle = lipgloss.NewStyle().Padding(0, 1)
	ActiveTabStyle = lipgloss.NewStyle().Foreground(lipgloss.Color(Accent)).Padding(0, 1)
	StatusBarStyle = lipgloss.NewStyle().Foreground(lipgloss.Color(TextMuted))
	CardStyle = lipgloss.NewStyle().Padding(0, 1)
	HeaderStyle = lipgloss.NewStyle().Foreground(lipgloss.Color(Accent)).Padding(0, 1).Bold(true)
)