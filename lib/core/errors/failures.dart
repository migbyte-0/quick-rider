import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final int? code;
  final int? remainingSeconds;

  const Failure(this.message, {this.code, this.remainingSeconds});

  @override
  List<Object?> get props => [message, code, remainingSeconds];
}

class ServerFailure extends Failure {
  const ServerFailure(super.message, {super.code, super.remainingSeconds});
}

class CacheFailure extends Failure {
  const CacheFailure(super.message, {super.code});
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

class InvalidCredentialsFailure extends Failure {
  const InvalidCredentialsFailure(super.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}
