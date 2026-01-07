import 'package:dio/dio.dart';
import 'package:qrino_admin/src/core/constants/api_constants.dart';
import 'package:qrino_admin/src/core/error/exceptions.dart';
import 'package:qrino_admin/src/core/network/dio_client.dart';

class AuthApiService {
  final DioClient _dioClient;

  AuthApiService(this._dioClient);

  Future<void> login(String email, String password) async {
    try {
      await _dioClient.instance.post(
        ApiConstants.loginEndpoint,
        data: {
          'email': email,
          'password': password,
        },
      );
    } on DioException catch (e) {
      throw ServerException(message: e.response?.data['message'] ?? 'Login failed');
    }
  }

  Future<void> refreshToken() async {
    try {
      await _dioClient.instance.post(ApiConstants.refreshEndpoint);
    } on DioException catch (e) {
      throw ServerException(message: e.response?.data['message'] ?? 'Token refresh failed');
    }
  }
}