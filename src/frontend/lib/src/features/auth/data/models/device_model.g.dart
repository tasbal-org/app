// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceModel _$DeviceModelFromJson(Map<String, dynamic> json) => DeviceModel(
  id: json['id'] as String,
  deviceKey: json['device_key'] as String,
  deviceName: json['device_name'] as String,
  lastUsedAt: json['last_used_at'] as String,
  createdAt: json['created_at'] as String,
);

Map<String, dynamic> _$DeviceModelToJson(DeviceModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'device_key': instance.deviceKey,
      'device_name': instance.deviceName,
      'last_used_at': instance.lastUsedAt,
      'created_at': instance.createdAt,
    };
