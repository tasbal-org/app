/// Auth Data: AuthTokenModel
///
/// AuthTokenエンティティのデータモデル
/// JSON シリアライゼーション対応
library;

import 'package:json_annotation/json_annotation.dart';
import 'package:tasbal/src/features/auth/domain/entities/auth_token.dart';

part 'auth_token_model.g.dart';

/// 認証トークンモデル
///
/// API レスポンスからの変換とエンティティへの変換を提供
@JsonSerializable()
class AuthTokenModel {
  /// アクセストークン
  @JsonKey(name: 'access_token')
  final String accessToken;

  /// リフレッシュトークン
  @JsonKey(name: 'refresh_token')
  final String refreshToken;

  /// 有効期限（秒）
  @JsonKey(name: 'expires_in')
  final int expiresIn;

  /// 発行日時（ISO 8601文字列）
  @JsonKey(name: 'issued_at')
  final String issuedAt;

  /// コンストラクタ
  const AuthTokenModel({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
    required this.issuedAt,
  });

  /// JSONからモデルを生成
  factory AuthTokenModel.fromJson(Map<String, dynamic> json) =>
      _$AuthTokenModelFromJson(json);

  /// モデルをJSONに変換
  Map<String, dynamic> toJson() => _$AuthTokenModelToJson(this);

  /// エンティティに変換
  AuthToken toEntity() {
    return AuthToken(
      accessToken: accessToken,
      refreshToken: refreshToken,
      expiresIn: expiresIn,
      issuedAt: DateTime.parse(issuedAt),
    );
  }

  /// エンティティからモデルを生成
  factory AuthTokenModel.fromEntity(AuthToken entity) {
    return AuthTokenModel(
      accessToken: entity.accessToken,
      refreshToken: entity.refreshToken,
      expiresIn: entity.expiresIn,
      issuedAt: entity.issuedAt.toIso8601String(),
    );
  }
}
