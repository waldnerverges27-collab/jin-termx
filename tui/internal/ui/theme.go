// Package ui provides Bubble Tea components and screens for the jinx TUI.
package ui

import (
	"github.com/charmbracelet/bubbletea"
	"github.com/charmbracelet/lipgloss"
	"github.com/waldnerverges27-collab/jin-termx/tui/internal/models"
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

// model is the root Bubble Tea model for the TUI.
type model struct {
	state models.AppState
}

// New creates and returns a new root program model.
func New() tea.Model {
	return &model{
		state: models.AppState{
			ActiveTab: models.TabDashboard,
		},
	}
}

func (m *model) Init() tea.Cmd { return nil }

func (m *model) Update(msg tea.Msg) (tea.Model, tea.Cmd) {
	switch msg := msg.(type) {
	case tea.WindowSizeMsg:
		m.state.Width = msg.Width
		m.state.Height = msg.Height
	case tea.KeyMsg:
		switch msg.String() {
		case "q", "ctrl+c":
			return m, tea.Quit
		}
	}
	return m, nil
}

func (m *model) View() string {
	return BaseStyle.Render("jinx-tui v0.1.0")
}