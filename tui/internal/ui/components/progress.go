package components

import (
	"fmt"
	"strings"
)

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
	return mutedStyle.Render(label) + "\n" + accentStyle.Render(bar) + " " + successStyle.Render(pctStr)
}

func RenderSpinner(label string, frame int) string {
	spinners := []string{"\u23f5", "\u23f4", "\u25b2", "\u25bc"}
	s := spinners[frame%len(spinners)]
	return accentStyle.Render(s + " " + label)
}