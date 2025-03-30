// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profileProvider.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProfileProviderAdapter extends TypeAdapter<ProfileProvider> {
  @override
  final int typeId = 0;

  @override
  ProfileProvider read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProfileProvider(
      id: fields[0] as String,
      name: fields[1] as String,
      bio: fields[2] as String,
      linkedSocials: (fields[3] as Map).cast<String, String>(),
      friends: (fields[4] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, ProfileProvider obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.bio)
      ..writeByte(3)
      ..write(obj.linkedSocials)
      ..writeByte(4)
      ..write(obj.friends);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProfileProviderAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
