import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../domain/entities/trip.dart';
import '../models/car_type_model.dart';
import '../models/driver_model.dart';
import '../models/payment_method.dart';
import '../models/place_details_model.dart';
import '../models/trip_model.dart';

import 'dart:async'; // Keep this import as you have stream methods

// Ensure this is imported for Trip parameter in requestTrip
// import '../models/place_model.dart'; // <--- REMOVED: If PlaceDetailsModel is used for search results, no need for a separate PlaceModel unless it truly represents a simpler prediction.

abstract class MapRemoteDataSource {
  // Corrected searchPlaces to return List<PlaceDetailsModel> as per your MapRemoteDataSourceImpl
  Future<List<PlaceDetailsModel>> searchPlaces(String query, LatLng? location);

  // --- ADDED: getCurrentLocation method signature ---
  Future<LatLng> getCurrentLocation();

  // --- ADDED: getPlaceDetails method signature ---
  Future<PlaceDetailsModel> getPlaceDetails(String placeId);

  Future<List<DriverModel>> getNearbyDrivers(LatLng currentLocation);
  Future<List<CarTypeModel>> getAvailableCarTypes(LatLng pickupLocation);
  Future<List<PaymentMethodModel>> getUserPaymentMethods();
  Future<PaymentMethodModel> addPaymentMethod();
  Future<TripModel> requestTrip(Trip trip);
  Stream<TripModel> listenToTripUpdates(String tripId);
}
