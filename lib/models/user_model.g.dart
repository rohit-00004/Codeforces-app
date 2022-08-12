// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CfuserAdapter extends TypeAdapter<Cfuser> {
  @override
  final int typeId = 0;

  @override
  Cfuser read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Cfuser(
      handle: fields[4] as String,
      rating: fields[0] as int,
      rank: fields[5] as String,
      maxrank: fields[6] as String,
      friends: fields[2] as int,
      maxrating: fields[1] as int,
      contribution: fields[3] as int,
      avatar: fields[7] as String,
      country: fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Cfuser obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.rating)
      ..writeByte(1)
      ..write(obj.maxrating)
      ..writeByte(2)
      ..write(obj.friends)
      ..writeByte(3)
      ..write(obj.contribution)
      ..writeByte(4)
      ..write(obj.handle)
      ..writeByte(5)
      ..write(obj.rank)
      ..writeByte(6)
      ..write(obj.maxrank)
      ..writeByte(7)
      ..write(obj.avatar)
      ..writeByte(8)
      ..write(obj.country);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CfuserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
