package components

import (
	"strings"
)

type KeyHint struct {
	Key  string
	Desc string
}

func RenderStatusBar(hints []KeyHint) string {
	var b strings.Builder
	for i, h := range hints {
		if i > 0 {
			b.WriteString(mutedStyleLocal.Render("  "))
		}
		b.WriteString(accentStyleLocal.Render(h.Key))
		b.WriteString(mutedStyleLocal.Render(" " + h.Desc))
	}
	return statusBarStyleLocal.Render(b.String())
}
