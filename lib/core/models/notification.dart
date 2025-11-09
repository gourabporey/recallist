import 'package:hive/hive.dart';

part 'notification.g.dart'; // generated file

@HiveType(typeId: 3)
enum NotificationType {
  @HiveField(0)
  dailyReminder,
  @HiveField(1)
  tomorrowPreview,
  @HiveField(2)
  upcomingRevision,
}

@HiveType(typeId: 1)
class Notification extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final int itemId;

  @HiveField(2)
  final String itemTitle;

  @HiveField(3)
  final NotificationType type;

  @HiveField(4)
  final DateTime createdAt;

  @HiveField(5)
  final DateTime revisionDate;

  @HiveField(6)
  final bool isRead;

  @HiveField(7)
  final String message;

  Notification({
    required this.id,
    required this.itemId,
    required this.itemTitle,
    required this.type,
    required this.createdAt,
    required this.revisionDate,
    this.isRead = false,
    required this.message,
  });

  Notification copyWith({
    int? id,
    int? itemId,
    String? itemTitle,
    NotificationType? type,
    DateTime? createdAt,
    DateTime? revisionDate,
    bool? isRead,
    String? message,
  }) {
    return Notification(
      id: id ?? this.id,
      itemId: itemId ?? this.itemId,
      itemTitle: itemTitle ?? this.itemTitle,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      revisionDate: revisionDate ?? this.revisionDate,
      isRead: isRead ?? this.isRead,
      message: message ?? this.message,
    );
  }
}

