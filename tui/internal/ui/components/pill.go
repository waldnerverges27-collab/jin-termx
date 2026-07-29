package components

import "strings"

type PillItem struct {
	Label string
	ID    string
}

func RenderPills(items []PillItem, activeID string) string {
	var b strings.Builder
	for _, p := range items {
		if p.ID == activeID {
			b.WriteString(accentStyle.Render(" " + p.Label + " "))
		} else {
			b.WriteString(mutedStyle.Render(" " + p.Label + " "))
		}
		b.WriteString(" ")
	}
	return strings.TrimRight(b.String(), " ")
}