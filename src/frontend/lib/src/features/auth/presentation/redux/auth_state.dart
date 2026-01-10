/// Auth State
///
/// 認証機能のRedux状態
/// ユーザー情報、認証状態、トークン情報を管理
library;

import 'package:equatable/equatable.dart';
import 'package:tasbal/src/features/auth/domain/entities/auth_token.dart';
import 'package:tasbal/src/features/auth/domain/entities/auth_user.dart';
import 'package:tasbal/src/features/auth/domain/entities/device.dart';

/// 認証状態
///
/// アプリ全体で使用する認証情報を保持
class AuthState extends Equatable {
  /// 現在のユーザー（未認証時はnull）
  final AuthUser? user;

  /// 認証トークン（未認証時はnull）
  final AuthToken? token;

  /// デバイス情報（未登録時はnull）
  final Device? device;

  /// 認証処理中フラグ
  final bool isAuthenticating;

  /// 認証エラーメッセージ
  final String? errorMessage;

  const AuthState({
    this.user,
    this.token,
    this.device,
    this.isAuthenticating = false,
    this.errorMessage,
  });

  /// 初期状態
  factory AuthState.initial() => const AuthState();

  /// 認証済みかどうか
  bool get isAuthenticated => user != null && token != null;

  /// ゲストユーザーかどうか
  bool get isGuest => user?.isGuest ?? false;

  /// 連携済みユーザーかどうか
  bool get isLinked => user?.isLinked ?? false;

  /// デバイス登録済みかどうか
  bool get hasDevice => device != null;

  /// 有効なトークンを持っているかどうか
  bool get hasValidToken => token?.isValid ?? false;

  @override
  List<Object?> get props => [user, token, device, isAuthenticating, errorMessage];

  /// コピー with
  AuthState copyWith({
    AuthUser? user,
    AuthToken? token,
    Device? device,
    bool? isAuthenticating,
    String? errorMessage,
    bool clearUser = false,
    bool clearToken = false,
    bool clearDevice = false,
    bool clearError = false,
  }) {
    return AuthState(
      user: clearUser ? null : (user ?? this.user),
      token: clearToken ? null : (token ?? this.token),
      device: clearDevice ? null : (device ?? this.device),
      isAuthenticating: isAuthenticating ?? this.isAuthenticating,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
