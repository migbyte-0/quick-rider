import 'package:equatable/equatable.dart';

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

class LocationException extends Equatable implements Exception {
  final String message;

  const LocationException(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'LocationException: $message';
}
