"""garudadidada — tiny zero-dependency helpers to humanize values.

Functions:
    format_bytes(num_bytes)              -> e.g. "1.5 KB"
    format_duration(seconds)             -> e.g. "1h 1m 1s"
    ordinal(n)                           -> e.g. "21st"
    pluralize(count, singular, plural?)  -> e.g. "3 files"
"""

__version__ = "1.0.0"

__all__ = ["format_bytes", "format_duration", "ordinal", "pluralize"]

_BYTE_UNITS = ("KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB")


def _trim(n: float) -> str:
    return f"{n:.1f}".rstrip("0").rstrip(".")


def format_bytes(num_bytes: int) -> str:
    """Format a byte count as a human-readable string using binary (1024) units.

    >>> format_bytes(0)
    '0 B'
    >>> format_bytes(1024)
    '1 KB'
    >>> format_bytes(1536)
    '1.5 KB'
    """
    n = float(num_bytes)
    if n < 1024:
        return f"{int(num_bytes)} B"
    last = len(_BYTE_UNITS) - 1
    for i, unit in enumerate(_BYTE_UNITS):
        n /= 1024.0
        if n < 1024 or i == last:
            return f"{_trim(n)} {unit}"
    return f"{_trim(n)} YB"  # pragma: no cover


def format_duration(seconds: int) -> str:
    """Format a duration in seconds as a human-readable string.

    >>> format_duration(0)
    '0s'
    >>> format_duration(90)
    '1m 30s'
    >>> format_duration(90061)
    '1d 1h 1m 1s'
    """
    s = int(seconds)
    if s == 0:
        return "0s"
    parts = []
    days, s = divmod(s, 86400)
    hours, s = divmod(s, 3600)
    minutes, s = divmod(s, 60)
    if days:
        parts.append(f"{days}d")
    if hours:
        parts.append(f"{hours}h")
    if minutes:
        parts.append(f"{minutes}m")
    if s:
        parts.append(f"{s}s")
    return " ".join(parts)


def ordinal(n: int) -> str:
    """Return n with its English ordinal suffix.

    >>> ordinal(1)
    '1st'
    >>> ordinal(12)
    '12th'
    >>> ordinal(21)
    '21st'
    """
    n = int(n)
    if 11 <= (n % 100) <= 13:
        suffix = "th"
    else:
        suffix = {1: "st", 2: "nd", 3: "rd"}.get(n % 10, "th")
    return f"{n}{suffix}"


def pluralize(count: int, singular: str, plural: str = None) -> str:
    """Return "<count> <singular|plural>" choosing the form based on count.

    >>> pluralize(1, "file")
    '1 file'
    >>> pluralize(3, "file")
    '3 files'
    >>> pluralize(2, "person", "people")
    '2 people'
    """
    if plural is None:
        plural = singular + "s"
    word = singular if count == 1 else plural
    return f"{count} {word}"
