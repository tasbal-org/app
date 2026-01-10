/// Core Error: Failures
///
/// Domain層で使用するエラー表現クラス群
/// ExceptionをFailureに変換して、ビジネスロジック層で扱いやすくする
/// Equatableを継承し、値の等価性比較を可能にする
library;

import 'package:equatable/equatable.dart';

/// エラーの基底クラス
///
/// すべてのFailureはこのクラスを継承する
/// `Either<Failure, T>`パターンで使用される
abstract class Failure extends Equatable {
  /// エラーメッセージ（ユーザーに表示可能な形式）

  final String message;

  const Failure({required this.message});

  @override
  List<Object?> get props => [message];
}

/// サーバーAPIエラー
///
/// ServerExceptionから変換される
/// HTTP通信エラー、API応答エラー等を表現
class ServerFailure extends Failure {
  /// HTTPステータスコード（任意）

  final int? statusCode;

  const ServerFailure({
    required super.message,
    this.statusCode,
  });

  @override
  List<Object?> get props => [message, statusCode];
}

/// 認証・認可エラー
///
/// UnauthorizedExceptionから変換される
/// トークン期限切れ、権限不足等を表現
class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({super.message = '認証が必要です'});
}

/// ローカルストレージエラー
///
/// CacheExceptionから変換される
/// Hive等のローカルストレージ操作失敗時に使用
class CacheFailure extends Failure {
  const CacheFailure({required super.message});
}

/// ネットワーク接続エラー
///
/// NetworkExceptionから変換される
/// インターネット未接続、タイムアウト等を表現
class NetworkFailure extends Failure {
  const NetworkFailure({super.message = 'ネットワークエラーが発生しました'});
}

/// バリデーションエラー
///
/// フォーム入力値の検証失敗時に使用
/// ユーザー入力の不備を表現
class ValidationFailure extends Failure {
  const ValidationFailure({required super.message});
}
