import 'package:dartz/dartz.dart';
import 'package:quickrider/core/errors/failures.dart';

import '../../../../core/usecase/usecase_params.dart';
import '../repository/payment_repository.dart';

class SetDefaultCreditCardUseCase implements UseCase<Unit, String> {
  final PaymentRepository repository;

  SetDefaultCreditCardUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(String cardId) async {
    return await repository.setDefaultCreditCard(cardId);
  }
}
