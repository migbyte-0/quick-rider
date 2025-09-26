import 'package:dartz/dartz.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:quickrider/core/errors/failures.dart';
import 'package:quickrider/features/map/domain/entities/car_type.dart';

import '../../../../core/usecase/usecase_params.dart';
import '../repository/map_repository_impl.dart';
import 'package:equatable/equatable.dart';

class GetAvailableCarTypesUseCase
    implements UseCase<List<CarType>, GetAvailableCarTypesParams> {
  final MapRepository repository;

  GetAvailableCarTypesUseCase(this.repository);

  @override
  Future<Either<Failure, List<CarType>>> call(
      GetAvailableCarTypesParams params) async {
    try {
      final carTypes =
          await repository.getAvailableCarTypes(params.pickupLocation);
      return Right(carTypes);
    } on Failure catch (e) {
      return Left(e);
    }
  }
}

class GetAvailableCarTypesParams extends Equatable {
  final LatLng pickupLocation;

  const GetAvailableCarTypesParams({required this.pickupLocation});

  @override
  List<Object> get props => [pickupLocation];
}
