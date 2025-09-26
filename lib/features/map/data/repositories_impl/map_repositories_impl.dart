import 'package:dartz/dartz.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:quickrider/core/errors/exceptions.dart';
import 'package:quickrider/core/errors/failures.dart';
import 'package:quickrider/features/map/data/datasources/map_remote_data_source.dart';
import 'package:quickrider/features/map/domain/domain_exports.dart';

import '../../../../services/logger_services.dart';

import 'package:quickrider/core/network/network_info.dart'; // Need this if you're checking network connection
import 'package:quickrider/features/map/domain/entities/car_type.dart';
import 'package:quickrider/features/map/domain/entities/payment_method.dart';
import 'package:quickrider/features/map/domain/entities/trip.dart';

import 'dart:async';

import '../models/place_details_model.dart';

class MapRepositoryImpl implements MapRepository {
  final MapRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;
  final AppLogger logger; // <--- Inject AppLogger here

  MapRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
    required this.logger, // <--- Add logger to constructor
  });

  @override
  Future<List<PlaceDetails>> searchPlaces(
      String query, LatLng? location) async {
    logger.i(
        'Repository: Searching places for query: "$query"...'); // <--- Use injected logger
    if (await networkInfo.isConnected) {
      try {
        final remotePlaces =
            await remoteDataSource.searchPlaces(query, location);
        logger.d(
            'Repository: Successfully found ${remotePlaces.length} places.'); // <--- Use injected logger
        return remotePlaces; // PlaceModel extends Place, so it's fine
      } on ServerException catch (e, st) {
        logger.e(
            'Repository: Server error during place search: ${e.message}', // <--- Use injected logger
            error: e,
            stackTrace: st);
        throw ServerFailure(e.message);
      }
    } else {
      logger.w(
          'Repository: No internet connection for place search.'); // <--- Use injected logger
      throw const NoInternetFailure();
    }
  }

  @override
  Future<List<Driver>> getNearbyDrivers(LatLng currentLocation) async {
    logger.i(
        'Repository: Fetching nearby drivers...'); // <--- Use injected logger
    if (await networkInfo.isConnected) {
      try {
        final remoteDrivers =
            await remoteDataSource.getNearbyDrivers(currentLocation);
        logger.d(
            'Repository: Successfully fetched ${remoteDrivers.length} drivers.'); // <--- Use injected logger
        return remoteDrivers; // DriverModel extends Driver, so it's fine
      } on ServerException catch (e, st) {
        logger.e(
            'Repository: Server error during driver fetch: ${e.message}', // <--- Use injected logger
            error: e,
            stackTrace: st);
        throw ServerFailure(e.message);
      }
    } else {
      logger.w(
          'Repository: No internet connection for fetching drivers.'); // <--- Use injected logger
      throw const NoInternetFailure();
    }
  }

  @override
  Future<List<CarType>> getAvailableCarTypes(LatLng pickupLocation) async {
    logger.i(
        'Repository: Fetching available car types...'); // <--- Use injected logger
    if (await networkInfo.isConnected) {
      try {
        final remoteCarTypes =
            await remoteDataSource.getAvailableCarTypes(pickupLocation);
        logger.d(
            'Repository: Successfully fetched ${remoteCarTypes.length} car types.'); // <--- Use injected logger
        return remoteCarTypes;
      } on ServerException catch (e, st) {
        logger.e(
            'Repository: Server error fetching car types: ${e.message}', // <--- Use injected logger
            error: e,
            stackTrace: st);
        throw ServerFailure(e.message);
      }
    } else {
      logger.w(
          'Repository: No internet connection for fetching car types.'); // <--- Use injected logger
      throw const NoInternetFailure();
    }
  }

  @override
  Future<Either<Failure, List<PaymentMethod>>> getUserPaymentMethods() async {
    logger.i('Repository: Fetching user payment methods...');
    if (await networkInfo.isConnected) {
      try {
        final remotePaymentMethods =
            await remoteDataSource.getUserPaymentMethods();
        logger.d(
            'Repository: Successfully fetched ${remotePaymentMethods.length} payment methods.');
        return Right(remotePaymentMethods); // <--- Wrapped in Right
      } on ServerException catch (e, st) {
        logger.e(
            'Repository: Server error fetching payment methods: ${e.message}',
            error: e,
            stackTrace: st);
        return Left(ServerFailure(e.message)); // <--- Wrapped in Left
      } catch (e, st) {
        logger.e(
            'Repository: Unexpected error fetching payment methods: ${e.toString()}',
            error: e,
            stackTrace: st);
        return Left(UnknownFailure(e.toString()));
      }
    } else {
      logger.w(
          'Repository: No internet connection for fetching payment methods.');
      return const Left(NoInternetFailure()); // <--- Wrapped in Left
    }
  }

  @override
  Future<Either<Failure, PaymentMethod>> addPaymentMethod() async {
    logger.i('Repository: Adding new payment method...');
    if (await networkInfo.isConnected) {
      try {
        final newPaymentMethod = await remoteDataSource.addPaymentMethod();
        logger.d('Repository: Successfully added a new payment method.');
        return Right(newPaymentMethod); // <--- Wrapped in Right
      } on ServerException catch (e, st) {
        logger.e('Repository: Server error adding payment method: ${e.message}',
            error: e, stackTrace: st);
        return Left(ServerFailure(e.message)); // <--- Wrapped in Left
      } catch (e, st) {
        logger.e(
            'Repository: Unexpected error adding payment method: ${e.toString()}',
            error: e,
            stackTrace: st);
        return Left(UnknownFailure(e.toString()));
      }
    } else {
      logger.w('Repository: No internet connection for adding payment method.');
      return const Left(NoInternetFailure()); // <--- Wrapped in Left
    }
  }

  // Your getCurrentLocation and getPlaceDetails are already correctly returning Either
  @override
  Future<Either<Failure, LatLng>> getCurrentLocation() async {
    logger.i('Repository: Attempting to get current location...');
    if (await networkInfo.isConnected) {
      try {
        final LatLng location = await remoteDataSource.getCurrentLocation();
        logger.d(
            'Repository: Successfully retrieved current location: $location');
        return Right(location);
      } on ServerException catch (e, st) {
        logger.e(
            'Repository: Server error getting current location: ${e.message}',
            error: e,
            stackTrace: st);
        return Left(ServerFailure(e.message));
      } on LocationException catch (e, st) {
        logger.e(
            'Repository: Location service error getting current location: ${e.message}',
            error: e,
            stackTrace: st);
        return Left(LocationFailure(e.message));
      } catch (e, st) {
        logger.e(
            'Repository: Unexpected error getting current location: ${e.toString()}',
            error: e,
            stackTrace: st);
        return Left(UnknownFailure(e.toString()));
      }
    } else {
      logger.w(
          'Repository: No internet connection for getting current location.');
      return const Left(NoInternetFailure());
    }
  }

  @override
  Future<Either<Failure, PlaceDetails>> getPlaceDetails(String placeId) async {
    logger.i('Repository: Fetching details for placeId: $placeId...');
    if (await networkInfo.isConnected) {
      try {
        final PlaceDetailsModel placeDetailsModel =
            await remoteDataSource.getPlaceDetails(placeId);
        logger.d(
            'Repository: Successfully fetched details for place: ${placeDetailsModel.name}');
        return Right(placeDetailsModel);
      } on ServerException catch (e, st) {
        logger.e(
            'Repository: Server error getting place details for ID $placeId: ${e.message}',
            error: e,
            stackTrace: st);
        return Left(ServerFailure(e.message));
      } catch (e, st) {
        logger.e(
            'Repository: Unexpected error getting place details for ID $placeId: ${e.toString()}',
            error: e,
            stackTrace: st);
        return Left(UnknownFailure(e.toString()));
      }
    } else {
      logger.w('Repository: No internet connection for getting place details.');
      return const Left(NoInternetFailure());
    }
  }

  @override
  Future<Trip> requestTrip({
    required LatLng pickupLocation,
    required String pickupAddress,
    required LatLng destinationLocation,
    required String destinationAddress,
    required CarType selectedCarType,
    required PaymentMethod selectedPaymentMethod,
  }) async {
    logger.i('Repository: Requesting trip...'); // <--- Use injected logger
    if (await networkInfo.isConnected) {
      try {
        final tripToRequest = Trip(
          id: '', // ID will be assigned by the backend
          pickupLocation: pickupLocation,
          pickupAddress: pickupAddress,
          destinationLocation: destinationLocation,
          destinationAddress: destinationAddress,
          selectedCarType: selectedCarType,
          selectedPaymentMethod: selectedPaymentMethod,
          status: TripStatus.selectingCar, // Initial status
        );
        final newTrip = await remoteDataSource.requestTrip(tripToRequest);
        logger.d(
            'Repository: Trip requested, received ID: ${newTrip.id}'); // <--- Use injected logger
        return newTrip;
      } on ServerException catch (e, st) {
        logger.e(
            'Repository: Server error requesting trip: ${e.message}', // <--- Use injected logger
            error: e,
            stackTrace: st);
        throw ServerFailure(e.message);
      }
    } else {
      logger.w(
          'Repository: No internet connection for requesting trip.'); // <--- Use injected logger
      throw const NoInternetFailure();
    }
  }

  @override
  Stream<Trip> listenToTripUpdates(String tripId) {
    logger.i(
        'Repository: Listening to trip updates for ID: $tripId...'); // <--- Use injected logger
    return remoteDataSource.listenToTripUpdates(tripId);
  }
}
