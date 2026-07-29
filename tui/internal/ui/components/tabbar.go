package components

import (
	"strings"

	"github.com/waldnerverges27-collab/jin-termx/tui/internal/models"
)

func RenderTabBar(tabs []models.Tab, active models.Tab) string {
	var b strings.Builder
	for _, t := range tabs {
		if t == active {
			b.WriteString(activeTabStyle.Render(t.String()))
		} else {
			b.WriteString(tabStyle.Render(t.String()))
		}
		b.WriteString(" ")
	}
	return strings.TrimRight(b.String(), " ")
}