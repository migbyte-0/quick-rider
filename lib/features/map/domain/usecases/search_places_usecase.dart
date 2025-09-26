import 'package:dartz/dartz.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:quickrider/core/errors/failures.dart';
import 'package:quickrider/core/usecase/usecase_params.dart';
import 'package:quickrider/features/map/domain/domain_exports.dart';

import 'package:equatable/equatable.dart';

class SearchPlacesUseCase
    implements UseCase<List<PlaceDetails>, SearchPlacesParams> {
  final MapRepository repository;

  SearchPlacesUseCase(this.repository);

  @override
  Future<Either<Failure, List<PlaceDetails>>> call(
      SearchPlacesParams params) async {
    try {
      final places =
          await repository.searchPlaces(params.query, params.location);
      return Right(places);
    } on Failure catch (e) {
      return Left(e);
    }
  }
}

class SearchPlacesParams extends Equatable {
  final String query;
  final LatLng? location; // Optional: for biasing results

  const SearchPlacesParams({required this.query, this.location});

  @override
  List<Object?> get props => [query, location];
}
