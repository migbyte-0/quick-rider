import 'package:dartz/dartz.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:quickrider/core/errors/failures.dart';
import 'package:quickrider/core/usecase/usecase_params.dart';
import 'package:quickrider/features/map/domain/entities/trip.dart' show Driver;

import '../domain_exports.dart';

import 'package:equatable/equatable.dart';

class GetNearbyDriversUseCase
    implements UseCase<List<Driver>, GetNearbyDriversParams> {
  final MapRepository repository;

  GetNearbyDriversUseCase(this.repository);

  @override
  Future<Either<Failure, List<Driver>>> call(
      GetNearbyDriversParams params) async {
    try {
      final drivers = await repository.getNearbyDrivers(params.currentLocation);
      return Right(drivers);
    } on Failure catch (e) {
      return Left(e);
    }
  }
}

class GetNearbyDriversParams extends Equatable {
  final LatLng currentLocation;

  const GetNearbyDriversParams({required this.currentLocation});

  @override
  List<Object> get props => [currentLocation];
}
