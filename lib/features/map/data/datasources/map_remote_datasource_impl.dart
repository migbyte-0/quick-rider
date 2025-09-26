import 'dart:async';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:quickrider/features/map/data/models/place_details_model.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../services/logger_services.dart';
import '../../domain/entities/trip.dart';
import '../models/driver_model.dart';
import '../models/payment_method.dart';
import 'map_remote_data_source.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

import 'dart:math';

import '../models/car_type_model.dart';
import '../models/trip_model.dart';

import 'package:location/location.dart';

class MapRemoteDataSourceImpl implements MapRemoteDataSource {
  final http.Client client;
  final AppLogger logger;
  final Location locationService;
  final String googlePlacesApiKey = "AIzaSyCub4CePQv8fNb3mw66ZQGRQzySCLu0gqA";

  static const String baseUrl =
      'https://maps.googleapis.com/maps/api/place/autocomplete/json';
  static const String geocodeBaseUrl =
      'https://maps.googleapis.com/maps/api/geocode/json';
  static const String placeDetailsBaseUrl =
      'https://maps.googleapis.com/maps/api/place/details/json';

  MapRemoteDataSourceImpl({
    required this.client,
    required this.logger,
    required this.locationService,
  });

  @override
  Future<List<PlaceDetailsModel>> searchPlaces(
      String query, LatLng? location) async {
    logger.i('RemoteDataSource: Starting search for query: "$query"');
    final Map<String, String> queryParams = {
      'input': query,
      'key': googlePlacesApiKey,
      'language': 'en',
    };

    if (location != null) {
      queryParams['location'] = '${location.latitude},${location.longitude}';
      queryParams['radius'] = '50000'; // 50km radius
      queryParams['strictbounds'] =
          'false'; // Allow results outside the radius but prioritize those within
    }

    final uri = Uri.parse(baseUrl).replace(queryParameters: queryParams);
    logger.d(
        'RemoteDataSource: Calling Google Places Autocomplete API URL: $uri');

    try {
      final response = await client.get(uri);
      logger.d(
          'RemoteDataSource: Autocomplete API Raw Response: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 'OK') {
          final List<dynamic> predictionsJson = jsonResponse['predictions'];
          final List<PlaceDetailsModel> places = predictionsJson
              .map((json) => PlaceDetailsModel.fromJson(
                  json)) // Assuming PlaceDetailsModel can parse prediction JSON
              .toList();
          logger.d(
              'RemoteDataSource: Successfully parsed ${places.length} places from autocomplete.');
          return places;
        } else if (jsonResponse['status'] == 'ZERO_RESULTS') {
          logger.i('RemoteDataSource: No results found for query: "$query"');
          return [];
        } else {
          logger.e(
              'RemoteDataSource: Google Places Autocomplete API Error: ${jsonResponse['status']} - ${jsonResponse['error_message']}');
          throw ServerException(
            jsonResponse['error_message'] ??
                'Unknown Places Autocomplete API error',
          );
        }
      } else {
        logger.e(
            'RemoteDataSource: HTTP Error ${response.statusCode} from Autocomplete API: ${response.body}');
        throw ServerException(
          'HTTP Error ${response.statusCode} from Autocomplete API: ${response.body}',
        );
      }
    } on ServerException {
      rethrow; // Re-throw custom server exceptions
    } on Exception catch (e, st) {
      logger.e('RemoteDataSource: Generic error searching places: $e',
          error: e, stackTrace: st);
      throw ServerException('Error searching places: ${e.toString()}');
    }
  }

  @override
  Future<List<DriverModel>> getNearbyDrivers(LatLng currentLocation) async {
    logger.i(
        'RemoteDataSource: Getting nearby drivers for ${currentLocation.latitude},${currentLocation.longitude}');
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    final Random random = Random();
    final List<DriverModel> drivers = [];

    // Generate 3 mock drivers near the current location
    for (int i = 0; i < 3; i++) {
      final double latOffset =
          (random.nextDouble() - 0.5) * 0.01; // +/- 0.005 degrees latitude
      final double lngOffset =
          (random.nextDouble() - 0.5) * 0.01; // +/- 0.005 degrees longitude
      drivers.add(DriverModel(
        id: 'driver_${i + 1}',
        name: 'Driver ${i + 1}',
        imageUrl: 'assets/images/driver_avatar.png', //
        carModel: 'Sedan',
        carPlateNumber: 'ABC 12${i + 1}',
        carImageUrl: 'assets/images/car_icon_normal.png', //
        currentLocation: LatLng(
          currentLocation.latitude + latOffset,
          currentLocation.longitude + lngOffset,
        ),
      ));
    }
    logger.d('RemoteDataSource: Found ${drivers.length} mock drivers.');
    return drivers;
  }

  @override
  Future<List<CarTypeModel>> getAvailableCarTypes(LatLng pickupLocation) async {
    logger.i(
        'RemoteDataSource: Fetching available car types for ${pickupLocation.latitude},${pickupLocation.longitude}');
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 0));

    return [
      const CarTypeModel(
        id: 'comfort',
        name: 'Comfort',
        minPrice: 20,
        maxPrice: 40,
        seats: 4,
        imageUrl: 'assets/images/car_comfort.png', //
        etaMinutes: 2,
      ),
      const CarTypeModel(
        id: 'lux',
        name: 'Lux',
        minPrice: 40,
        maxPrice: 80,
        seats: 4,
        imageUrl: 'assets/images/car_lux.png', //
        etaMinutes: 3,
      ),
      const CarTypeModel(
        id: 'large',
        name: 'Large',
        minPrice: 80,
        maxPrice: 120,
        seats: 7,
        imageUrl: 'assets/images/car_large.png', //
        etaMinutes: 5,
      ),
    ];
  }

  @override
  Future<List<PaymentMethodModel>> getUserPaymentMethods() async {
    logger.i('RemoteDataSource: Fetching user payment methods.');
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 0));

    return [
      PaymentMethodModel.cash(),
      PaymentMethodModel.creditCard(
        id: 'card1',
        lastFourDigits: '1234',
        brand: 'Visa',
      ),
      PaymentMethodModel.creditCard(
        id: 'card2',
        lastFourDigits: '5678',
        brand: 'Mastercard',
      ),
    ];
  }

  @override
  Future<PaymentMethodModel> addPaymentMethod() async {
    logger.i('RemoteDataSource: Simulating adding a new payment method.');
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    return PaymentMethodModel.creditCard(
      id: 'new_card_1',
      lastFourDigits: '9012',
      brand: 'Amex',
    );
  }

  @override
  Future<TripModel> requestTrip(Trip trip) async {
    logger.i(
        'RemoteDataSource: Requesting trip for car type: ${trip.selectedCarType.name} to ${trip.destinationAddress}');
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Create a dummy driver for the mock trip
    final dummyDriver = DriverModel(
      id: 'DRV001',
      name: 'Ahmed',
      imageUrl: 'assets/images/driver_ahmed.png', //
      carModel: 'Toyota Camry',
      carPlateNumber: '3892',
      carImageUrl: 'assets/images/car_camry.png', //
      currentLocation: LatLng(
          trip.pickupLocation.latitude + 0.001, // Slightly offset from pickup
          trip.pickupLocation.longitude + 0.001),
    );

    final requestedTrip = TripModel(
      id: 'TRP-${DateTime.now().millisecondsSinceEpoch}', // Unique ID for the trip
      pickupLocation: trip.pickupLocation,
      pickupAddress: trip.pickupAddress,
      destinationLocation: trip.destinationLocation,
      destinationAddress: trip.destinationAddress,
      selectedCarType: CarTypeModel.fromEntity(trip.selectedCarType),
      selectedPaymentMethod:
          PaymentMethodModel.fromEntity(trip.selectedPaymentMethod),
      status: TripStatus.findingDriver, // Initial status
      driver: dummyDriver,
      fare: (trip.selectedCarType.minPrice + trip.selectedCarType.maxPrice) /
          2, // Simple fare calculation
    );
    logger.d(
        'RemoteDataSource: Trip requested successfully. Trip ID: ${requestedTrip.id}');
    return requestedTrip;
  }

  @override
  Stream<TripModel> listenToTripUpdates(String tripId) async* {
    logger
        .i('RemoteDataSource: Listening for trip updates for trip ID: $tripId');

    // Simulate real-time updates for a trip
    await Future.delayed(const Duration(seconds: 2));
    yield (TripModel.mockTrip(
        tripId: tripId, status: TripStatus.findingDriver));
    logger.d('RemoteDataSource: Trip $tripId status: Finding Driver');

    await Future.delayed(const Duration(seconds: 4));
    yield (TripModel.mockTrip(
        tripId: tripId, status: TripStatus.driverAccepted));
    logger.d('RemoteDataSource: Trip $tripId status: Driver Accepted');

    await Future.delayed(const Duration(seconds: 2));
    yield (TripModel.mockTrip(
        tripId: tripId, status: TripStatus.driverOnTheWay));
    logger.d('RemoteDataSource: Trip $tripId status: Driver On The Way');

    await Future.delayed(const Duration(seconds: 2));
    yield (TripModel.mockTrip(
        tripId: tripId, status: TripStatus.driverArrived));
    logger.d('RemoteDataSource: Trip $tripId status: Driver Arrived');

    await Future.delayed(const Duration(seconds: 2));
    yield (TripModel.mockTrip(tripId: tripId, status: TripStatus.tripStarted));
    logger.d('RemoteDataSource: Trip $tripId status: Trip Started');

    await Future.delayed(const Duration(seconds: 5));
    yield (TripModel.mockTrip(tripId: tripId, status: TripStatus.tripFinished));
    logger.d('RemoteDataSource: Trip $tripId status: Trip Finished');

    logger.i('RemoteDataSource: Trip updates stream for $tripId completed.');
  }

  @override
  Future<LatLng> getCurrentLocation() async {
    logger.i(
        'RemoteDataSource: Attempting to get current location from device...');
    try {
      bool serviceEnabled;
      PermissionStatus permissionGranted;

      // Check if location service is enabled
      serviceEnabled = await locationService.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await locationService.requestService();
        if (!serviceEnabled) {
          logger.w(
              'RemoteDataSource: Location service not enabled after request.');
          throw const LocationException('Location service not enabled.');
        }
      }

      // Check and request location permission
      permissionGranted = await locationService.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await locationService.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          logger.w(
              'RemoteDataSource: Location permission not granted after request.');
          throw const LocationException('Location permission denied.');
        }
      }

      // Get location data
      final LocationData locationData = await locationService.getLocation();
      if (locationData.latitude == null || locationData.longitude == null) {
        logger.e('RemoteDataSource: Failed to get valid latitude/longitude.');
        throw const LocationException('Failed to retrieve valid coordinates.');
      }
      final LatLng currentLatLng =
          LatLng(locationData.latitude!, locationData.longitude!);
      logger.d(
          'RemoteDataSource: Successfully retrieved current location: $currentLatLng');
      return currentLatLng;
    } on LocationException {
      rethrow; // Re-throw custom location exceptions
    } catch (e, st) {
      logger.e('RemoteDataSource: Error getting current location: $e',
          error: e, stackTrace: st);
      // Wrap any other exception in a LocationException
      throw LocationException(
          'Failed to get current location: ${e.toString()}');
    }
  }

  @override
  Future<PlaceDetailsModel> getPlaceDetails(String placeId) async {
    logger.i('RemoteDataSource: Fetching details for place ID: $placeId');
    final Map<String, String> queryParams = {
      'place_id': placeId,
      'key': googlePlacesApiKey,
      'language': 'en',
      // Request all relevant fields to populate PlaceDetailsModel
      'fields':
          'address_component,adr_address,alt_id,business_status,formatted_address,geometry,icon,icon_mask_base_uri,icon_background_color,name,photo,place_id,plus_code,type,url,utc_offset,vicinity,wheelchair_accessible_entrance,current_opening_hours,formatted_phone_number,international_phone_number,opening_hours,secondary_opening_hours,website,price_level,rating,user_ratings_total',
    };

    final uri =
        Uri.parse(placeDetailsBaseUrl).replace(queryParameters: queryParams);
    logger.d('RemoteDataSource: Calling Google Place Details API URL: $uri');

    try {
      final response = await client.get(uri);
      logger.d(
          'RemoteDataSource: Place Details API Raw Response: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 'OK') {
          final Map<String, dynamic> result = jsonResponse['result'];
          final PlaceDetailsModel placeDetails =
              PlaceDetailsModel.fromJson(result);
          logger.d(
              'RemoteDataSource: Successfully parsed details for place: ${placeDetails.name}');
          return placeDetails;
        } else {
          logger.e(
              'RemoteDataSource: Google Place Details API Error: ${jsonResponse['status']} - ${jsonResponse['error_message']}');
          throw ServerException(
            jsonResponse['error_message'] ?? 'Unknown Place Details API error',
          );
        }
      } else {
        logger.e(
            'RemoteDataSource: HTTP Error ${response.statusCode} from Place Details API: ${response.body}');
        throw ServerException(
          'HTTP Error ${response.statusCode} from Place Details API: ${response.body}',
        );
      }
    } on ServerException {
      rethrow; // Re-throw custom server exceptions
    } on Exception catch (e, st) {
      logger.e(
          'RemoteDataSource: Generic error getting place details for ID $placeId: $e',
          error: e,
          stackTrace: st);
      throw ServerException('Error getting place details: ${e.toString()}');
    }
  }
}
