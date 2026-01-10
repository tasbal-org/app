/// Auth Data: AuthLocalService
///
/// 認証情報のローカル保存
/// Hiveを使用してトークンとデバイス情報を永続化
library;

import 'package:hive/hive.dart';
import 'package:tasbal/src/core/error/exceptions.dart';
import 'package:tasbal/src/features/auth/data/models/auth_token_model.dart';
import 'package:tasbal/src/features/auth/data/models/device_model.dart';

/// 認証ローカルサービス
///
/// Hiveを使用した認証情報の永続化
class AuthLocalService {
  /// Hiveボックス名
  static const String _authBoxName = 'auth_box';

  /// トークン保存キー
  static const String _tokenKey = 'auth_token';

  /// デバイス情報保存キー
  static const String _deviceKey = 'device_info';

  /// トークンを保存
  ///
  /// [token] 保存する認証トークン（JSON形式）
  Future<void> saveToken(Map<String, dynamic> tokenJson) async {
    try {
      final box = await Hive.openBox(_authBoxName);
      await box.put(_tokenKey, tokenJson);
    } catch (e) {
      throw CacheException(message: 'トークンの保存に失敗しました: $e');
    }
  }

  /// トークンを取得
  ///
  /// 保存されていない場合はnullを返す
  Future<AuthTokenModel?> getToken() async {
    try {
      final box = await Hive.openBox(_authBoxName);
      final tokenJson = box.get(_tokenKey) as Map<String, dynamic>?;
      if (tokenJson == null) {
        return null;
      }
      return AuthTokenModel.fromJson(Map<String, dynamic>.from(tokenJson));
    } catch (e) {
      throw CacheException(message: 'トークンの取得に失敗しました: $e');
    }
  }

  /// トークンを削除
  Future<void> clearToken() async {
    try {
      final box = await Hive.openBox(_authBoxName);
      await box.delete(_tokenKey);
    } catch (e) {
      throw CacheException(message: 'トークンの削除に失敗しました: $e');
    }
  }

  /// デバイス情報を保存
  ///
  /// [device] 保存するデバイス情報（JSON形式）
  Future<void> saveDevice(Map<String, dynamic> deviceJson) async {
    try {
      final box = await Hive.openBox(_authBoxName);
      await box.put(_deviceKey, deviceJson);
    } catch (e) {
      throw CacheException(message: 'デバイス情報の保存に失敗しました: $e');
    }
  }

  /// デバイス情報を取得
  ///
  /// 保存されていない場合はnullを返す
  Future<DeviceModel?> getDevice() async {
    try {
      final box = await Hive.openBox(_authBoxName);
      final deviceJson = box.get(_deviceKey) as Map<String, dynamic>?;
      if (deviceJson == null) {
        return null;
      }
      return DeviceModel.fromJson(Map<String, dynamic>.from(deviceJson));
    } catch (e) {
      throw CacheException(message: 'デバイス情報の取得に失敗しました: $e');
    }
  }

  /// デバイス情報を削除
  Future<void> clearDevice() async {
    try {
      final box = await Hive.openBox(_authBoxName);
      await box.delete(_deviceKey);
    } catch (e) {
      throw CacheException(message: 'デバイス情報の削除に失敗しました: $e');
    }
  }

  /// すべてのデータをクリア
  Future<void> clearAll() async {
    try {
      final box = await Hive.openBox(_authBoxName);
      await box.clear();
    } catch (e) {
      throw CacheException(message: 'データのクリアに失敗しました: $e');
    }
  }
}
