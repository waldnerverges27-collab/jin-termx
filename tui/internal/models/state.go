// Package models defines data structures for the jinx TUI application state.
package models

// Tab represents a navigation tab.
type Tab int

const (
	TabDashboard Tab = iota
	TabModules
	TabBrain
	TabPG
	TabDoctor
	TabConfig
)

func (t Tab) String() string {
	switch t {
	case TabDashboard:
		return "\u2b21 Home"
	case TabModules:
		return "\U0001f4e6 Modules"
	case TabBrain:
		return "\U0001f9e0 Brain"
	case TabPG:
		return "\U0001f6e2\ufe0f  PG"
	case TabDoctor:
		return "\U0001f527 Doctor"
	case TabConfig:
		return "\u2699\ufe0f Config"
	default:
		return "?"
	}
}

// AppState holds global UI state.
type AppState struct {
	ActiveTab  Tab
	Width      int
	Height     int
	Error      string
	ShowHelp   bool
	IsLoading  bool
	LoadingMsg string
}

// SystemStats holds system resource information.
type SystemStats struct {
	CPUUsage     float64
	RAMUsage     float64
	DiskUsage    float64
	BatteryPct   float64
	Uptime       string
	PackageCount int
}

// DashboardData holds data for the home screen.
type DashboardData struct {
	System  SystemStats
	Modules []Module
	Recent  []string
}