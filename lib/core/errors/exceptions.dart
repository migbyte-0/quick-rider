class ServerException implements Exception {
  final String message;
  final int? code;
  final int? remainingSeconds;

  ServerException(this.message, {this.code, this.remainingSeconds});

  @override
  String toString() =>
      'ServerException(code: $code, remaining: $remainingSeconds): $message';
}

class CacheException implements Exception {
  final String message;
  CacheException(this.message);
}
