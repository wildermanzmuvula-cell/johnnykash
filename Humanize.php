<?php

declare(strict_types=1);

namespace Garudadidada;

/**
 * Tiny zero-dependency helpers to humanize values:
 * byte sizes, durations, English ordinals, and pluralization.
 */
final class Humanize
{
    /** @var string[] */
    private const BYTE_UNITS = ['KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'];

    /**
     * Format a byte count as a human-readable string using binary (1024) units.
     * formatBytes(1536) === "1.5 KB"
     */
    public static function formatBytes(int $bytes): string
    {
        $n = (float) $bytes;
        if ($n < 1024) {
            return $bytes . ' B';
        }
        $last = count(self::BYTE_UNITS) - 1;
        foreach (self::BYTE_UNITS as $i => $unit) {
            $n /= 1024;
            if ($n < 1024 || $i === $last) {
                return self::trim($n) . ' ' . $unit;
            }
        }
        return self::trim($n) . ' YB';
    }

    /**
     * Format a duration in seconds as a human-readable string.
     * formatDuration(3661) === "1h 1m 1s"
     */
    public static function formatDuration(int $seconds): string
    {
        if ($seconds === 0) {
            return '0s';
        }
        $parts = [];
        $days = intdiv($seconds, 86400);
        $seconds %= 86400;
        $hours = intdiv($seconds, 3600);
        $seconds %= 3600;
        $minutes = intdiv($seconds, 60);
        $seconds %= 60;
        if ($days > 0) {
            $parts[] = $days . 'd';
        }
        if ($hours > 0) {
            $parts[] = $hours . 'h';
        }
        if ($minutes > 0) {
            $parts[] = $minutes . 'm';
        }
        if ($seconds > 0) {
            $parts[] = $seconds . 's';
        }
        return implode(' ', $parts);
    }

    /**
     * Return n with its English ordinal suffix.
     * ordinal(21) === "21st"
     */
    public static function ordinal(int $n): string
    {
        $suffix = 'th';
        $m = $n % 100;
        if ($m < 11 || $m > 13) {
            switch ($n % 10) {
                case 1:
                    $suffix = 'st';
                    break;
                case 2:
                    $suffix = 'nd';
                    break;
                case 3:
                    $suffix = 'rd';
                    break;
            }
        }
        return $n . $suffix;
    }

    /**
     * Return "<count> <singular|plural>" choosing the form based on count.
     * pluralize(3, "file") === "3 files"
     */
    public static function pluralize(int $count, string $singular, ?string $plural = null): string
    {
        $plural = $plural ?? $singular . 's';
        $word = $count === 1 ? $singular : $plural;
        return $count . ' ' . $word;
    }

    private static function trim(float $n): string
    {
        $s = number_format($n, 1, '.', '');
        if (substr($s, -2) === '.0') {
            $s = substr($s, 0, -2);
        }
        return $s;
    }
}
