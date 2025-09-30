import 'package:intl/intl.dart';

class AppDateUtils {
  static final DateFormat _dateFormat = DateFormat('yyyy/MM/dd', 'ar');
  static final DateFormat _dateTimeFormat = DateFormat('yyyy/MM/dd HH:mm', 'ar');
  
  static String formatDate(DateTime date) {
    return _dateFormat.format(date);
  }
  
  static String formatDateTime(DateTime dateTime) {
    return _dateTimeFormat.format(dateTime);
  }
  
  static String formatOrdinationDate(DateTime date) {
    return 'تاريخ الرسامة: ${_dateFormat.format(date)}';
  }
  
  static DateTime? parseDate(String dateString) {
    try {
      return _dateFormat.parse(dateString);
    } catch (e) {
      return null;
    }
  }
  
  static bool isDateValid(DateTime date) {
    final now = DateTime.now();
    final minDate = DateTime(1900);
    return date.isAfter(minDate) && date.isBefore(now.add(const Duration(days: 1)));
  }
}
