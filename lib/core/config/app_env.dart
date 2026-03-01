enum AppFlavor { dev, staging, prod }

class AppEnv {
  AppEnv._();

  static const _flavorRaw = String.fromEnvironment(
    'APP_FLAVOR',
    defaultValue: 'dev',
  );
  static const _baseUrlOverride = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: '',
  );

  static AppFlavor get flavor => switch (_flavorRaw) {
    'prod' => AppFlavor.prod,
    'staging' => AppFlavor.staging,
    _ => AppFlavor.dev,
  };

  static String get baseUrl {
    if (_baseUrlOverride.isNotEmpty) return _baseUrlOverride;

    return switch (flavor) {
      AppFlavor.dev => 'https://dummyjson.com',
      AppFlavor.staging => 'https://dummyjson.com',
      AppFlavor.prod => 'https://dummyjson.com',
    };
  }

  static String get flavorName => flavor.name;
}
