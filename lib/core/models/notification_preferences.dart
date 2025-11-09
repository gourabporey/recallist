import 'package:hive/hive.dart';

part 'notification_preferences.g.dart'; // generated file

@HiveType(typeId: 2)
class NotificationPreferences extends HiveObject {
  @HiveField(0)
  final bool dailyRemindersEnabled;

  @HiveField(1)
  final bool tomorrowPreviewEnabled;

  @HiveField(2)
  final bool upcomingRevisionEnabled;

  @HiveField(3)
  final int upcomingRevisionDays; // 3, 5, or 7 days before

  @HiveField(4)
  final int dailyCheckHour; // Hour of day for daily checks (0-23)

  @HiveField(5)
  final int dailyCheckMinute; // Minute of hour for daily checks (0-59)

  NotificationPreferences({
    this.dailyRemindersEnabled = true,
    this.tomorrowPreviewEnabled = true,
    this.upcomingRevisionEnabled = true,
    this.upcomingRevisionDays = 3,
    this.dailyCheckHour = 8,
    this.dailyCheckMinute = 0,
  });

  NotificationPreferences copyWith({
    bool? dailyRemindersEnabled,
    bool? tomorrowPreviewEnabled,
    bool? upcomingRevisionEnabled,
    int? upcomingRevisionDays,
    int? dailyCheckHour,
    int? dailyCheckMinute,
  }) {
    return NotificationPreferences(
      dailyRemindersEnabled:
          dailyRemindersEnabled ?? this.dailyRemindersEnabled,
      tomorrowPreviewEnabled:
          tomorrowPreviewEnabled ?? this.tomorrowPreviewEnabled,
      upcomingRevisionEnabled:
          upcomingRevisionEnabled ?? this.upcomingRevisionEnabled,
      upcomingRevisionDays: upcomingRevisionDays ?? this.upcomingRevisionDays,
      dailyCheckHour: dailyCheckHour ?? this.dailyCheckHour,
      dailyCheckMinute: dailyCheckMinute ?? this.dailyCheckMinute,
    );
  }
}
