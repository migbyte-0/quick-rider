import 'package:dartz/dartz.dart';
import 'package:quickrider/core/errors/failures.dart';
import 'package:quickrider/features/map/domain/entities/trip.dart';

import '../../../../core/usecase/usecase_params.dart';
import '../domain_exports.dart';

import 'package:equatable/equatable.dart';

class ListenToTripUpdatesUseCase
    implements UseCase<Stream<Trip>, ListenToTripUpdatesParams> {
  final MapRepository repository;

  ListenToTripUpdatesUseCase(this.repository);

  @override
  Future<Either<Failure, Stream<Trip>>> call(
      ListenToTripUpdatesParams params) async {
    try {
      final tripStream = repository.listenToTripUpdates(params.tripId);
      return Right(tripStream);
    } on Failure catch (e) {
      return Left(e);
    }
  }
}

class ListenToTripUpdatesParams extends Equatable {
  final String tripId;

  const ListenToTripUpdatesParams({required this.tripId});

  @override
  List<Object> get props => [tripId];
}
