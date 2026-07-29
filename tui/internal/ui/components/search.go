package components

import (
	"strings"

	"github.com/waldnerverges27-collab/jin-termx/tui/internal/ui"
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
	return ui.CardStyle.Width(width).Render(content)
}
