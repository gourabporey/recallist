import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:recallist/core/data/repositories/item_repository.dart';
import 'package:recallist/core/models/item.dart';

class NotificationService {
  final ItemRepository itemRepository;
  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  NotificationService({required this.itemRepository});

  /// Initialize the notification service
  Future<void> initialize() async {
    if (_initialized) return;

    // Initialize timezone data
    tz.initializeTimeZones();
    // Use local timezone

    tz.setLocalLocation(tz.getLocation("Asia/Calcutta"));
    print(">>>>> tz.local.name: ${tz.local.name}");

    // Initialize Android settings
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    // Initialize iOS settings
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Request permissions for Android 13+
    await _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();

    // Request permissions for iOS
    await _notifications
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);

    _initialized = true;
    // await scheduleAllNotifications();
  }

  /// Handle notification tap
  void _onNotificationTapped(NotificationResponse response) {
    // Notification was tapped - could navigate to item detail if needed
    // For now, we'll just handle it silently
  }

  /// Schedule all notifications for all items
  Future<void> scheduleAllNotifications() async {
    // Cancel all existing notifications first
    await _notifications.cancelAll();

    final items = await itemRepository.getAllItems();
    final itemsByDate = <DateTime, List<Item>>{};

    // Group items by their revision date
    for (final item in items) {
      final nextRevision = item.getNextRevisionDate();
      if (nextRevision == null) continue;

      final revisionDateOnly = DateTime(
        nextRevision.year,
        nextRevision.month,
        nextRevision.day,
      );

      // Only schedule notifications for future dates (today or later)
      final today = DateTime.now();
      final todayDateOnly = DateTime(today.year, today.month, today.day);

      if (revisionDateOnly.isBefore(todayDateOnly)) {
        continue; // Skip past dates
      }

      itemsByDate.putIfAbsent(revisionDateOnly, () => []).add(item);
    }

    // Schedule notifications for each date
    for (final entry in itemsByDate.entries) {
      await _scheduleNotificationForDate(entry.key, entry.value);
    }
  }

  /// Schedule a notification for a specific date with grouped items
  Future<void> _scheduleNotificationForDate(
    DateTime date,
    List<Item> items,
  ) async {
    if (items.isEmpty) return;

    // Create notification message based on item count
    final String title;
    final String body;

    if (items.length == 1) {
      // Single item: "You have to revise 'note-name' today"
      title = 'Revision Reminder';
      body = "You have to revise '${items.first.title}' today";
    } else {
      // Multiple items: "You have 'item' and 5 things to revise today"
      final firstItemName = items.first.title;
      final remainingCount = items.length - 1;
      title = 'Revision Reminder';
      if (remainingCount == 1) {
        body = "You have '$firstItemName' and 1 thing to revision today";
      } else {
        body =
            "You have '$firstItemName' and $remainingCount things to revision today";
      }
    }

    final scheduledDate = tz.TZDateTime(
      tz.local,
      date.year,
      date.month,
      date.day,
      9, // 9 AM
      0, // 0 minutes
    );

    print(">>> Scheduled date: $scheduledDate");

    // Use date as notification ID to ensure uniqueness per date
    final notificationId =
        date.millisecondsSinceEpoch ~/ 86400000; // Unique ID per day

    // Android notification details
    const androidDetails = AndroidNotificationDetails(
      'revision_reminders',
      'Revision Reminders',
      channelDescription: 'Notifications for items due for revision',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
    );

    // iOS notification details
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // Schedule the notification
    await _notifications.zonedSchedule(
      notificationId,
      title,
      body,
      scheduledDate,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
    );
  }

  /// Reschedule notifications when items are updated
  Future<void> rescheduleNotifications() async {
    await scheduleAllNotifications();
  }

  /// Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }
}
