class AppConstants {
  // API
  static const String baseUrl = 'https://dummyjson.com';
  static const String loginEndpoint = '/auth/login';
  static const String productsEndpoint = '/products';
  static const String postsEndpoint = '/posts';

  // Pagination
  static const int pageLimit = 10;

  // SharedPreferences Keys
  static const String userKey = 'cached_user';
  static const String themeModeKey = 'theme_mode';

  // Login credentials
  static const String defaultUsername = 'emilys';
  static const String defaultPassword = 'emilyspass';
}
