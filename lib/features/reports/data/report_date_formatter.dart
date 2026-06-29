/// Formats a lab test date for accordion headers (DD-MM-YYYY).
String formatTestDateLabel(DateTime date) {
  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');
  return '$day-$month-${date.year}';
}

DateTime testDateFromDaysAgo(int daysAgo, {DateTime? reference}) {
  final now = reference ?? DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  return today.subtract(Duration(days: daysAgo));
}

String formatTestDateFromDaysAgo(int daysAgo, {DateTime? reference}) =>
    formatTestDateLabel(testDateFromDaysAgo(daysAgo, reference: reference));
