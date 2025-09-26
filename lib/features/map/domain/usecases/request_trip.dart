import 'package:dartz/dartz.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:quickrider/core/errors/failures.dart';
import 'package:quickrider/features/map/domain/entities/car_type.dart';
import 'package:quickrider/features/map/domain/entities/payment_method.dart';
import 'package:quickrider/features/map/domain/entities/trip.dart';

import '../../../../core/usecase/usecase_params.dart';
import '../repository/map_repository_impl.dart';

import 'package:equatable/equatable.dart';

class RequestTripUseCase implements UseCase<Trip, RequestTripParams> {
  final MapRepository repository;

  RequestTripUseCase(this.repository);

  @override
  Future<Either<Failure, Trip>> call(RequestTripParams params) async {
    try {
      final trip = await repository.requestTrip(
        pickupLocation: params.pickupLocation,
        pickupAddress: params.pickupAddress,
        destinationLocation: params.destinationLocation,
        destinationAddress: params.destinationAddress,
        selectedCarType: params.selectedCarType,
        selectedPaymentMethod: params.selectedPaymentMethod,
      );
      return Right(trip);
    } on Failure catch (e) {
      return Left(e);
    }
  }
}

class RequestTripParams extends Equatable {
  final LatLng pickupLocation;
  final String pickupAddress;
  final LatLng destinationLocation;
  final String destinationAddress;
  final CarType selectedCarType;
  final PaymentMethod selectedPaymentMethod;

  const RequestTripParams({
    required this.pickupLocation,
    required this.pickupAddress,
    required this.destinationLocation,
    required this.destinationAddress,
    required this.selectedCarType,
    required this.selectedPaymentMethod,
  });

  @override
  List<Object> get props => [
        pickupLocation,
        pickupAddress,
        destinationLocation,
        destinationAddress,
        selectedCarType,
        selectedPaymentMethod,
      ];
}
