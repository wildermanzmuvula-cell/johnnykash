package io.github.garudadidada;

import java.util.Locale;

/**
 * Tiny zero-dependency helpers to humanize values:
 * byte sizes, durations, English ordinals, and pluralization.
 */
public final class Humanize {

    private static final String[] BYTE_UNITS = {"KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"};

    private Humanize() {
    }

    /** Format a byte count as a human-readable string using binary (1024) units. */
    public static String formatBytes(long bytes) {
        double n = (double) bytes;
        if (n < 1024) {
            return bytes + " B";
        }
        for (int i = 0; i < BYTE_UNITS.length; i++) {
            n /= 1024.0;
            if (n < 1024 || i == BYTE_UNITS.length - 1) {
                return trim(n) + " " + BYTE_UNITS[i];
            }
        }
        return trim(n) + " YB";
    }

    /** Format a duration in seconds as a human-readable string. */
    public static String formatDuration(long seconds) {
        if (seconds == 0) {
            return "0s";
        }
        StringBuilder sb = new StringBuilder();
        long days = seconds / 86400;
        seconds %= 86400;
        long hours = seconds / 3600;
        seconds %= 3600;
        long minutes = seconds / 60;
        seconds %= 60;
        if (days > 0) {
            append(sb, days, "d");
        }
        if (hours > 0) {
            append(sb, hours, "h");
        }
        if (minutes > 0) {
            append(sb, minutes, "m");
        }
        if (seconds > 0) {
            append(sb, seconds, "s");
        }
        return sb.toString();
    }

    /** Return n with its English ordinal suffix (1st, 2nd, 3rd, ...). */
    public static String ordinal(int n) {
        String suffix = "th";
        int m = n % 100;
        if (m < 11 || m > 13) {
            switch (n % 10) {
                case 1: suffix = "st"; break;
                case 2: suffix = "nd"; break;
                case 3: suffix = "rd"; break;
                default: break;
            }
        }
        return n + suffix;
    }

    /** Return "&lt;count&gt; &lt;singular|plural&gt;" choosing the form based on count. */
    public static String pluralize(int count, String singular, String plural) {
        String word = (count == 1) ? singular : plural;
        return count + " " + word;
    }

    /** Convenience overload: pluralizes by appending "s". */
    public static String pluralize(int count, String singular) {
        return pluralize(count, singular, singular + "s");
    }

    private static void append(StringBuilder sb, long value, String unit) {
        if (sb.length() > 0) {
            sb.append(' ');
        }
        sb.append(value).append(unit);
    }

    private static String trim(double n) {
        String s = String.format(Locale.ROOT, "%.1f", n);
        if (s.endsWith(".0")) {
            s = s.substring(0, s.length() - 2);
        }
        return s;
    }
}
