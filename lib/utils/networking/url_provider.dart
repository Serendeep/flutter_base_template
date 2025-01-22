import 'package:flutter_base_template/utils/config/app_config.dart';
import 'package:flutter_base_template/utils/config/flavor_config.dart';

class URLProvider {
  static final URLProvider _instance = URLProvider._internal();

  factory URLProvider() {
    return _instance;
  }

  URLProvider._internal();

  String get baseUrl => FlavorConfig.instance.values.baseUrl;

  // API Endpoints
  String get homeEndpoint => '${AppConfig.apiPath}/home';
  String get userEndpoint => '${AppConfig.apiPath}/user';
  String get authEndpoint => '${AppConfig.apiPath}/auth';

  // Auth URLs
  String get loginUrl => '$authEndpoint/login';
  String get registerUrl => '$authEndpoint/register';
  String get refreshTokenUrl => '$authEndpoint/refresh';
  String get logoutUrl => '$authEndpoint/logout';

  // User URLs
  String get userProfileUrl => '$userEndpoint/profile';
  String updateUserUrl(String userId) => '$userEndpoint/$userId';

  // Home URLs
  String get homeDataUrl => '$homeEndpoint/data';
  String get homeSettingsUrl => '$homeEndpoint/settings';
  String homeItemUrl(String itemId) => '$homeEndpoint/items/$itemId';

  // Helper methods for building URLs
  String addQueryParams(String url, Map<String, dynamic>? params) {
    if (params == null || params.isEmpty) return url;

    final uri = Uri.parse(url);
    final queryParams = Map<String, dynamic>.from(uri.queryParameters)
      ..addAll(params);

    return uri.replace(queryParameters: queryParams).toString();
  }

  String addPathSegments(String url, List<String> segments) {
    final uri = Uri.parse(url);
    final pathSegments = List<String>.from(uri.pathSegments)..addAll(segments);

    return uri.replace(pathSegments: pathSegments).toString();
  }
}
