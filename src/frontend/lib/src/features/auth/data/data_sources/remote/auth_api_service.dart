/// Auth Data: AuthApiService
///
/// 認証機能のリモートAPI通信
/// サーバーとの通信を担当
library;

import 'package:dio/dio.dart';
import 'package:tasbal/src/core/constants/api_constants.dart';
import 'package:tasbal/src/core/error/exceptions.dart';
import 'package:tasbal/src/features/auth/data/models/auth_token_model.dart';
import 'package:tasbal/src/features/auth/data/models/auth_user_model.dart';
import 'package:tasbal/src/features/auth/data/models/device_model.dart';

/// 認証API サービス
///
/// 認証関連のAPI呼び出しを提供
class AuthApiService {
  /// Dioインスタンス
  final Dio dio;

  /// コンストラクタ
  AuthApiService(this.dio);

  /// デバイス登録
  ///
  /// POST /devices/register
  /// [deviceName] デバイス名
  /// [pushToken] プッシュ通知トークン（任意）
  Future<DeviceModel> registerDevice({
    required String deviceName,
    String? pushToken,
  }) async {
    try {
      final response = await dio.post(
        ApiConstants.devicesRegisterEndpoint,
        data: {
          'device_name': deviceName,
          if (pushToken != null) 'push_token': pushToken,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final deviceData = response.data['device'] as Map<String, dynamic>;
        return DeviceModel.fromJson(deviceData);
      } else {
        throw ServerException(
          message: 'デバイス登録に失敗しました',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
        throw UnauthorizedException(
          message: e.response?.data?['error']?['message'] ?? '認証エラー',
        );
      }
      throw ServerException(
        message: e.response?.data?['error']?['message'] ?? 'デバイス登録に失敗しました',
        statusCode: e.response?.statusCode,
      );
    }
  }

  /// ゲスト認証
  ///
  /// POST /auth/guest
  /// [deviceKey] デバイスキー
  Future<Map<String, dynamic>> guestAuth({
    required String deviceKey,
  }) async {
    try {
      final response = await dio.post(
        ApiConstants.guestAuthEndpoint,
        data: {'device_key': deviceKey},
        options: Options(
          headers: {
            ApiConstants.deviceKeyHeader: deviceKey,
          },
        ),
      );

      if (response.statusCode == 200) {
        final user = AuthUserModel.fromJson(
          response.data['user'] as Map<String, dynamic>,
        );
        final tokens = AuthTokenModel.fromJson(
          response.data['tokens'] as Map<String, dynamic>,
        );

        return {
          'user': user,
          'tokens': tokens,
        };
      } else {
        throw ServerException(
          message: 'ゲスト認証に失敗しました',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
        throw UnauthorizedException(
          message: e.response?.data?['error']?['message'] ?? '認証エラー',
        );
      }
      throw ServerException(
        message: e.response?.data?['error']?['message'] ?? 'ゲスト認証に失敗しました',
        statusCode: e.response?.statusCode,
      );
    }
  }

  /// トークンリフレッシュ
  ///
  /// POST /auth/refresh
  /// [refreshToken] リフレッシュトークン
  Future<AuthTokenModel> refreshToken({
    required String refreshToken,
  }) async {
    try {
      final response = await dio.post(
        ApiConstants.refreshTokenEndpoint,
        data: {'refresh_token': refreshToken},
      );

      if (response.statusCode == 200) {
        return AuthTokenModel.fromJson(
          response.data['tokens'] as Map<String, dynamic>,
        );
      } else {
        throw ServerException(
          message: 'トークンリフレッシュに失敗しました',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
        throw UnauthorizedException(
          message: e.response?.data?['error']?['message'] ?? '認証エラー',
        );
      }
      throw ServerException(
        message: e.response?.data?['error']?['message'] ?? 'トークンリフレッシュに失敗しました',
        statusCode: e.response?.statusCode,
      );
    }
  }
}
