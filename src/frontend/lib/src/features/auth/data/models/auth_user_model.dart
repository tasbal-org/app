/// Auth Data: AuthUserModel
///
/// AuthUserエンティティのデータモデル
/// JSON シリアライゼーション対応
library;

import 'package:json_annotation/json_annotation.dart';
import 'package:tasbal/src/enums/auth_state.dart';
import 'package:tasbal/src/enums/user_plan.dart';
import 'package:tasbal/src/features/auth/domain/entities/auth_user.dart';

part 'auth_user_model.g.dart';

/// 認証ユーザーモデル
///
/// API レスポンスからの変換とエンティティへの変換を提供
@JsonSerializable()
class AuthUserModel {
  /// ユーザーID
  final String id;

  /// ハンドル名
  final String handle;

  /// 認証状態（enum value）
  @JsonKey(name: 'auth_state')
  final int authStateValue;

  /// プラン（enum value）
  @JsonKey(name: 'plan')
  final int planValue;

  /// 作成日時（ISO 8601文字列）
  @JsonKey(name: 'created_at')
  final String createdAt;

  /// コンストラクタ
  const AuthUserModel({
    required this.id,
    required this.handle,
    required this.authStateValue,
    required this.planValue,
    required this.createdAt,
  });

  /// JSONからモデルを生成
  factory AuthUserModel.fromJson(Map<String, dynamic> json) =>
      _$AuthUserModelFromJson(json);

  /// モデルをJSONに変換
  Map<String, dynamic> toJson() => _$AuthUserModelToJson(this);

  /// エンティティに変換
  ///
  /// enum値を適切なenum型に変換
  AuthUser toEntity() {
    return AuthUser(
      id: id,
      handle: handle,
      authState: AuthState.fromValue(authStateValue) ?? AuthState.Guest,
      plan: UserPlan.fromValue(planValue) ?? UserPlan.Free,
      createdAt: DateTime.parse(createdAt),
    );
  }

  /// エンティティからモデルを生成
  factory AuthUserModel.fromEntity(AuthUser entity) {
    return AuthUserModel(
      id: entity.id,
      handle: entity.handle,
      authStateValue: entity.authState.value,
      planValue: entity.plan.value,
      createdAt: entity.createdAt.toIso8601String(),
    );
  }
}
