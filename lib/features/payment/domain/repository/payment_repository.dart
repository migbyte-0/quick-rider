import 'package:dartz/dartz.dart';
import 'package:quickrider/core/errors/failures.dart';

import '../entities/credit_card_entity.dart';

abstract class PaymentRepository {
  Future<Either<Failure, List<CreditCardEntity>>> getCreditCards();
  Future<Either<Failure, Unit>> saveCreditCard(CreditCardEntity card);
  Future<Either<Failure, Unit>> setDefaultCreditCard(String cardId);
  Future<Either<Failure, Unit>> removeCreditCard(String cardId);
}
