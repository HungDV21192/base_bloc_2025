enum Environment { dev, prod }

class AppConfig {
  final String appName;
  final String baseUrl;
  final Environment environment;

  AppConfig({
    required this.appName,
    required this.baseUrl,
    required this.environment,
  });

  static late AppConfig instance;

  static void initialize(Environment env) {
    if (env == Environment.dev) {
      instance = AppConfig(
        appName: "MyApp Dev",
        baseUrl: "https://dev.api.example.com",
        environment: env,
      );
    } else {
      instance = AppConfig(
        appName: "MyApp",
        baseUrl: "https://api.example.com",
        environment: env,
      );
    }
  }
}
