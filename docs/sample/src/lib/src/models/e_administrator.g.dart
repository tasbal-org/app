// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'e_administrator.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EAdministratorAdapter extends TypeAdapter<EAdministrator> {
  @override
  final int typeId = 0;

  @override
  EAdministrator read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EAdministrator(
      id: fields[0] as BigInt?,
      email: fields[1] as String?,
      password: fields[2] as String?,
      lastName: fields[3] as String?,
      firstName: fields[4] as String?,
      birthDate: fields[5] as DateTime?,
      tel: fields[6] as String?,
      emailVerifiedAt: fields[7] as DateTime?,
      createdAt: fields[8] as DateTime?,
      updatedAt: fields[9] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, EAdministrator obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.password)
      ..writeByte(3)
      ..write(obj.lastName)
      ..writeByte(4)
      ..write(obj.firstName)
      ..writeByte(5)
      ..write(obj.birthDate)
      ..writeByte(6)
      ..write(obj.tel)
      ..writeByte(7)
      ..write(obj.emailVerifiedAt)
      ..writeByte(8)
      ..write(obj.createdAt)
      ..writeByte(9)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EAdministratorAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EAdministrator _$EAdministratorFromJson(Map<String, dynamic> json) =>
    EAdministrator(
      id: JsonHelper.bigIntFromJson(json['id'] as String?),
      email: json['email'] as String?,
      lastName: json['lastName'] as String?,
      firstName: json['firstName'] as String?,
      birthDate: JsonHelper.dateTimeFromJson(json['birthDate'] as String?),
      tel: json['tel'] as String?,
      emailVerifiedAt:
          JsonHelper.dateTimeFromJson(json['emailVerifiedAt'] as String?),
      createdAt: JsonHelper.dateTimeFromJson(json['createdAt'] as String?),
      updatedAt: JsonHelper.dateTimeFromJson(json['updatedAt'] as String?),
    );

Map<String, dynamic> _$EAdministratorToJson(EAdministrator instance) =>
    <String, dynamic>{
      'id': JsonHelper.bigIntToJson(instance.id),
      'email': instance.email,
      'lastName': instance.lastName,
      'firstName': instance.firstName,
      'birthDate': JsonHelper.dateTimeToJson(instance.birthDate),
      'tel': instance.tel,
      'emailVerifiedAt': JsonHelper.dateTimeToJson(instance.emailVerifiedAt),
      'createdAt': JsonHelper.dateTimeToJson(instance.createdAt),
      'updatedAt': JsonHelper.dateTimeToJson(instance.updatedAt),
    };
