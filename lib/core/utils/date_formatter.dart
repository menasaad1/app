import 'package:intl/intl.dart';

class DateFormatter {
  static final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');
  static final DateFormat _timeFormat = DateFormat('HH:mm');
  static final DateFormat _dateTimeFormat = DateFormat('dd/MM/yyyy HH:mm');
  static final DateFormat _monthYearFormat = DateFormat('MM/yyyy');
  static final DateFormat _yearFormat = DateFormat('yyyy');

  static String formatDate(DateTime date) {
    return _dateFormat.format(date);
  }

  static String formatTime(DateTime time) {
    return _timeFormat.format(time);
  }

  static String formatDateTime(DateTime dateTime) {
    return _dateTimeFormat.format(dateTime);
  }

  static String formatMonthYear(DateTime date) {
    return _monthYearFormat.format(date);
  }

  static String formatYear(DateTime date) {
    return _yearFormat.format(date);
  }

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

  static String formatAge(DateTime birthDate) {
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    
    if (now.month < birthDate.month || 
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    
    return '$age سنة';
  }

  static String formatOrdinationYears(DateTime ordinationDate) {
    final now = DateTime.now();
    int years = now.year - ordinationDate.year;
    
    if (now.month < ordinationDate.month || 
        (now.month == ordinationDate.month && now.day < ordinationDate.day)) {
      years--;
    }
    
    return '$years سنة';
  }

  static String formatDateRange(DateTime startDate, DateTime endDate) {
    return '${formatDate(startDate)} - ${formatDate(endDate)}';
  }

  static String formatDateWithTime(DateTime dateTime) {
    return '${formatDate(dateTime)} ${formatTime(dateTime)}';
  }

  static String formatShortDate(DateTime date) {
    return DateFormat('dd/MM').format(date);
  }

  static String formatLongDate(DateTime date) {
    return DateFormat('EEEE, dd MMMM yyyy', 'ar').format(date);
  }

  static String formatShortDateTime(DateTime dateTime) {
    return '${formatShortDate(dateTime)} ${formatTime(dateTime)}';
  }
}
