/// Auth Data: DeviceModel
///
/// Deviceエンティティのデータモデル
/// JSON シリアライゼーション対応
library;

import 'package:json_annotation/json_annotation.dart';
import 'package:tasbal/src/features/auth/domain/entities/device.dart';

part 'device_model.g.dart';

/// デバイスモデル
///
/// API レスポンスからの変換とエンティティへの変換を提供
@JsonSerializable()
class DeviceModel {
  /// デバイスID
  final String id;

  /// デバイスキー
  @JsonKey(name: 'device_key')
  final String deviceKey;

  /// デバイス名
  @JsonKey(name: 'device_name')
  final String deviceName;

  /// 最終使用日時（ISO 8601文字列）
  @JsonKey(name: 'last_used_at')
  final String lastUsedAt;

  /// 作成日時（ISO 8601文字列）
  @JsonKey(name: 'created_at')
  final String createdAt;

  /// コンストラクタ
  const DeviceModel({
    required this.id,
    required this.deviceKey,
    required this.deviceName,
    required this.lastUsedAt,
    required this.createdAt,
  });

  /// JSONからモデルを生成
  factory DeviceModel.fromJson(Map<String, dynamic> json) =>
      _$DeviceModelFromJson(json);

  /// モデルをJSONに変換
  Map<String, dynamic> toJson() => _$DeviceModelToJson(this);

  /// エンティティに変換
  Device toEntity() {
    return Device(
      id: id,
      deviceKey: deviceKey,
      deviceName: deviceName,
      lastUsedAt: DateTime.parse(lastUsedAt),
      createdAt: DateTime.parse(createdAt),
    );
  }

  /// エンティティからモデルを生成
  factory DeviceModel.fromEntity(Device entity) {
    return DeviceModel(
      id: entity.id,
      deviceKey: entity.deviceKey,
      deviceName: entity.deviceName,
      lastUsedAt: entity.lastUsedAt.toIso8601String(),
      createdAt: entity.createdAt.toIso8601String(),
    );
  }
}
