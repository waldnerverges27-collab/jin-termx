// Package ui provides Bubble Tea components and screens for the jinx TUI.
package ui

import (
	"context"
	"strings"

	tea "github.com/charmbracelet/bubbletea"
	"github.com/waldnerverges27-collab/jin-termx/tui/internal/bash"
	"github.com/waldnerverges27-collab/jin-termx/tui/internal/models"
	"github.com/waldnerverges27-collab/jin-termx/tui/internal/ui/components"
)

// Model is the root Bubble Tea model.
type Model struct {
	state   models.AppState
	bridge  *bash.Bridge
	ctx     context.Context
	cancel  context.CancelFunc

	// Screen data (lazy-loaded)
	dashboard models.DashboardData

	// Tab screens (nil until first render)
	installer *InstallerState
	brain     *BrainState
	pg        *PGState
	doctor    *DoctorState
	config    *ConfigState
}

// New creates a new root program model with optional bash bridge.
func New() tea.Model {
	ctx, cancel := context.WithCancel(context.Background())
	m := &Model{
		state: models.AppState{
			ActiveTab: models.TabDashboard,
			Width:     80,
			Height:    24,
		},
		ctx:    ctx,
		cancel: cancel,
	}
	// Bridge is optional — TUI works in demo mode if jinx not found
	if b, err := bash.NewBridge(); err == nil {
		m.bridge = b
	}
	return m
}

func (m *Model) Init() tea.Cmd {
	return nil
}

func (m *Model) Update(msg tea.Msg) (tea.Model, tea.Cmd) {
	switch msg := msg.(type) {
	case tea.WindowSizeMsg:
		m.state.Width = msg.Width
		m.state.Height = msg.Height
		if m.state.Width < 1 {
			m.state.Width = 80
		}
		if m.state.Height < 1 {
			m.state.Height = 24
		}
		return m, nil

	case tea.KeyMsg:
		switch msg.Type {
		case tea.KeyRunes:
			switch string(msg.Runes) {
			case "q":
				m.cancel()
				return m, tea.Quit
			case "1":
				m.state.ActiveTab = models.TabDashboard
			case "2":
				m.state.ActiveTab = models.TabModules
			case "3":
				m.state.ActiveTab = models.TabBrain
			case "4":
				m.state.ActiveTab = models.TabPG
			case "5":
				m.state.ActiveTab = models.TabDoctor
			case "6":
				m.state.ActiveTab = models.TabConfig
			case "?":
				m.state.ShowHelp = !m.state.ShowHelp
			}
			return m, nil
		case tea.KeyTab:
			next := (int(m.state.ActiveTab) + 1) % 6
			m.state.ActiveTab = models.Tab(next)
			return m, nil
		case tea.KeyCtrlC:
			m.cancel()
			return m, tea.Quit
		}
		return m, nil
	}

	return m, nil
}

func (m *Model) View() string {
	// Ensure minimum dimensions for rendering
	w := m.state.Width
	if w < 40 {
		w = 40
	}
	h := m.state.Height
	if h < 10 {
		h = 10
	}

	var b strings.Builder

	// Header bar
	tabs := []models.Tab{
		models.TabDashboard, models.TabModules, models.TabBrain,
		models.TabPG, models.TabDoctor, models.TabConfig,
	}

	// Tab bar
	b.WriteString(components.RenderTabBar(tabs, m.state.ActiveTab))
	b.WriteString("\n")

	// Content area
	// Guard: catch rendering panics silently
	contentWidth := w - 2
	if contentWidth < 10 {
		contentWidth = 10
	}

	func() {
		defer func() { recover() }()
		switch m.state.ActiveTab {
		case models.TabDashboard:
			b.WriteString(renderDashboard(m, contentWidth))
		case models.TabModules:
			b.WriteString(renderInstaller(m, contentWidth))
		case models.TabBrain:
			b.WriteString(renderBrain(m, contentWidth))
		case models.TabPG:
			b.WriteString(renderPG(m, contentWidth))
		case models.TabDoctor:
			b.WriteString(renderDoctor(m, contentWidth))
		case models.TabConfig:
			b.WriteString(renderConfig(m, contentWidth))
		}
	}()

	b.WriteString("\n")

	// Status bar with keyboard hints
	hints := []components.KeyHint{
		{Key: "1-6", Desc: "tab"},
		{Key: "↑↓", Desc: "scroll"},
		{Key: "/", Desc: "search"},
		{Key: "q", Desc: "quit"},
	}
	b.WriteString(components.RenderStatusBar(hints))

	return BaseStyle.Width(w).Render(b.String())
}
