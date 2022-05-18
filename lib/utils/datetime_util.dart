class DateTimeUtil {
  /// Returns how many months count between [start] and [end]
  static int monthsBetween(DateTime start, DateTime end) {
    final int startMonth = start.month;
    final int endMonth = end.month;
    final int startYear = start.year;
    final int endYear = end.year;

    int months = 0;
    if (startYear == endYear) {
      months = endMonth - startMonth;
    } else {
      months = (endYear - startYear - 1) * 12 + endMonth + 12 - startMonth;
    }

    return months;
  }
}

extension DateTimeEx on DateTime {
  /// Returns this is between [start] and [end]
  bool isBetween(DateTime start, DateTime end) {
    return isAfter(start) && isBefore(end);
  }

  /// Returns this is between [start] and [end] or equal to [start] or [end]
  bool isBetweenOrEqual(DateTime start, DateTime end) {
    return isAfterOrEqualTo(start) && isBeforeOrEqualTo(end);
  }

  /// Returns this is after or equals [date]
  bool isAfterOrEqualTo(DateTime date) {
    return isAfter(date) || isAtSameMomentAs(date);
  }

  /// Returns this is before or equals [date]
  bool isBeforeOrEqualTo(DateTime date) {
    return isBefore(date) || isAtSameMomentAs(date);
  }
}
