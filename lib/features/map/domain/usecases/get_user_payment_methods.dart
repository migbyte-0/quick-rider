import 'package:dartz/dartz.dart';
import 'package:quickrider/core/errors/failures.dart';
import 'package:quickrider/core/usecase/usecase_no_params.dart'; // NoParams for this one
import 'package:quickrider/services/logger_services.dart';
import 'package:quickrider/features/map/domain/entities/payment_method.dart';

import '../../../../core/usecase/usecase_params.dart';
import '../repository/map_repository_impl.dart';

class GetUserPaymentMethodsUseCase
    implements UseCase<List<PaymentMethod>, NoParams> {
  final MapRepository repository;
  final AppLogger _logger;

  GetUserPaymentMethodsUseCase(this.repository, this._logger);

  @override
  Future<Either<Failure, List<PaymentMethod>>> call(NoParams params) async {
    _logger.i('UseCase: Getting user payment methods.');
    return await repository.getUserPaymentMethods();
  }
}
