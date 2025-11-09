import 'package:hive_flutter/hive_flutter.dart';
import 'package:recallist/core/models/item.dart';
import 'package:recallist/core/models/notification.dart';
import 'package:recallist/core/models/notification_preferences.dart';

class HiveDataSource {
  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(ItemAdapter());
    Hive.registerAdapter(NotificationAdapter());
    Hive.registerAdapter(NotificationPreferencesAdapter());
    Hive.registerAdapter(NotificationTypeAdapter());
    await Hive.openBox<int>('items_keys'); // Store auto-increment counter
    await Hive.openBox<int>('notifications_keys'); // Store notification ID counter
    await Hive.openBox<Item>('items');
    await Hive.openBox<Notification>('notifications');
    await Hive.openBox<NotificationPreferences>('notification_preferences');
  }

  Box<Item> get itemsBox => Hive.box<Item>('items');
  Box<int> get keysBox => Hive.box<int>('items_keys');
  Box<Notification> get notificationsBox => Hive.box<Notification>('notifications');
  Box<int> get notificationsKeysBox =>
      Hive.box<int>('notifications_keys');
  Box<NotificationPreferences> get notificationPreferencesBox =>
      Hive.box<NotificationPreferences>('notification_preferences');

  /// Get the next auto-increment ID for items
  int getNextId() {
    final currentId = keysBox.get('last_id', defaultValue: 0) ?? 0;
    final nextId = currentId + 1;
    keysBox.put('last_id', nextId);
    return nextId;
  }

  /// Get the next auto-increment ID for notifications
  int getNextNotificationId() {
    final currentId =
        notificationsKeysBox.get('last_id', defaultValue: 0) ?? 0;
    final nextId = currentId + 1;
    notificationsKeysBox.put('last_id', nextId);
    return nextId;
  }

  /// Get notification preferences, creating default if not exists
  NotificationPreferences getNotificationPreferences() {
    return notificationPreferencesBox.get('preferences') ??
        NotificationPreferences();
  }

  /// Save notification preferences
  Future<void> saveNotificationPreferences(
    NotificationPreferences preferences,
  ) async {
    await notificationPreferencesBox.put('preferences', preferences);
  }
}
