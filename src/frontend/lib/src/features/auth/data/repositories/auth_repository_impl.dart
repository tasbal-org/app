/// Auth Data: AuthRepositoryImpl
///
/// AuthRepositoryインターフェースの実装
/// リモートAPIとローカルストレージを統合
library;

import 'package:dartz/dartz.dart';
import 'package:tasbal/src/core/error/exceptions.dart';
import 'package:tasbal/src/core/error/failures.dart';
import 'package:tasbal/src/features/auth/data/data_sources/local/auth_local_service.dart';
import 'package:tasbal/src/features/auth/data/data_sources/remote/auth_api_service.dart';
import 'package:tasbal/src/features/auth/data/models/auth_token_model.dart';
import 'package:tasbal/src/features/auth/data/models/device_model.dart';
import 'package:tasbal/src/features/auth/domain/entities/auth_token.dart';
import 'package:tasbal/src/features/auth/domain/entities/auth_user.dart';
import 'package:tasbal/src/features/auth/domain/entities/device.dart';
import 'package:tasbal/src/features/auth/domain/repositories/auth_repository.dart';

/// 認証リポジトリ実装
///
/// APIとローカルストレージを統合して認証機能を提供
class AuthRepositoryImpl implements AuthRepository {
  /// リモートAPIサービス
  final AuthApiService apiService;

  /// ローカルストレージサービス
  final AuthLocalService localService;

  /// コンストラクタ
  AuthRepositoryImpl({
    required this.apiService,
    required this.localService,
  });

  @override
  Future<Either<Failure, Device>> registerDevice({
    required String deviceName,
    String? pushToken,
  }) async {
    try {
      final deviceModel = await apiService.registerDevice(
        deviceName: deviceName,
        pushToken: pushToken,
      );
      return Right(deviceModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(
        message: e.message,
        statusCode: e.statusCode,
      ));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: '予期しないエラーが発生しました: $e'));
    }
  }

  @override
  Future<Either<Failure, AuthUser>> guestAuth({
    required String deviceKey,
  }) async {
    try {
      final result = await apiService.guestAuth(deviceKey: deviceKey);
      final userModel = result['user'];
      final tokensModel = result['tokens'];

      // トークンをローカルに保存
      await localService.saveToken(tokensModel.toJson());

      return Right(userModel.toEntity());
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(
        message: e.message,
        statusCode: e.statusCode,
      ));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: '予期しないエラーが発生しました: $e'));
    }
  }

  @override
  Future<Either<Failure, AuthToken>> refreshToken() async {
    try {
      // ローカルからリフレッシュトークンを取得
      final tokenModel = await localService.getToken();
      if (tokenModel == null) {
        return const Left(UnauthorizedFailure(
          message: '保存されたトークンが見つかりません',
        ));
      }

      // トークンリフレッシュAPIを呼び出し
      final newTokenModel = await apiService.refreshToken(
        refreshToken: tokenModel.refreshToken,
      );

      // 新しいトークンを保存
      await localService.saveToken(newTokenModel.toJson());

      return Right(newTokenModel.toEntity());
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(
        message: e.message,
        statusCode: e.statusCode,
      ));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: '予期しないエラーが発生しました: $e'));
    }
  }

  @override
  Future<Either<Failure, AuthToken?>> getSavedToken() async {
    try {
      final tokenModel = await localService.getToken();
      if (tokenModel == null) {
        return const Right(null);
      }
      return Right(tokenModel.toEntity());
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(CacheFailure(message: '予期しないエラーが発生しました: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> saveToken(AuthToken token) async {
    try {
      // エンティティをモデルに変換してJSONで保存
      final tokenModel = AuthTokenModel.fromEntity(token);
      await localService.saveToken(tokenModel.toJson());
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(CacheFailure(message: '予期しないエラーが発生しました: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> clearToken() async {
    try {
      await localService.clearToken();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(CacheFailure(message: '予期しないエラーが発生しました: $e'));
    }
  }

  @override
  Future<Either<Failure, Device?>> getSavedDevice() async {
    try {
      final deviceModel = await localService.getDevice();
      if (deviceModel == null) {
        return const Right(null);
      }
      return Right(deviceModel.toEntity());
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(CacheFailure(message: '予期しないエラーが発生しました: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> saveDevice(Device device) async {
    try {
      // エンティティをモデルに変換してJSONで保存
      final deviceModel = DeviceModel.fromEntity(device);
      await localService.saveDevice(deviceModel.toJson());
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(CacheFailure(message: '予期しないエラーが発生しました: $e'));
    }
  }
}
