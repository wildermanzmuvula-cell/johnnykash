using System;
using System.Globalization;
using System.Text;

namespace Garudadidada
{
    /// <summary>
    /// Tiny zero-dependency helpers to humanize values:
    /// byte sizes, durations, English ordinals, and pluralization.
    /// </summary>
    public static class Humanize
    {
        private static readonly string[] ByteUnits = { "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB" };

        /// <summary>Format a byte count as a human-readable string using binary (1024) units.</summary>
        public static string FormatBytes(long bytes)
        {
            double n = bytes;
            if (n < 1024)
            {
                return bytes + " B";
            }
            for (int i = 0; i < ByteUnits.Length; i++)
            {
                n /= 1024.0;
                if (n < 1024 || i == ByteUnits.Length - 1)
                {
                    return Trim(n) + " " + ByteUnits[i];
                }
            }
            return Trim(n) + " YB";
        }

        /// <summary>Format a duration in seconds as a human-readable string.</summary>
        public static string FormatDuration(long seconds)
        {
            if (seconds == 0)
            {
                return "0s";
            }
            var sb = new StringBuilder();
            long days = seconds / 86400;
            seconds %= 86400;
            long hours = seconds / 3600;
            seconds %= 3600;
            long minutes = seconds / 60;
            seconds %= 60;
            if (days > 0) Append(sb, days, "d");
            if (hours > 0) Append(sb, hours, "h");
            if (minutes > 0) Append(sb, minutes, "m");
            if (seconds > 0) Append(sb, seconds, "s");
            return sb.ToString();
        }

        /// <summary>Return n with its English ordinal suffix (1st, 2nd, 3rd, ...).</summary>
        public static string Ordinal(int n)
        {
            string suffix = "th";
            int m = n % 100;
            if (m < 11 || m > 13)
            {
                switch (n % 10)
                {
                    case 1: suffix = "st"; break;
                    case 2: suffix = "nd"; break;
                    case 3: suffix = "rd"; break;
                }
            }
            return n + suffix;
        }

        /// <summary>Return "count singular|plural" choosing the form based on count.</summary>
        public static string Pluralize(int count, string singular, string plural = null)
        {
            plural = plural ?? singular + "s";
            string word = count == 1 ? singular : plural;
            return count + " " + word;
        }

        private static void Append(StringBuilder sb, long value, string unit)
        {
            if (sb.Length > 0) sb.Append(' ');
            sb.Append(value).Append(unit);
        }

        private static string Trim(double n)
        {
            string s = n.ToString("F1", CultureInfo.InvariantCulture);
            if (s.EndsWith(".0", StringComparison.Ordinal))
            {
                s = s.Substring(0, s.Length - 2);
            }
            return s;
        }
    }
}
