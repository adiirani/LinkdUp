// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friendProvider.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FriendProviderAdapter extends TypeAdapter<FriendProvider> {
  @override
  final int typeId = 1;

  @override
  FriendProvider read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FriendProvider(
      id: fields[0] as String,
      name: fields[1] as String,
      bio: fields[2] as String,
      linkedSocials: (fields[3] as Map).cast<String, String>(),
    );
  }

  @override
  void write(BinaryWriter writer, FriendProvider obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.bio)
      ..writeByte(3)
      ..write(obj.linkedSocials);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FriendProviderAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
