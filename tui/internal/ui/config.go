package ui

import (
	"fmt"
	"strings"
)

// ConfigState tracks the settings screen.
type ConfigState struct {
	DebugMode bool
}

func renderConfig(m *Model, width int) string {
	if m.config == nil {
		m.config = &ConfigState{}
	}

	var b strings.Builder

	settings := []struct {
		name    string
		value   string
		enabled bool
	}{
		{"Debug mode", fmt.Sprintf("%v", m.config.DebugMode), m.config.DebugMode},
		{"Version", "4.16.0", true},
		{"Cache dir", "~/.cache/jin-termx", true},
	}

	for _, s := range settings {
		icon := "○"
		if s.enabled {
			icon = "●"
		}
		line := fmt.Sprintf("%s  %s", AccentStyle.Render(icon), s.name)
		line += strings.Repeat(" ", width-len(s.name)-len(s.value)-6)
		line += MutedStyle.Render(s.value)

		b.WriteString(CardStyle.Width(width - 2).Render(line))
		b.WriteString("\n")
	}

	return b.String()
}
