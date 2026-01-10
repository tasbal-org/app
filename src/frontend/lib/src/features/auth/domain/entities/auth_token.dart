/// Auth Domain: AuthToken Entity
///
/// 認証トークンを表現するエンティティ
/// アクセストークンとリフレッシュトークンを保持
library;

import 'package:equatable/equatable.dart';

/// 認証トークンエンティティ
///
/// JWT形式のアクセストークンとリフレッシュトークンを管理
/// 有効期限も含む
class AuthToken extends Equatable {
  /// アクセストークン（JWT）
  final String accessToken;

  /// リフレッシュトークン
  final String refreshToken;

  /// 有効期限（秒）
  final int expiresIn;

  /// トークン発行日時
  final DateTime issuedAt;

  /// コンストラクタ
  const AuthToken({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
    required this.issuedAt,
  });

  /// トークンが有効かどうかを判定
  ///
  /// 現在時刻と発行日時を比較して有効期限内かチェック
  bool get isValid {
    final now = DateTime.now();
    final expiryDate = issuedAt.add(Duration(seconds: expiresIn));
    return now.isBefore(expiryDate);
  }

  /// トークンの残り有効期限（秒）
  int get remainingSeconds {
    final now = DateTime.now();
    final expiryDate = issuedAt.add(Duration(seconds: expiresIn));
    final remaining = expiryDate.difference(now).inSeconds;
    return remaining > 0 ? remaining : 0;
  }

  @override
  List<Object?> get props => [accessToken, refreshToken, expiresIn, issuedAt];
}
