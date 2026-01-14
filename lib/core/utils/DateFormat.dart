import 'package:intl/intl.dart';

class DateTimeFormatter {
  /// 1990-01-01 -> Friday, January 24, 2026
  static String formatFullDate(String? rawDate) {
    if (rawDate == null || rawDate.isEmpty) return '-';
    try {
      final date = DateTime.parse(rawDate);
      return DateFormat('EEEE, MMMM d, yyyy').format(date);
    } catch (_) {
      return rawDate;
    }
  }

  /// 06:00:00 -> 10:00
  static String formatTime(String? rawTime) {
    if (rawTime == null || rawTime.isEmpty) return '-';
    try {
      final date = DateFormat('HH:mm:ss').parse(rawTime);
      return DateFormat('HH:mm').format(date);
    } catch (_) {
      return rawTime;
    }
  }

  /// combine date + time
  static String formatDateTimeRange({
    required String? date,
    required String? start,
    required String? end,
  }) {
    final dateFormatted = formatFullDate(date);
    final startFormatted = formatTime(start);
    final endFormatted = formatTime(end);

    return '$dateFormatted • $startFormatted - $endFormatted';
  }
}
