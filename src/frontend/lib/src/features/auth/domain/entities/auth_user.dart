/// Auth Domain: AuthUser Entity
///
/// 認証済みユーザーを表現するエンティティ
/// ビジネスロジック層で使用される
library;

import 'package:equatable/equatable.dart';
import 'package:tasbal/src/enums/auth_state.dart';
import 'package:tasbal/src/enums/user_plan.dart';

/// 認証ユーザーエンティティ
///
/// ゲストユーザーと正式ユーザーの両方を表現
/// プラン情報も含む
class AuthUser extends Equatable {
  /// ユーザーID
  final String id;

  /// ハンドル名（表示名）
  final String handle;

  /// 認証状態（ゲスト / 連携済み / 無効）
  final AuthState authState;

  /// プラン（FREE / PRO）
  final UserPlan plan;

  /// アカウント作成日時
  final DateTime createdAt;

  /// コンストラクタ
  const AuthUser({
    required this.id,
    required this.handle,
    required this.authState,
    required this.plan,
    required this.createdAt,
  });

  /// ゲストユーザーかどうか
  bool get isGuest => authState == AuthState.Guest;

  /// 連携済みユーザーかどうか
  bool get isLinked => authState == AuthState.Linked;

  @override
  List<Object?> get props => [id, handle, authState, plan, createdAt];
}
