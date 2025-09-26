import 'package:dartz/dartz.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:quickrider/core/errors/failures.dart';
import 'package:quickrider/core/usecase/usecase_params.dart';

import '../../../../core/usecase/usecase_no_params.dart';
import '../../../../services/logger_services.dart';
import '../domain_exports.dart';

class GetCurrentLocationUseCase implements UseCase<LatLng, NoParams> {
  final MapRepository repository;
  final AppLogger _logger;

  GetCurrentLocationUseCase(this.repository, {required AppLogger logger})
      : _logger = logger;

  @override
  Future<Either<Failure, LatLng>> call(NoParams params) async {
    _logger.i('UseCase: Executing GetCurrentLocationUseCase...');
    final result = await repository.getCurrentLocation();
    result.fold(
      (failure) =>
          _logger.e('UseCase: GetCurrentLocation failed: ${failure.message}'),
      (location) => _logger.d('UseCase: Got current location: $location'),
    );
    return result;
  }
}
