import 'package:intl/intl.dart';

class FormatUtils {
  static String formatAmountWithSpaces(String amount) {
    final numberFormat = NumberFormat('#,###', 'fr_FR');
    final numericValue = int.tryParse(amount) ?? 0;
    return numberFormat.format(numericValue);
  }

  static String formatAmount(String amount) {
    final numberFormat = NumberFormat('#,###', 'fr_FR');
    final numericValue = int.tryParse(amount) ?? 0;
    return numberFormat.format(numericValue);
  }

  static String formatDate(String date) {
    if (date.isEmpty) return '';
    final parts = date.split(' ');
    return parts.isNotEmpty ? parts[0] : date;
  }
}
