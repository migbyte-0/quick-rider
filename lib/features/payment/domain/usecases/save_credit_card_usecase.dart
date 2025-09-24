import 'package:dartz/dartz.dart';
import 'package:quickrider/core/errors/failures.dart';

import '../entities/credit_card_entity.dart';
import '../repository/payment_repository.dart';

class SaveCreditCardUseCase {
  final PaymentRepository repository;

  SaveCreditCardUseCase(this.repository);

  Future<Either<Failure, void>> call(CreditCardEntity card) async {
    return await repository.saveCreditCard(card);
  }
}
