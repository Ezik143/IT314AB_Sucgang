String _two(int value) => value.toString().padLeft(2, '0');

DateTime? _toDateTime(Object? value) {
  if (value == null) return null;
  if (value is DateTime) return value;
  return DateTime.tryParse(value.toString());
}

/// `YYYY-MM-DD` for date-only columns.
String formatDate(Object? value) {
  final date = _toDateTime(value);
  if (date == null) return value?.toString() ?? '';
  return '${date.year}-${_two(date.month)}-${_two(date.day)}';
}

/// `YYYY-MM-DD HH:mm:ss`, the format PostgreSQL accepts back.
String formatTimestamp(Object? value) {
  final date = _toDateTime(value);
  if (date == null) return value?.toString() ?? '';
  return '${formatDate(date)} '
      '${_two(date.hour)}:${_two(date.minute)}:${_two(date.second)}';
}

/// `HH:mm` for `time` columns, whichever representation the driver returns.
String formatClock(Object? value) {
  if (value == null) return '';
  final text = value.toString();
  final match = RegExp(r'(\d{1,2}):(\d{2})').firstMatch(text);
  if (match == null) return text;
  return '${match.group(1)!.padLeft(2, '0')}:${match.group(2)}';
}
