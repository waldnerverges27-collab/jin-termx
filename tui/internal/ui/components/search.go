package components

import (
	"strings"
)

// RenderSearchInput renders a search bar with magnifying glass icon.
func RenderSearchInput(query string, width int) string {
	if width < 6 {
		width = 6
	}
	headline := "\U0001f50d Search"
	display := headline
	if query != "" {
		display = "\U0001f50d " + query
	}
	pad := width - len(display) - 2
	if pad < 0 {
		pad = 0
	}
	content := display + strings.Repeat(" ", pad)
	return cardStyleLocal.Width(width).Render(content)
}
