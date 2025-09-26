import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:quickrider/features/map/domain/domain_exports.dart';

import 'package:quickrider/features/map/domain/entities/car_type.dart'; // New Import
import 'package:quickrider/features/map/domain/entities/payment_method.dart'; // New Import
import 'package:quickrider/features/map/domain/entities/trip.dart'; // New Import

import 'package:dartz/dartz.dart'; // Import dartz for Either

import '../../../../core/errors/failures.dart';
import '../entities/place_entity.dart'; // Assuming PlaceEntity is the correct name for your Place entity

// Need this if you're checking network connection

import 'dart:async';

// Import dartz for Either

// lib/features/map/domain/repository/map_repository.dart

abstract class MapRepository {
  // Corrected to return PlaceEntity (or PlaceDetails if your models combine them)
  // And to throw Failures directly, or wrap in Either. Sticking to throws here for searchPlaces.
  Future<List<PlaceDetails>> searchPlaces(String query, LatLng? location);

  Future<List<Driver>> getNearbyDrivers(LatLng currentLocation);
  Future<List<CarType>> getAvailableCarTypes(LatLng pickupLocation);

  // --- CRUCIAL CHANGE HERE ---
  // Repository methods typically return Either<Failure, T> when errors are possible
  Future<Either<Failure, List<PaymentMethod>>> getUserPaymentMethods();
  Future<Either<Failure, PaymentMethod>>
      addPaymentMethod(); // Assuming addPaymentMethod also returns Either

  // --- CRUCIAL CHANGE HERE ---
  Future<Either<Failure, LatLng>> getCurrentLocation(); // Returns LatLng
  Future<Either<Failure, PlaceDetails>> getPlaceDetails(
      String placeId); // Returns PlaceDetails

  Future<Trip> requestTrip({
    required LatLng pickupLocation,
    required String pickupAddress,
    required LatLng destinationLocation,
    required String destinationAddress,
    required CarType selectedCarType,
    required PaymentMethod selectedPaymentMethod,
  });
  Stream<Trip> listenToTripUpdates(String tripId);
}
