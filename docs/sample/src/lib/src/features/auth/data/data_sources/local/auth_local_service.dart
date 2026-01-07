
import 'package:hive/hive.dart';
import 'package:qrino_admin/src/features/auth/data/models/token_model.dart';


class AuthLocalService {
  static const String _boxName = 'authBox';
  static const String _tokenKey = 'authToken';

  // ボックスを開く（遅延初期化）
  Future<Box<TokenModel>> _openBox() async {
    try {
      return await Hive.openBox<TokenModel>(_boxName);
    } catch (e) {
      throw Exception('Failed to open Hive box: $e');
    }
  }

  // トークンを保存
  Future<void> saveToken(TokenModel token) async {
    try {
      final box = await _openBox();
      await box.put(_tokenKey, token);
    } catch (e) {
      throw Exception('Failed to save token: $e');
    }
  }

  // トークンを取得
  Future<TokenModel?> getToken() async {
    try {
      final box = await _openBox();
      return box.get(_tokenKey);
    } catch (e) {
      throw Exception('Failed to retrieve token: $e');
    }
  }

  // トークンを削除
  Future<void> clearToken() async {
    try {
      final box = await _openBox();
      await box.delete(_tokenKey);
    } catch (e) {
      throw Exception('Failed to clear token: $e');
    }
  }
}