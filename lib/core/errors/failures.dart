abstract class Failure {
  final String message;
  final int? code;
  final int? remainingSeconds;

  const Failure(this.message, {this.code, this.remainingSeconds});
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
