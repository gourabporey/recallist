// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_preferences.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NotificationPreferencesAdapter
    extends TypeAdapter<NotificationPreferences> {
  @override
  final int typeId = 2;

  @override
  NotificationPreferences read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NotificationPreferences(
      dailyRemindersEnabled: fields[0] as bool,
      tomorrowPreviewEnabled: fields[1] as bool,
      upcomingRevisionEnabled: fields[2] as bool,
      upcomingRevisionDays: fields[3] as int,
      dailyCheckHour: fields[4] as int,
      dailyCheckMinute: fields[5] as int,
    );
  }

  @override
  void write(BinaryWriter writer, NotificationPreferences obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.dailyRemindersEnabled)
      ..writeByte(1)
      ..write(obj.tomorrowPreviewEnabled)
      ..writeByte(2)
      ..write(obj.upcomingRevisionEnabled)
      ..writeByte(3)
      ..write(obj.upcomingRevisionDays)
      ..writeByte(4)
      ..write(obj.dailyCheckHour)
      ..writeByte(5)
      ..write(obj.dailyCheckMinute);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationPreferencesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
