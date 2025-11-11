import 'package:recallist/core/models/item.dart';

/// Utility functions for dashboard item filtering and categorization

/// Get the year month and day only from the datetime
DateTime toDateOnly(DateTime date) {
  return DateTime(date.year, date.month, date.day);
}

/// Check if a date is today (ignoring time)
bool isToday(DateTime date) {
  final today = toDateOnly(DateTime.now());
  final dateOnly = toDateOnly(date);
  return dateOnly.isAtSameMomentAs(today);
}

/// Check if a date is tomorrow (ignoring time)
bool isTomorrow(DateTime date) {
  final tomorrow = toDateOnly(DateTime.now()).add(const Duration(days: 1));
  final dateOnly = toDateOnly(date);
  return dateOnly.isAtSameMomentAs(tomorrow);
}

/// Check if a date is after tomorrow (>= day after tomorrow, ignoring time)
bool isAfterTomorrow(DateTime date) {
  const twoDays = Duration(days: 2);
  final dayAfterTomorrow = toDateOnly(DateTime.now()).add(twoDays);
  final dateOnly = toDateOnly(date);
  return dateOnly.isAfter(dayAfterTomorrow) ||
      dateOnly.isAtSameMomentAs(dayAfterTomorrow);
}

/// Filter items for Today tab
List<Item> getTodayItems(List<Item> items) {
  return items.where((item) {
    final nextRevision = item.getNextRevisionDate();
    return nextRevision != null && isToday(nextRevision);
  }).toList();
}

/// Filter items for Tomorrow tab
List<Item> getTomorrowItems(List<Item> items) {
  return items.where((item) {
    final nextRevision = item.getNextRevisionDate();
    return nextRevision != null && isTomorrow(nextRevision);
  }).toList();
}

/// Filter items for Upcoming tab (beyond tomorrow), sorted by date
List<Item> getUpcomingItems(List<Item> items) {
  final upcoming = items.where((item) {
    final nextRevision = item.getNextRevisionDate();
    if (nextRevision == null) return false;
    // Include items that are after tomorrow (not today or tomorrow)
    return !isToday(nextRevision) && isTomorrow(nextRevision) ||
        isAfterTomorrow(nextRevision);
  }).toList();

  // Sort by next revision date ascending
  upcoming.sort((a, b) {
    final dateA = a.getNextRevisionDate();
    final dateB = b.getNextRevisionDate();
    if (dateA == null && dateB == null) return 0;
    if (dateA == null) return 1;
    if (dateB == null) return -1;
    return dateA.compareTo(dateB);
  });

  return upcoming;
}

List<Item> getMissedItems(List<Item> items) {
  return items.where((item) {
    final nextRevision = item.getNextRevisionDate();
    return nextRevision != null && nextRevision.isBefore(DateTime.now());
  }).toList();
}
