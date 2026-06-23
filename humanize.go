// Package humanize provides tiny zero-dependency helpers to humanize values:
// byte sizes, durations, English ordinals, and pluralization.
package humanize

import (
	"strconv"
	"strings"
)

var byteUnits = []string{"KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"}

func trim(n float64) string {
	s := strconv.FormatFloat(n, 'f', 1, 64)
	return strings.TrimSuffix(s, ".0")
}

// FormatBytes formats a byte count as a human-readable string using binary
// (1024) units, e.g. FormatBytes(1536) == "1.5 KB".
func FormatBytes(bytes int64) string {
	n := float64(bytes)
	if n < 1024 {
		return strconv.FormatInt(bytes, 10) + " B"
	}
	last := len(byteUnits) - 1
	for i, unit := range byteUnits {
		n /= 1024
		if n < 1024 || i == last {
			return trim(n) + " " + unit
		}
	}
	return trim(n) + " YB"
}

// FormatDuration formats a duration in seconds as a human-readable string,
// e.g. FormatDuration(3661) == "1h 1m 1s".
func FormatDuration(seconds int64) string {
	if seconds == 0 {
		return "0s"
	}
	var parts []string
	days := seconds / 86400
	seconds %= 86400
	hours := seconds / 3600
	seconds %= 3600
	minutes := seconds / 60
	seconds %= 60
	if days > 0 {
		parts = append(parts, strconv.FormatInt(days, 10)+"d")
	}
	if hours > 0 {
		parts = append(parts, strconv.FormatInt(hours, 10)+"h")
	}
	if minutes > 0 {
		parts = append(parts, strconv.FormatInt(minutes, 10)+"m")
	}
	if seconds > 0 {
		parts = append(parts, strconv.FormatInt(seconds, 10)+"s")
	}
	return strings.Join(parts, " ")
}

// Ordinal returns n with its English ordinal suffix, e.g. Ordinal(21) == "21st".
func Ordinal(n int) string {
	suffix := "th"
	if m := n % 100; m < 11 || m > 13 {
		switch n % 10 {
		case 1:
			suffix = "st"
		case 2:
			suffix = "nd"
		case 3:
			suffix = "rd"
		}
	}
	return strconv.Itoa(n) + suffix
}

// Pluralize returns "<count> <singular|plural>", choosing the form based on
// count, e.g. Pluralize(3, "file", "files") == "3 files".
func Pluralize(count int, singular, plural string) string {
	word := plural
	if count == 1 {
		word = singular
	}
	return strconv.Itoa(count) + " " + word
}
