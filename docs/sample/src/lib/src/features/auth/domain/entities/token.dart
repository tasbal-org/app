import 'package:equatable/equatable.dart';

class Token extends Equatable {
  final String accessToken;
  final String refreshToken;
  final int expiresIn;

  const Token({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
  });

  // 等価性比較（オプション、必要に応じて）
  @override
  List<Object> get props => [accessToken, refreshToken, expiresIn];

  @override
  String toString() =>
      'Token(accessToken: $accessToken, refreshToken: $refreshToken, expiresIn: $expiresIn)';
}