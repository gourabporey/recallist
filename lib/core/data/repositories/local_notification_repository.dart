import 'package:recallist/core/data/datasources/hive_data_source.dart';
import 'package:recallist/core/data/repositories/notification_repository.dart';
import 'package:recallist/core/models/notification.dart';

class LocalNotificationRepository implements NotificationRepository {
  final HiveDataSource dataSource;

  LocalNotificationRepository(this.dataSource);

  @override
  Future<List<Notification>> getAllNotifications() async {
    final notifications = dataSource.notificationsBox.values.toList();
    // Sort by createdAt descending (newest first)
    notifications.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return notifications;
  }

  @override
  Future<List<Notification>> getUnreadNotifications() async {
    final allNotifications = await getAllNotifications();
    return allNotifications.where((n) => !n.isRead).toList();
  }

  @override
  Future<Notification?> getNotificationById(int id) async {
    return dataSource.notificationsBox.get(id);
  }

  @override
  Future<void> addNotification(Notification notification) async {
    // If notification doesn't have an ID, generate one
    final notificationToSave = notification.id == 0
        ? Notification(
            id: dataSource.getNextNotificationId(),
            itemId: notification.itemId,
            itemTitle: notification.itemTitle,
            type: notification.type,
            createdAt: notification.createdAt,
            revisionDate: notification.revisionDate,
            isRead: notification.isRead,
            message: notification.message,
          )
        : notification;
    await dataSource.notificationsBox.put(
      notificationToSave.id,
      notificationToSave,
    );
  }

  @override
  Future<void> updateNotification(Notification notification) async {
    await dataSource.notificationsBox.put(notification.id, notification);
  }

  @override
  Future<void> deleteNotification(int id) async {
    await dataSource.notificationsBox.delete(id);
  }

  @override
  Future<void> markAsRead(int id) async {
    final notification = await getNotificationById(id);
    if (notification != null) {
      await updateNotification(notification.copyWith(isRead: true));
    }
  }

  @override
  Future<void> markAsUnread(int id) async {
    final notification = await getNotificationById(id);
    if (notification != null) {
      await updateNotification(notification.copyWith(isRead: false));
    }
  }

  @override
  Future<void> markAllAsRead() async {
    final notifications = await getAllNotifications();
    for (final notification in notifications) {
      if (!notification.isRead) {
        await updateNotification(notification.copyWith(isRead: true));
      }
    }
  }

  @override
  Future<void> deleteAllNotifications() async {
    await dataSource.notificationsBox.clear();
  }

  @override
  Future<void> deleteReadNotifications() async {
    final notifications = await getAllNotifications();
    for (final notification in notifications) {
      if (notification.isRead) {
        await deleteNotification(notification.id);
      }
    }
  }

  @override
  Future<int> getUnreadCount() async {
    final unread = await getUnreadNotifications();
    return unread.length;
  }
}

