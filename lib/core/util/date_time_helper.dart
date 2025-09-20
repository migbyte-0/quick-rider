import 'package:intl/intl.dart';

class DateTimeHelper {
  static String formatDate(DateTime date) {
    return DateFormat('d MMM yyyy').format(date);
  }

  static String formatTime(DateTime date) {
    return DateFormat('h:mm a').format(date);
  }

  static DateTime parseIso(String isoString) {
    return DateTime.parse(isoString).toLocal();
  }

  static String formatRelative(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return "Today";
    } else if (difference.inDays == 1) {
      return "Yesterday";
    } else {
      return formatDate(date);
    }
  }
}
