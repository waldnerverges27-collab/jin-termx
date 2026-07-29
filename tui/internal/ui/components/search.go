package components

import "strings"

func RenderSearchInput(query string, width int) string {
	if width < 6 {
		width = 6
	}
	display := "\U0001f50d Search"
	if query != "" {
		display = "\U0001f50d " + query
	}
	pad := width - len(display) - 2
	if pad < 0 {
		pad = 0
	}
	content := display + strings.Repeat(" ", pad)
	return mutedStyle.Render(content)
}