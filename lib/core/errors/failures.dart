abstract class Failure {
  final String message;
  const Failure(this.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure([String message = 'No internet connection. Please check your network.'])
      : super(message);
}

class ServerFailure extends Failure {
  const ServerFailure([String message = 'Server error. Please try again later.'])
      : super(message);
}

class CacheFailure extends Failure {
  const CacheFailure([String message = 'Cache error occurred.']) : super(message);
}

class AuthFailure extends Failure {
  const AuthFailure([String message = 'Invalid credentials. Please try again.'])
      : super(message);
}

class UnknownFailure extends Failure {
  const UnknownFailure([String message = 'An unexpected error occurred.']) : super(message);
}

// Exceptions
class NetworkException implements Exception {
  final String message;
  NetworkException([this.message = 'No internet connection.']);
}

class ServerException implements Exception {
  final String message;
  final int? statusCode;
  ServerException({this.message = 'Server error.', this.statusCode});
}

class CacheException implements Exception {
  final String message;
  CacheException([this.message = 'Cache error.']);
}

class AuthException implements Exception {
  final String message;
  AuthException([this.message = 'Authentication failed.']);
}
