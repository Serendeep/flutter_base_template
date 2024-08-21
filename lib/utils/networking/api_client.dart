import 'package:dio/dio.dart';
import 'package:klackr_mobile/utils/networking/url_provider.dart';
import 'package:klackr_mobile/utils/shared_prefs.dart';
import 'package:logger/logger.dart';

class ApiClient {
  final Dio _dio;
  final Logger _logger;
  final int maxRetries;

  ApiClient({this.maxRetries = 3})
      : _dio = Dio(),
        _logger = Logger() {
    _initializeDio();
  }

  void _initializeDio() {
    _dio.options.baseUrl = URLProvider.baseUrl;
    _dio.interceptors.addAll([
      _addHeadersInterceptor(),
      _logInterceptor(),
      _authInterceptor(),
    ]);
  }

  InterceptorsWrapper _addHeadersInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        final accessToken = SharedPrefs().getString('accessToken');
        options.headers.addAll({
          "accept": "application/json",
          "Authorization": "Bearer $accessToken",
          "Content-Type": "application/json",
        });
        handler.next(options);
      },
    );
  }

  InterceptorsWrapper _logInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) {
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
        handler.next(options);
      },
      onResponse: (response, handler) {
        _logger.i("""
                  Response:
                  - Request Method: ${response.requestOptions.method}
                  - URL: ${response.requestOptions.uri}
                  - Status Code: ${response.statusCode}
                  - Data: ${response.data}
                  """);
        handler.next(response);
      },
      onError: (error, handler) {
        _logger.e("Request failed: ${error.response}");
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
            _logger.e("Failed to refresh token, redirecting to login.");
          }
        } else {
          handler.next(error);
        }
      },
    );
  }

  Future<bool> _refreshToken() async {
    // try {
    //   final refreshToken =
    //       SharedPrefs().getString(SharedPrefs.refreshToken);
    //   final response = await Dio().post(URLProvider.refreshTokenUrl,
    //       data: {"refreshToken": refreshToken});
    //   if (response.statusCode == 200) {
    //     final newAccessToken = response.data['access_token'];
    //     await SharedPrefs()
    //         .setString(SharedPrefs.accessToken, newAccessToken);
    //     return true;
    //   }
    // } catch (e) {
    //   _logger.e("Error refreshing token: $e");
    // }
    return await _refreshTokenLogin();
  }

  Future<bool> _refreshTokenLogin() async {
    // try {
    // final username = SharedPrefs().getString(SharedPrefs.userEmail);
    // final password = SharedPrefs().getString(SharedPrefs.userPassword);
    // final response = await _dio.post(URLProvider.loginUrl,
    //     data: FormData.fromMap(
    //         {"username": username, "password": password, 'role': 4}));
    // if (response.statusCode == 200) {
    //   await SharedPrefs()
    //       .setString(SharedPrefs.accessToken, response.data['access_token']);
    //   await SharedPrefs().setString(
    //       SharedPrefs.refreshToken, response.data['refresh_token']);
    //     return true;
    //   }
    // } catch (e) {
    //   _logger.e("Error during login for token refresh: $e");
    //   AppRouter.parentNavigatorKey.currentState?.pushNamed(Routes.signIn);
    // }
    return false;
  }

  void _retryRequest(
      RequestOptions requestOptions, ErrorInterceptorHandler handler) {
    int retries = requestOptions.extra['retries'] ?? 0;
    if (retries < maxRetries) {
      requestOptions.extra['retries'] = retries + 1;
      _dio.fetch(requestOptions).then(
            (response) => handler.resolve(response),
            onError: (e) => handler.reject(e),
          );
    } else {
      _logger.e("Max retries reached for ${requestOptions.uri}");
      handler.reject(DioException(
        requestOptions: requestOptions,
        response: null,
        type: DioExceptionType.unknown,
        error: "Max retries reached",
      ));
    }
  }

  Future<Response> getData(
      {required String url, Map<String, dynamic>? queryParams}) async {
    return _dio.get(url, queryParameters: queryParams);
  }

  Future<Response> postData(
      {required String url,
      dynamic data,
      Map<String, dynamic>? queryParams}) async {
    return _dio.post(url, data: data, queryParameters: queryParams);
  }

  Future<Response> putData(
      {required String url,
      dynamic data,
      Map<String, dynamic>? queryParams}) async {
    return _dio.put(url, data: data, queryParameters: queryParams);
  }
}
