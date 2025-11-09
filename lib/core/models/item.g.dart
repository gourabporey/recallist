// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ItemAdapter extends TypeAdapter<Item> {
  @override
  final int typeId = 0;

  @override
  Item read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Item(
      id: fields[0] as int,
      title: fields[1] as String,
      notes: fields[2] as String?,
      tags: (fields[3] as List?)?.cast<String>(),
      links: (fields[4] as List?)?.cast<String>(),
      images: (fields[5] as List?)?.cast<String>(),
      createdDate: fields[6] as DateTime,
      revisions: (fields[7] as List).cast<DateTime>(),
      revisionPattern: (fields[8] as List).cast<int>(),
    );
  }

  @override
  void write(BinaryWriter writer, Item obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.notes)
      ..writeByte(3)
      ..write(obj.tags)
      ..writeByte(4)
      ..write(obj.links)
      ..writeByte(5)
      ..write(obj.images)
      ..writeByte(6)
      ..write(obj.createdDate)
      ..writeByte(7)
      ..write(obj.revisions)
      ..writeByte(8)
      ..write(obj.revisionPattern);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
