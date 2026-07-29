package ui

import (
	"fmt"
	"strings"

	"github.com/waldnerverges27-collab/jin-termx/tui/internal/ui/components"
)

// DoctorState tracks the diagnostic screen.
type DoctorState struct {
	Checks []DoctorCheck
	Fixing bool
}

// DoctorCheck represents one health check result.
type DoctorCheck struct {
	Name   string
	Badge  components.StatusBadge
	Detail string
}

func renderDoctor(m *Model, width int) string {
	if m.doctor == nil {
		m.doctor = &DoctorState{}
	}

	var b strings.Builder

	// Summary bar: X passed, Y warnings, Z errors
	ok, warn, err := countChecks(m.doctor.Checks)
	summary := fmt.Sprintf("%s passed  %s warnings  %s errors",
		SuccessStyle.Render(fmt.Sprintf("%d", ok)),
		WarningStyle.Render(fmt.Sprintf("%d", warn)),
		ErrorStyle.Render(fmt.Sprintf("%d", err)),
	)
	b.WriteString(summary)
	b.WriteString("\n\n")

	// Check list
	b.WriteString(MutedStyle.Render("SYSTEM CHECKS"))
	b.WriteString("\n")
	for _, c := range m.doctor.Checks {
		b.WriteString(fmt.Sprintf("%s  %s", statusDot(c.Badge), AccentStyle.Render(c.Name)))
		if c.Detail != "" {
			b.WriteString(fmt.Sprintf("\n  %s", MutedStyle.Render(c.Detail)))
		}
		b.WriteString("\n")
	}

	// Auto-fix action button
	b.WriteString("\n")
	b.WriteString(SuccessStyle.Render("[ 🔧 Auto-fix ]"))

	return b.String()
}

func statusDot(s components.StatusBadge) string {
	switch s {
	case components.StatusOK, components.StatusActive:
		return SuccessStyle.Render("●")
	case components.StatusWarning, components.StatusPartial:
		return WarningStyle.Render("●")
	case components.StatusError, components.StatusMissing:
		return ErrorStyle.Render("○")
	default:
		return MutedStyle.Render("○")
	}
}

func countChecks(checks []DoctorCheck) (ok, warn, err int) {
	for _, c := range checks {
		switch c.Badge {
		case components.StatusOK, components.StatusActive:
			ok++
		case components.StatusWarning, components.StatusPartial:
			warn++
		case components.StatusError, components.StatusMissing:
			err++
		}
	}
	return
}
