import 'package:dio/dio.dart';
import 'package:flutter_base_template/utils/config/app_config.dart';
import 'package:flutter_base_template/utils/networking/url_provider.dart';
import 'package:flutter_base_template/utils/shared_prefs.dart';
import 'package:logger/logger.dart';

class ApiClient {
  final Dio _dio;
  final Logger _logger;
  final int maxRetries;
  final URLProvider _urlProvider;

  ApiClient({this.maxRetries = 3})
      : _dio = Dio(),
        _logger = Logger(),
        _urlProvider = URLProvider() {
    _initializeDio();
  }

  void _initializeDio() {
    _dio.options.baseUrl = _urlProvider.baseUrl;
    _dio.interceptors.addAll([
      _addHeadersInterceptor(),
      _logInterceptor(),
      _authInterceptor(),
    ]);
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
          _logger.e("Request failed");
          _logger.e("Request URL: ${error.requestOptions.uri}");
          _logger.e("Error message: ${error.message}");
          _logger.e("Stack trace: ${error.stackTrace}");
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
    } catch (e) {
      _logger.e("Error refreshing token");
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
      _dio.fetch(requestOptions).then(
            (response) => handler.resolve(response),
            onError: (e) => handler.reject(e),
          );
    } else {
      _logger.e("Max retries reached for ${requestOptions.uri}");
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
    return _dio.get<T>(
      endpoint,
      queryParameters: queryParameters,
      options: _mergeOptions(options, requiresAuth),
    );
  }

  Future<Response<T>> post<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool requiresAuth = true,
  }) async {
    return _dio.post<T>(
      endpoint,
      data: data,
      queryParameters: queryParameters,
      options: _mergeOptions(options, requiresAuth),
    );
  }

  Future<Response<T>> put<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool requiresAuth = true,
  }) async {
    return _dio.put<T>(
      endpoint,
      data: data,
      queryParameters: queryParameters,
      options: _mergeOptions(options, requiresAuth),
    );
  }

  Future<Response<T>> delete<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool requiresAuth = true,
  }) async {
    return _dio.delete<T>(
      endpoint,
      data: data,
      queryParameters: queryParameters,
      options: _mergeOptions(options, requiresAuth),
    );
  }

  Future<Response<T>> patch<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool requiresAuth = true,
  }) async {
    return _dio.patch<T>(
      endpoint,
      data: data,
      queryParameters: queryParameters,
      options: _mergeOptions(options, requiresAuth),
    );
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
