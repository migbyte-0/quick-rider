import 'package:dartz/dartz.dart';
import 'package:quickrider/core/errors/failures.dart';
import '../../../../core/usecase/usecase_no_params.dart';
import '../../../../core/usecase/usecase_params.dart';
import '../entities/credit_card_entity.dart';
import '../repository/payment_repository.dart';

class GetCreditCardsUseCase
    implements UseCase<List<CreditCardEntity>, NoParams> {
  final PaymentRepository repository;

  GetCreditCardsUseCase(this.repository);

  @override
  Future<Either<Failure, List<CreditCardEntity>>> call(NoParams params) async {
    return await repository.getCreditCards();
  }
}
