package components

import (
	"fmt"
	"strings"

	"github.com/waldnerverges27-collab/jin-termx/tui/internal/ui"
)

// RenderProgressBar renders an animated progress bar.
func RenderProgressBar(pct float64, label string, width int) string {
	if width < 10 {
		width = 10
	}
	barWidth := width - 12
	if barWidth < 1 {
		barWidth = 1
	}
	filled := int(float64(barWidth) * pct / 100.0)
	if filled < 0 {
		filled = 0
	}
	if filled > barWidth {
		filled = barWidth
	}
	bar := strings.Repeat("\u2588", filled) + strings.Repeat("\u2591", barWidth-filled)
	pctStr := fmt.Sprintf("%3.0f%%", pct)

	result := ui.MutedStyle.Render(label) + "\n"
	result += ui.AccentStyle.Render(bar) + " " + ui.SuccessStyle.Render(pctStr)
	return result
}

// RenderSpinner renders an indeterminate progress indicator.
func RenderSpinner(label string, frame int) string {
	spinners := []string{"\u23f5", "\u23f4", "\u25b2", "\u25bc"}
	s := spinners[frame%len(spinners)]
	return ui.AccentStyle.Render(s + " " + label)
}
