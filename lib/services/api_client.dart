import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../shared/utils/constants.dart';
import 'storage_service.dart';

class MedoqException implements Exception {
  final String message;
  final int? statusCode;
  final String? code;

  const MedoqException({
    required this.message,
    this.statusCode,
    this.code,
  });

  @override
  String toString() => 'MedoqException: $message (status: $statusCode)';
}

class ApiClient {
  late final Dio _dio;
  bool _isRefreshing = false;

  ApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.apiBaseUrl,
        connectTimeout: AppConstants.connectTimeout,
        receiveTimeout: AppConstants.apiTimeout,
        sendTimeout: AppConstants.apiTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'X-Platform': 'mobile',
          'X-App-Version': '1.0.0',
        },
      ),
    );

    _setupInterceptors();
  }

  void _setupInterceptors() {
    // Auth interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await StorageService.getAccessToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401 && !_isRefreshing) {
            _isRefreshing = true;
            try {
              final refreshToken = await StorageService.getRefreshToken();
              if (refreshToken == null) {
                _isRefreshing = false;
                handler.next(error);
                return;
              }

              final response = await _dio.post(
                ApiEndpoints.refreshToken,
                data: {'refresh_token': refreshToken},
                options: Options(
                  headers: {'Authorization': null},
                ),
              );

              final newAccessToken =
                  response.data['access_token'] as String;
              final newRefreshToken =
                  response.data['refresh_token'] as String?;

              await StorageService.saveAccessToken(newAccessToken);
              if (newRefreshToken != null) {
                await StorageService.saveRefreshToken(newRefreshToken);
              }

              // Retry original request
              final opts = error.requestOptions;
              opts.headers['Authorization'] = 'Bearer $newAccessToken';
              final retryResponse = await _dio.fetch(opts);
              _isRefreshing = false;
              handler.resolve(retryResponse);
            } catch (e) {
              _isRefreshing = false;
              await StorageService.clearAll();
              handler.next(error);
            }
          } else {
            handler.next(error);
          }
        },
      ),
    );

    // Logging interceptor (debug only)
    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          requestHeader: false,
          responseHeader: false,
          error: true,
          logPrint: (obj) => debugPrint('[MEDOQ API] $obj'),
        ),
      );
    }
  }

  // ───── HTTP Methods ─────

  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.get<dynamic>(
        path,
        queryParameters: queryParameters,
        options: options,
      );
      return response.data as T;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<T> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.post<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response.data as T;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<T> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.put<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response.data as T;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<T> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.delete<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response.data as T;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  MedoqException _handleDioError(DioException error) {
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout) {
      return const MedoqException(
        message: 'Délai de connexion dépassé. Vérifiez votre connexion.',
        code: 'timeout',
      );
    }

    if (error.type == DioExceptionType.connectionError) {
      return const MedoqException(
        message: 'Impossible de se connecter. Vérifiez votre connexion internet.',
        code: 'no_connection',
      );
    }

    final response = error.response;
    if (response == null) {
      return MedoqException(message: error.message ?? 'Erreur inconnue');
    }

    final statusCode = response.statusCode;
    final data = response.data;
    String message = 'Une erreur est survenue';
    String? code;

    if (data is Map<String, dynamic>) {
      message = data['message'] as String? ??
          data['error'] as String? ??
          message;
      code = data['code'] as String?;
    }

    switch (statusCode) {
      case 400:
        return MedoqException(
            message: message, statusCode: statusCode, code: code ?? 'bad_request');
      case 401:
        return MedoqException(
            message: 'Session expirée. Veuillez vous reconnecter.',
            statusCode: statusCode,
            code: 'unauthorized');
      case 403:
        return MedoqException(
            message: 'Accès refusé.',
            statusCode: statusCode,
            code: code ?? 'forbidden');
      case 404:
        return MedoqException(
            message: 'Ressource introuvable.',
            statusCode: statusCode,
            code: code ?? 'not_found');
      case 422:
        return MedoqException(
            message: message,
            statusCode: statusCode,
            code: code ?? 'validation_error');
      case 429:
        return MedoqException(
            message: 'Trop de tentatives. Réessayez dans quelques instants.',
            statusCode: statusCode,
            code: 'rate_limit');
      case 500:
      case 502:
      case 503:
        return MedoqException(
            message: 'Erreur du serveur. Veuillez réessayer.',
            statusCode: statusCode,
            code: code ?? 'server_error');
      default:
        return MedoqException(
            message: message, statusCode: statusCode, code: code);
    }
  }
}

// Singleton instance
final apiClient = ApiClient();
