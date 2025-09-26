import 'package:dartz/dartz.dart';
import 'package:quickrider/core/errors/failures.dart';
import 'package:quickrider/services/logger_services.dart';

import '../../../../core/usecase/usecase_params.dart';
import '../entities/place_entity.dart';
import '../repository/map_repository_impl.dart';

// Assuming UseCase and UseCaseParams are defined here

class GetPlaceDetailsUseCase
    implements UseCase<PlaceDetails, GetPlaceDetailsParams> {
  // <--- CORRECTED: Changed LatLng to PlaceDetails
  final MapRepository repository;
  final AppLogger _logger;

  GetPlaceDetailsUseCase(this.repository, this._logger);

  @override
  Future<Either<Failure, PlaceDetails>> call(
      GetPlaceDetailsParams params) async {
    // <--- CORRECTED: Changed LatLng to PlaceDetails
    _logger.i('UseCase: Getting place details for placeId: ${params.placeId}');
    return await repository.getPlaceDetails(params.placeId);
  }
}

class GetPlaceDetailsParams {
  final String placeId;

  const GetPlaceDetailsParams({required this.placeId});
}
