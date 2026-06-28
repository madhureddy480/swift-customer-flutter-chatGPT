enum AppEnvironment {
  dev,
  test,
  uat,
  prod;

  static AppEnvironment fromString(String value) {
    return AppEnvironment.values.firstWhere(
      (env) => env.name == value,
      orElse: () => AppEnvironment.dev,
    );
  }
}

class AppConfig {
  const AppConfig({
    required this.environment,
    required this.apiBaseUrl,
    required this.appName,
  });

  final AppEnvironment environment;
  final String apiBaseUrl;
  final String appName;

  bool get isProduction => environment == AppEnvironment.prod;

  static AppConfig fromEnvironment() {
    const envName = String.fromEnvironment('ENV', defaultValue: 'dev');
    final environment = AppEnvironment.fromString(envName);

    return AppConfig(
      environment: environment,
      apiBaseUrl: _apiBaseUrlFor(environment),
      appName: 'Dr Swift Diagnostics',
    );
  }

  static String _apiBaseUrlFor(AppEnvironment environment) {
    return switch (environment) {
      AppEnvironment.dev => 'https://test-api-customer.drswift.in',
      AppEnvironment.test => 'https://test-api-customer.drswift.in',
      AppEnvironment.uat => 'https://uat-api-customer.drswift.in',
      AppEnvironment.prod => 'https://api.drswift.in',
    };
  }
}
