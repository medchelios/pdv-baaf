enum Environment {
  development,
  staging,
  production,
}

class EnvironmentConfig {
  static Environment _current = Environment.development;
  
  static Environment get current => _current;
  
  static void setEnvironment(Environment env) {
    _current = env;
  }
  
  // Configuration par environnement
  static String get baseUrl {
    switch (_current) {
      case Environment.development:
        return 'http://127.0.0.1:8001';
      case Environment.staging:
        return 'https://staging.baaf-payment-platform.com';
      case Environment.production:
        return 'https://api.baaf-payment-platform.com';
    }
  }
  
  static bool get isDevelopment => _current == Environment.development;
  static bool get isStaging => _current == Environment.staging;
  static bool get isProduction => _current == Environment.production;
  
  // Configuration de debug
  static bool get enableLogging => isDevelopment || isStaging;
  static bool get enableDebugPrint => isDevelopment;
}
