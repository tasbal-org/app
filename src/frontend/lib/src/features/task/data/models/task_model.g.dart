// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskModel _$TaskModelFromJson(Map<String, dynamic> json) => TaskModel(
  id: json['id'] as String,
  title: json['title'] as String,
  memo: json['memo'] as String?,
  stateValue: (json['state'] as num).toInt(),
  isPinned: json['is_pinned'] as bool? ?? false,
  dueAt: json['due_at'] as String?,
  tags:
      (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  createdAt: json['created_at'] as String,
  updatedAt: json['updated_at'] as String,
  completedAt: json['completed_at'] as String?,
);

Map<String, dynamic> _$TaskModelToJson(TaskModel instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'memo': instance.memo,
  'state': instance.stateValue,
  'is_pinned': instance.isPinned,
  'due_at': instance.dueAt,
  'tags': instance.tags,
  'created_at': instance.createdAt,
  'updated_at': instance.updatedAt,
  'completed_at': instance.completedAt,
};
