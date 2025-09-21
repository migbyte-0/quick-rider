import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/util/validators.dart';
import '../repository/auth_repository.dart';

class SendOtp {
  final AuthRepository repository;
  SendOtp(this.repository);

  Future<Either<Failure, (String, int?)>> call({
    required String phoneNumber,
  }) async {
    final validationError = Validators.validatePhone(phoneNumber);

    if (validationError != null) {
      return Left(ValidationFailure(validationError));
    }

    return await repository.sendOtp(phoneNumber: phoneNumber);
  }
}
