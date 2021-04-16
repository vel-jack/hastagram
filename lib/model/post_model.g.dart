// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class InstaPostAdapter extends TypeAdapter<InstaPost> {
  @override
  final int typeId = 1;

  @override
  InstaPost read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return InstaPost(
      isVideo: fields[1] as bool,
      thumbnailUrl: fields[2] as String,
      id: fields[0] as String,
      shortCode: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, InstaPost obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.isVideo)
      ..writeByte(2)
      ..write(obj.thumbnailUrl)
      ..writeByte(3)
      ..write(obj.shortCode);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InstaPostAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
