import 'package:intl/intl.dart';

/// Utility class for formatting numbers, prices, etc.
class NumberFormatter {
  ///  commas for thousands: 1000000 -> "1,000,000"
  static String formatWithCommas(num number) {
    final formatter = NumberFormat('#,###');
    return formatter.format(number);
  }

  /// Format as currency (e.g., SAR with 2 decimals).
  /// Example: 1500 -> "1,500.00 SAR"
  static String formatCurrency(num number, {String currency = "SAR"}) {
    final formatter = NumberFormat.currency(
      symbol: "$currency ",
      decimalDigits: 2,
    );
    return formatter.format(number);
  }
}
