package models

// Database represents a PostgreSQL database.
type Database struct {
	Name       string `json:"name"`
	Size       string `json:"size"`
	TableCount int    `json:"table_count"`
	Running    bool   `json:"running"`
}
