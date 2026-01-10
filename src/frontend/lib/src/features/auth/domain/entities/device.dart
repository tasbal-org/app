/// Auth Domain: Device Entity
///
/// デバイス情報を表現するエンティティ
/// 端末識別とゲスト認証に使用
library;

import 'package:equatable/equatable.dart';

/// デバイスエンティティ
///
/// デバイス登録時に発行される情報を保持
/// ゲストユーザーの端末識別に使用
class Device extends Equatable {
  /// デバイスID
  final String id;

  /// デバイスキー（認証用）
  final String deviceKey;

  /// デバイス名（例: "Yohei's iPhone"）
  final String deviceName;

  /// 最終使用日時
  final DateTime lastUsedAt;

  /// デバイス登録日時
  final DateTime createdAt;

  /// コンストラクタ
  const Device({
    required this.id,
    required this.deviceKey,
    required this.deviceName,
    required this.lastUsedAt,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, deviceKey, deviceName, lastUsedAt, createdAt];
}
