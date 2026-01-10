// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthUserModel _$AuthUserModelFromJson(Map<String, dynamic> json) =>
    AuthUserModel(
      id: json['id'] as String,
      handle: json['handle'] as String,
      authStateValue: (json['auth_state'] as num).toInt(),
      planValue: (json['plan'] as num).toInt(),
      createdAt: json['created_at'] as String,
    );

Map<String, dynamic> _$AuthUserModelToJson(AuthUserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'handle': instance.handle,
      'auth_state': instance.authStateValue,
      'plan': instance.planValue,
      'created_at': instance.createdAt,
    };
