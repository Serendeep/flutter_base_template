import 'package:dio/dio.dart';
import 'package:flutter_base_template/utils/config/app_config.dart';
import 'package:flutter_base_template/utils/networking/url_provider.dart';
import 'package:flutter_base_template/utils/shared_prefs.dart';
import 'package:logger/logger.dart';
import 'package:flutter_base_template/core/error/app_error.dart';

class ApiClient {
  final Dio _dio;
  final Logger _logger;
  final int maxRetries;
  final URLProvider _urlProvider;

  ApiClient({this.maxRetries = AppConfig.maxRetries})
      : _dio = Dio(),
        _logger = Logger(),
        _urlProvider = URLProvider() {
    _initializeDio();
  }

  void _initializeDio() {
    _dio.options.baseUrl = getBaseUrl();
    _dio.options.connectTimeout =
        const Duration(milliseconds: AppConfig.connectTimeout);
    _dio.options.receiveTimeout =
        const Duration(milliseconds: AppConfig.receiveTimeout);
    _dio.options.sendTimeout =
        const Duration(milliseconds: AppConfig.sendTimeout);

    _dio.interceptors.addAll([
      _addHeadersInterceptor(),
      _logInterceptor(),
      _authInterceptor(),
    ]);
  }

  String getBaseUrl() {
    return AppConfig.baseUrl + AppConfig.apiPath;
  }

  InterceptorsWrapper _addHeadersInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        final accessToken = SharedPrefs().getString("accessToken");
        options.headers.addAll({
          ...AppConfig.headers,
          if (accessToken != null) "Authorization": "Bearer $accessToken",
        });
        handler.next(options);
      },
    );
  }

  InterceptorsWrapper _logInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) {
        if (AppConfig.shouldShowLogs) {
          final requestData = options.data;
          String dataDescription = '';
          if (requestData is FormData) {
            final formDataFields = requestData.fields
                .map((field) => '${field.key}: ${field.value}')
                .join(', ');
            final fileFields = requestData.files
                .map((file) => '${file.key}: File(${file.value.filename})')
                .join(', ');
            dataDescription =
                "FormData - Fields: {$formDataFields}, Files: {$fileFields}";
          } else {
            dataDescription = requestData.toString();
          }
          _logger.i("""
                Request:
                - Method: ${options.method}
                - URL: ${options.uri}
                - Headers: ${options.headers}
                - Body: $dataDescription
                """);
        }
        handler.next(options);
      },
      onResponse: (response, handler) {
        if (AppConfig.shouldShowLogs) {
          _logger.i("""
                  Response:
                  - Request Method: ${response.requestOptions.method}
                  - URL: ${response.requestOptions.uri}
                  - Status Code: ${response.statusCode}
                  - Data: ${response.data}
                  """);
        }
        handler.next(response);
      },
      onError: (error, handler) {
        if (AppConfig.shouldShowLogs) {
          AppError.create(
            message: 'Request failed',
            type: ErrorType.network,
            originalError: error,
            stackTrace: error.stackTrace,
          );
        }
        handler.next(error);
      },
    );
  }

  InterceptorsWrapper _authInterceptor() {
    return InterceptorsWrapper(
      onError: (DioException error, handler) async {
        if (error.response?.statusCode == 401) {
          final success = await _refreshToken();
          if (success) {
            _retryRequest(error.requestOptions, handler);
          } else {
            _logger.e("Failed to refresh token");
            handler.next(error);
          }
        } else {
          handler.next(error);
        }
      },
    );
  }

  Future<bool> _refreshToken() async {
    try {
      final refreshToken = SharedPrefs().getString("refreshToken");
      if (refreshToken == null) return false;

      final response = await _dio.post(
        _urlProvider.refreshTokenUrl,
        data: {"refreshToken": refreshToken},
      );

      if (response.statusCode == 200) {
        final newAccessToken = response.data['access_token'];
        await SharedPrefs().setString("accessToken", newAccessToken);
        return true;
      }
    } on DioException catch (e) {
      AppError.create(
        message: 'Failed to refresh token',
        type: ErrorType.authentication,
        originalError: e,
        stackTrace: e.stackTrace,
      );
    } catch (e) {
      AppError.create(
        message: 'Unexpected error during token refresh',
        type: ErrorType.unknown,
        originalError: e,
      );
    }
    return false;
  }

  void _retryRequest(
    RequestOptions requestOptions,
    ErrorInterceptorHandler handler,
  ) {
    int retries = requestOptions.extra['retries'] ?? 0;
    if (retries < maxRetries) {
      requestOptions.extra['retries'] = retries + 1;
      Future.delayed(
        const Duration(milliseconds: AppConfig.retryDelay),
        () => _dio.fetch(requestOptions).then(
          (response) => handler.resolve(response),
          onError: (e) {
            if (e is DioException) {
              AppError.create(
                message: 'Request retry failed',
                type: ErrorType.network,
                originalError: e,
                stackTrace: e.stackTrace,
              );
            }
            handler.reject(e);
          },
        ),
      );
    } else {
      AppError.create(
        message: 'Max retries reached for ${requestOptions.uri}',
        type: ErrorType.network,
      );
      handler.reject(
        DioException(
          requestOptions: requestOptions,
          error: "Max retries reached",
          type: DioExceptionType.unknown,
        ),
      );
    }
  }

  Future<Response<T>> get<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool requiresAuth = true,
  }) async {
    try {
      return await _dio.get<T>(
        endpoint,
        queryParameters: queryParameters,
        options: _mergeOptions(options, requiresAuth),
      );
    } on DioException catch (e) {
      throw AppError.create(
        message: 'GET request failed for $endpoint',
        type: ErrorType.network,
        originalError: e,
        stackTrace: e.stackTrace,
      );
    }
  }

  Future<Response<T>> post<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool requiresAuth = true,
  }) async {
    try {
      return await _dio.post<T>(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: _mergeOptions(options, requiresAuth),
      );
    } on DioException catch (e) {
      throw AppError.create(
        message: 'POST request failed for $endpoint',
        type: ErrorType.network,
        originalError: e,
        stackTrace: e.stackTrace,
      );
    }
  }

  Future<Response<T>> put<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool requiresAuth = true,
  }) async {
    try {
      return await _dio.put<T>(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: _mergeOptions(options, requiresAuth),
      );
    } on DioException catch (e) {
      throw AppError.create(
        message: 'PUT request failed for $endpoint',
        type: ErrorType.network,
        originalError: e,
        stackTrace: e.stackTrace,
      );
    }
  }

  Future<Response<T>> delete<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool requiresAuth = true,
  }) async {
    try {
      return await _dio.delete<T>(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: _mergeOptions(options, requiresAuth),
      );
    } on DioException catch (e) {
      throw AppError.create(
        message: 'DELETE request failed for $endpoint',
        type: ErrorType.network,
        originalError: e,
        stackTrace: e.stackTrace,
      );
    }
  }

  Future<Response<T>> patch<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool requiresAuth = true,
  }) async {
    try {
      return await _dio.patch<T>(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: _mergeOptions(options, requiresAuth),
      );
    } on DioException catch (e) {
      throw AppError.create(
        message: 'PATCH request failed for $endpoint',
        type: ErrorType.network,
        originalError: e,
        stackTrace: e.stackTrace,
      );
    }
  }

  Options _mergeOptions(Options? options, bool requiresAuth) {
    return (options ?? Options()).copyWith(
      extra: {
        ...options?.extra ?? {},
        'requiresAuth': requiresAuth,
      },
    );
  }
}
