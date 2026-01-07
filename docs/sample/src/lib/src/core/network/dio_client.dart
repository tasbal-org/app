import 'package:dio/dio.dart';
import 'package:qrino_admin/src/core/di/injection.dart'; 
import 'package:qrino_admin/src/config/environment.dart';
import 'package:qrino_admin/src/core/constants/api_constants.dart';
import 'package:qrino_admin/src/features/auth/data/repositories/auth_repository.dart';

class DioClient {
  final Dio _dio;

  DioClient() : _dio = Dio(BaseOptions(
        baseUrl: Environment.baseUrl,
        connectTimeout: const Duration(milliseconds: ApiConstants.connectTimeout),
        receiveTimeout: const Duration(milliseconds: ApiConstants.receiveTimeout),
        contentType: 'application/json',
        extra: {
          'withCredentials': true,
        }
      ),) {
    _dio.interceptors.add(InterceptorsWrapper(
      onError: (DioException e, ErrorInterceptorHandler handler) async {
        if (e.response?.statusCode == 401) {
          // Access token expired
          final authRepository = sl<AuthRepository>(); // Now sl is defined
          final result = await authRepository.refreshToken();
          return result.fold(
            (failure) => handler.reject(e), // Refresh failed
            (_) async {
              // Refresh succeeded, retry the original request
              final options = e.requestOptions;
              final response = await _dio.request(
                options.path,
                data: options.data,
                queryParameters: options.queryParameters,
                options: Options(
                  method: options.method,
                  headers: options.headers,
                ),
              );
              return handler.resolve(response);
            },
          );
        }
        return handler.next(e);
      },
    ));
  }

  Dio get instance => _dio;
}