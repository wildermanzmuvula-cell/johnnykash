/// Tiny zero-dependency helpers to humanize values:
/// byte sizes, durations, English ordinals, and pluralization.
library garudadidada;

const List<String> _byteUnits = [
  'KB',
  'MB',
  'GB',
  'TB',
  'PB',
  'EB',
  'ZB',
  'YB'
];

String _trim(double n) {
  var s = n.toStringAsFixed(1);
  if (s.endsWith('.0')) {
    s = s.substring(0, s.length - 2);
  }
  return s;
}

/// Format a byte count as a human-readable string using binary (1024) units.
///
/// ```dart
/// formatBytes(1536); // '1.5 KB'
/// ```
String formatBytes(int bytes) {
  var n = bytes.toDouble();
  if (n < 1024) {
    return '$bytes B';
  }
  for (var i = 0; i < _byteUnits.length; i++) {
    n /= 1024.0;
    if (n < 1024 || i == _byteUnits.length - 1) {
      return '${_trim(n)} ${_byteUnits[i]}';
    }
  }
  return '${_trim(n)} YB';
}

/// Format a duration in seconds as a human-readable string.
///
/// ```dart
/// formatDuration(3661); // '1h 1m 1s'
/// ```
String formatDuration(int seconds) {
  if (seconds == 0) {
    return '0s';
  }
  final parts = <String>[];
  final days = seconds ~/ 86400;
  seconds %= 86400;
  final hours = seconds ~/ 3600;
  seconds %= 3600;
  final minutes = seconds ~/ 60;
  seconds %= 60;
  if (days > 0) parts.add('${days}d');
  if (hours > 0) parts.add('${hours}h');
  if (minutes > 0) parts.add('${minutes}m');
  if (seconds > 0) parts.add('${seconds}s');
  return parts.join(' ');
}

/// Return [n] with its English ordinal suffix.
///
/// ```dart
/// ordinal(21); // '21st'
/// ```
String ordinal(int n) {
  var suffix = 'th';
  final m = n % 100;
  if (m < 11 || m > 13) {
    switch (n % 10) {
      case 1:
        suffix = 'st';
        break;
      case 2:
        suffix = 'nd';
        break;
      case 3:
        suffix = 'rd';
        break;
    }
  }
  return '$n$suffix';
}

/// Return `"<count> <singular|plural>"`, choosing the form based on [count].
///
/// ```dart
/// pluralize(3, 'file'); // '3 files'
/// ```
String pluralize(int count, String singular, [String? plural]) {
  plural ??= '${singular}s';
  final word = count == 1 ? singular : plural;
  return '$count $word';
}
