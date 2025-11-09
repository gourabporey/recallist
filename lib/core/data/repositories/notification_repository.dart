import 'package:recallist/core/models/notification.dart';

abstract class NotificationRepository {
  Future<List<Notification>> getAllNotifications();
  Future<List<Notification>> getUnreadNotifications();
  Future<Notification?> getNotificationById(int id);
  Future<void> addNotification(Notification notification);
  Future<void> updateNotification(Notification notification);
  Future<void> deleteNotification(int id);
  Future<void> markAsRead(int id);
  Future<void> markAsUnread(int id);
  Future<void> markAllAsRead();
  Future<void> deleteAllNotifications();
  Future<void> deleteReadNotifications();
  Future<int> getUnreadCount();
}

