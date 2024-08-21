enum Environment { dev, prod }

class AppConfig {
  static Environment environment = Environment.dev;

  static String get baseUrl {
    switch (environment) {
      case Environment.prod:
        return "";
      case Environment.dev:
      default:
        return "";
    }
  }
}
