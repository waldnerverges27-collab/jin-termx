package components

import "strings"

type KeyHint struct {
	Key  string
	Desc string
}

func RenderStatusBar(hints []KeyHint) string {
	var b strings.Builder
	for i, h := range hints {
		if i > 0 {
			b.WriteString(mutedStyle.Render("  "))
		}
		b.WriteString(accentStyle.Render(h.Key))
		b.WriteString(mutedStyle.Render(" " + h.Desc))
	}
	return statusBarStyle.Render(b.String())
}