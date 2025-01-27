import 'dart:io' show Platform;

enum Flavor {
  development,
  staging,
  production,
}

class FlavorValues {
  final String baseUrl;
  final String appTitle;
  final bool enableLogging;
  final Map<String, String> apiKeys;

  FlavorValues({
    String? baseUrl,
    String? appTitle,
    bool? enableLogging,
    Map<String, String>? apiKeys,
  })  : baseUrl = baseUrl ??
            Platform.environment['API_BASE_URL'] ??
            'https://api.example.com',
        appTitle = appTitle ?? Platform.environment['APP_TITLE'] ?? 'App',
        enableLogging = enableLogging ??
            Platform.environment['ENABLE_LOGGING']?.toLowerCase() == 'true',
        apiKeys = apiKeys ??
            {
              'analytics': Platform.environment['ANALYTICS_KEY'] ?? '',
              'maps': Platform.environment['MAPS_KEY'] ?? '',
              'supabase_url': Platform.environment['SUPABASE_URL'] ?? '',
              'supabase_anonKey':
                  Platform.environment['SUPABASE_ANON_KEY'] ?? '',
              // Add other API keys as needed
            };

  factory FlavorValues.development() => FlavorValues(
        baseUrl: Platform.environment['DEV_API_BASE_URL'],
        appTitle: 'App Dev',
        enableLogging: true,
      );

  factory FlavorValues.staging() => FlavorValues(
        baseUrl: Platform.environment['STAGING_API_BASE_URL'],
        appTitle: 'App Staging',
        enableLogging: true,
      );

  factory FlavorValues.production() => FlavorValues(
        baseUrl: Platform.environment['PROD_API_BASE_URL'],
        appTitle: 'App',
        enableLogging: false,
      );
}

class FlavorConfig {
  final Flavor flavor;
  final FlavorValues values;
  static FlavorConfig? _instance;

  factory FlavorConfig({
    required Flavor flavor,
    FlavorValues? values,
  }) {
    _instance ??= FlavorConfig._internal(
      flavor,
      values ?? _getFlavorValues(flavor),
    );
    return _instance!;
  }

  FlavorConfig._internal(this.flavor, this.values);

  static FlavorConfig get instance {
    assert(_instance != null, 'FlavorConfig must be initialized first');
    return _instance!;
  }

  static FlavorValues _getFlavorValues(Flavor flavor) {
    switch (flavor) {
      case Flavor.development:
        return FlavorValues.development();
      case Flavor.staging:
        return FlavorValues.staging();
      case Flavor.production:
        return FlavorValues.production();
    }
  }

  static bool isProduction() => _instance?.flavor == Flavor.production;
  static bool isDevelopment() => _instance?.flavor == Flavor.development;
  static bool isStaging() => _instance?.flavor == Flavor.staging;

  static String getApiKey(String service) {
    assert(_instance != null, 'FlavorConfig must be initialized first');
    final key = _instance!.values.apiKeys[service];
    assert(key != null, 'API key for $service not found in current flavor');
    return key!;
  }
}
