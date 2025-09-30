import 'package:intl/intl.dart';

class DateUtils {
  static final DateFormat _dateFormat = DateFormat('yyyy/MM/dd', 'ar');
  static final DateFormat _dateTimeFormat = DateFormat('yyyy/MM/dd HH:mm', 'ar');
  static final DateFormat _timeFormat = DateFormat('HH:mm', 'ar');
  static final DateFormat _monthYearFormat = DateFormat('MM/yyyy', 'ar');
  static final DateFormat _yearFormat = DateFormat('yyyy', 'ar');
  
  // Basic formatting
  static String formatDate(DateTime date) {
    return _dateFormat.format(date);
  }
  
  static String formatDateTime(DateTime dateTime) {
    return _dateTimeFormat.format(dateTime);
  }
  
  static String formatTime(DateTime time) {
    return _timeFormat.format(time);
  }
  
  static String formatMonthYear(DateTime date) {
    return _monthYearFormat.format(date);
  }
  
  static String formatYear(DateTime date) {
    return _yearFormat.format(date);
  }
  
  // Specialized formatting
  static String formatOrdinationDate(DateTime date) {
    return 'تاريخ الرسامة: ${_dateFormat.format(date)}';
  }
  
  static String formatBirthDate(DateTime date) {
    return 'تاريخ الميلاد: ${_dateFormat.format(date)}';
  }
  
  static String formatCreatedDate(DateTime date) {
    return 'تاريخ الإنشاء: ${_dateFormat.format(date)}';
  }
  
  static String formatUpdatedDate(DateTime date) {
    return 'تاريخ التحديث: ${_dateFormat.format(date)}';
  }
  
  // Relative date formatting
  static String formatRelativeDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      return 'اليوم';
    } else if (difference.inDays == 1) {
      return 'أمس';
    } else if (difference.inDays < 7) {
      return 'منذ ${difference.inDays} أيام';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return 'منذ $weeks ${weeks == 1 ? 'أسبوع' : 'أسابيع'}';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return 'منذ $months ${months == 1 ? 'شهر' : 'أشهر'}';
    } else {
      final years = (difference.inDays / 365).floor();
      return 'منذ $years ${years == 1 ? 'سنة' : 'سنوات'}';
    }
  }
  
  // Date parsing
  static DateTime? parseDate(String dateString) {
    try {
      return _dateFormat.parse(dateString);
    } catch (e) {
      return null;
    }
  }
  
  static DateTime? parseDateTime(String dateTimeString) {
    try {
      return _dateTimeFormat.parse(dateTimeString);
    } catch (e) {
      return null;
    }
  }
  
  // Date validation
  static bool isDateValid(DateTime date) {
    final now = DateTime.now();
    final minDate = DateTime(1900);
    return date.isAfter(minDate) && date.isBefore(now.add(const Duration(days: 1)));
  }
  
  static bool isDateInPast(DateTime date) {
    final now = DateTime.now();
    return date.isBefore(now);
  }
  
  static bool isDateInFuture(DateTime date) {
    final now = DateTime.now();
    return date.isAfter(now);
  }
  
  static bool isDateToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }
  
  static bool isDateYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.year == yesterday.year && date.month == yesterday.month && date.day == yesterday.day;
  }
  
  static bool isDateTomorrow(DateTime date) {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return date.year == tomorrow.year && date.month == tomorrow.month && date.day == tomorrow.day;
  }
  
  // Date calculations
  static int getAge(DateTime birthDate) {
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month || (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age;
  }
  
  static int getDaysDifference(DateTime date1, DateTime date2) {
    return date1.difference(date2).inDays;
  }
  
  static int getMonthsDifference(DateTime date1, DateTime date2) {
    return (date1.year - date2.year) * 12 + date1.month - date2.month;
  }
  
  static int getYearsDifference(DateTime date1, DateTime date2) {
    return date1.year - date2.year;
  }
  
  // Date manipulation
  static DateTime addDays(DateTime date, int days) {
    return date.add(Duration(days: days));
  }
  
  static DateTime addMonths(DateTime date, int months) {
    return DateTime(date.year, date.month + months, date.day);
  }
  
  static DateTime addYears(DateTime date, int years) {
    return DateTime(date.year + years, date.month, date.day);
  }
  
  static DateTime startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }
  
  static DateTime endOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
  }
  
  static DateTime startOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }
  
  static DateTime endOfMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0);
  }
  
  static DateTime startOfYear(DateTime date) {
    return DateTime(date.year, 1, 1);
  }
  
  static DateTime endOfYear(DateTime date) {
    return DateTime(date.year, 12, 31);
  }
}