package models

// Memory represents a brain memory entry.
type Memory struct {
	Title    string   `json:"title"`
	Slug     string   `json:"slug"`
	Category string   `json:"category"`
	Tags     []string `json:"tags"`
	Date     string   `json:"date"`
	Favorite bool     `json:"favorite"`
}
