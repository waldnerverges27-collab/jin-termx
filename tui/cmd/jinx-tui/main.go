// jinx-tui is the mobile-first terminal UI for Jin-TermX on Termux.
//
// It provides a tab-based vertical interface wrapping existing jinx Bash scripts
// via a JSON subprocess bridge. All Bash logic remains untouched.
package main

import (
	"fmt"
	"os"

	tea "github.com/charmbracelet/bubbletea"
	"github.com/waldnerverges27-collab/jin-termx/tui/internal/ui"
)

func main() {
	app := ui.New()
	// Note: intentionally NOT using WithAltScreen to ensure compatibility
	// across all Termux terminal emulators
	p := tea.NewProgram(app)
	if _, err := p.Run(); err != nil {
		fmt.Fprintf(os.Stderr, "jinx-tui: %v\n", err)
		os.Exit(1)
	}
}