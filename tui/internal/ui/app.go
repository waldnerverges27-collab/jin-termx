// Package ui provides Bubble Tea components and screens for the jinx TUI.
package ui

import (
	"context"
	"strings"

	tea "github.com/charmbracelet/bubbletea"
	"github.com/charmbracelet/bubbles/viewport"
	"github.com/waldnerverges27-collab/jin-termx/tui/internal/bash"
	"github.com/waldnerverges27-collab/jin-termx/tui/internal/models"
	"github.com/waldnerverges27-collab/jin-termx/tui/internal/ui/components"
)

// Model is the root Bubble Tea model.
type Model struct {
	state    models.AppState
	bridge   *bash.Bridge
	ctx      context.Context
	cancel   context.CancelFunc
	viewport viewport.Model

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
	vp := viewport.New(80, 20)
	vp.KeyMap.Up.SetEnabled(true)
	vp.KeyMap.Down.SetEnabled(true)

	m := &Model{
		state: models.AppState{
			ActiveTab: models.TabDashboard,
			Width:     80,
			Height:    24,
		},
		ctx:      ctx,
		cancel:   cancel,
		viewport: vp,
	}
	// Bridge is optional — TUI works in demo mode if jinx not found
	if b, err := bash.NewBridge(); err == nil {
		m.bridge = b
	}
	m.updateViewportContent()
	return m
}

func (m *Model) Init() tea.Cmd {
	return nil
}

func (m *Model) updateViewportContent() {
	w := m.state.Width
	if w < 40 {
		w = 40
	}
	contentWidth := w - 2
	if contentWidth < 10 {
		contentWidth = 10
	}

	var content strings.Builder
	tabs := []models.Tab{
		models.TabDashboard, models.TabModules, models.TabBrain,
		models.TabPG, models.TabDoctor, models.TabConfig,
	}

	content.WriteString(components.RenderTabBar(tabs, m.state.ActiveTab))
	content.WriteString("\n\n")

	func() {
		defer func() { recover() }()
		switch m.state.ActiveTab {
		case models.TabDashboard:
			content.WriteString(renderDashboard(m, contentWidth))
		case models.TabModules:
			content.WriteString(renderInstaller(m, contentWidth))
		case models.TabBrain:
			content.WriteString(renderBrain(m, contentWidth))
		case models.TabPG:
			content.WriteString(renderPG(m, contentWidth))
		case models.TabDoctor:
			content.WriteString(renderDoctor(m, contentWidth))
		case models.TabConfig:
			content.WriteString(renderConfig(m, contentWidth))
		}
	}()

	content.WriteString("\n\n")
	hints := []components.KeyHint{
		{Key: "1-6", Desc: "tab"},
		{Key: "↑↓", Desc: "scroll"},
		{Key: "/", Desc: "search"},
		{Key: "q", Desc: "quit"},
	}
	content.WriteString(components.RenderStatusBar(hints))

	m.viewport.SetContent(content.String())
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
		m.viewport.Width = m.state.Width
		m.viewport.Height = m.state.Height - 1 // reserve 1 line for prompt
		m.updateViewportContent()
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
				m.updateViewportContent()
			case "2":
				m.state.ActiveTab = models.TabModules
				m.updateViewportContent()
			case "3":
				m.state.ActiveTab = models.TabBrain
				m.updateViewportContent()
			case "4":
				m.state.ActiveTab = models.TabPG
				m.updateViewportContent()
			case "5":
				m.state.ActiveTab = models.TabDoctor
				m.updateViewportContent()
			case "6":
				m.state.ActiveTab = models.TabConfig
				m.updateViewportContent()
			case "?":
				m.state.ShowHelp = !m.state.ShowHelp
				m.updateViewportContent()
			}
			return m, nil
		case tea.KeyTab:
			next := (int(m.state.ActiveTab) + 1) % 6
			m.state.ActiveTab = models.Tab(next)
			m.updateViewportContent()
			return m, nil
		case tea.KeyCtrlC:
			m.cancel()
			return m, tea.Quit
		default:
			// Pass up/down keys to viewport for scrolling
			var cmd tea.Cmd
			m.viewport, cmd = m.viewport.Update(msg)
			return m, cmd
		}
	}

	return m, nil
}

func (m *Model) View() string {
	return m.viewport.View()
}