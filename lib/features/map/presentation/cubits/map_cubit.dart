import 'package:bloc/bloc.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../services/logger_services.dart';
import '../../domain/domain_exports.dart';
import '../../domain/entities/payment_method.dart';
import '../../domain/entities/trip.dart';
import '../../domain/usecases/get_available_car_types.dart';
import '../../domain/usecases/listen_to_trip_updates.dart';
import '../../domain/usecases/request_trip.dart';
import '../presentation_exports.dart';

import 'dart:async';

import '../../domain/entities/car_type.dart';

import 'package:geolocator/geolocator.dart';

class MapsCubit extends Cubit<MapsState> {
  final SearchPlacesUseCase searchPlacesUseCase;
  final GetNearbyDriversUseCase getNearbyDriversUseCase;
  final GetAvailableCarTypesUseCase getAvailableCarTypesUseCase;
  final RequestTripUseCase requestTripUseCase;
  final ListenToTripUpdatesUseCase listenToTripUpdatesUseCase;
  final AppLogger logger;

  StreamSubscription<Trip>? _tripUpdatesSubscription;

  MapsCubit({
    required this.searchPlacesUseCase,
    required this.getNearbyDriversUseCase,
    required this.getAvailableCarTypesUseCase,
    required this.requestTripUseCase,
    required this.listenToTripUpdatesUseCase,
    required this.logger,
  }) : super(const MapsInitial());

  // --- Map and Location Management ---

  // New method to get current location and update the state
  Future<void> getAndSetCurrentLocation() async {
    logger.i('MapsCubit: Attempting to get current location.');
    emit(MapsLoading.fromOldState(state, currentView: MapScreenView.initial));

    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          emit(MapsError.fromOldState(state,
              message: 'Location permissions are denied.'));
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        emit(MapsError.fromOldState(state,
            message:
                'Location permissions are permanently denied, we cannot request permissions.'));
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      LatLng newLocation = LatLng(position.latitude, position.longitude);

      logger.d('MapsCubit: Current location obtained: $newLocation');
      // Update state with new location
      final currentState = state is MapsLoaded
          ? state as MapsLoaded
          : MapsLoaded.fromState(state);

      emit(currentState.copyWith(
        currentLocation: newLocation,
        pickupLocation: currentState.pickupLocation ?? newLocation,
        currentView:
            MapScreenView.initial, // Back to initial view after loading
        // Add a marker for the current location
        markers: {
          Marker(
            markerId: const MarkerId('currentLocation'),
            position: newLocation,
            infoWindow: const InfoWindow(title: 'Your Location'),
          )
        },
      ));

      // After updating location, fetch nearby drivers
      _fetchNearbyDrivers(newLocation);
    } catch (e, st) {
      logger.e('MapsCubit: Error getting current location: $e',
          error: e, stackTrace: st);
      emit(MapsError.fromOldState(state,
          message: 'Failed to get current location: ${e.toString()}'));
    }
  }

  void updateCurrentLocation(LatLng newLocation) {
    logger.d('MapsCubit: Updating current location to $newLocation');
    final currentState =
        state is MapsLoaded ? state as MapsLoaded : MapsLoaded.fromState(state);

    emit(currentState.copyWith(
      currentLocation: newLocation,
      pickupLocation: currentState.pickupLocation ?? newLocation,
      // Update marker for current location
      markers: {
        Marker(
          markerId: const MarkerId('currentLocation'),
          position: newLocation,
          infoWindow: const InfoWindow(title: 'Your Location'),
        )
      },
    ));
    _fetchNearbyDrivers(newLocation);
  }

  // Public method to refresh nearby drivers
  void refreshNearbyDrivers() {
    if (state.currentLocation != null) {
      _fetchNearbyDrivers(state.currentLocation!);
    } else {
      logger.w('MapsCubit: Cannot refresh drivers, current location is null.');
      emit(MapsError.fromOldState(state,
          message: 'Cannot refresh drivers: current location unknown.'));
    }
  }

  void setPickupLocation(LatLng location, String address) {
    logger.d('MapsCubit: Setting pickup location to $address ($location)');
    final currentState =
        state is MapsLoaded ? state as MapsLoaded : MapsLoaded.fromState(state);

    emit(currentState.copyWith(
      pickupLocation: location,
      pickupAddress: address,
      searchResults: [],
      selectedPlace: null,
      // Update pickup marker
      markers: Set.from(currentState.markers)
        ..add(
          Marker(
            markerId: const MarkerId('pickupLocation'),
            position: location,
            infoWindow: InfoWindow(title: 'Pickup: $address'),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueAzure),
          ),
        ),
    ));
    _fetchAvailableCarTypes(location);
  }

  // --- Place Search ---

  Future<void> searchPlaces(String query) async {
    if (query.isEmpty) {
      logger.d('MapsCubit: Clearing search results for empty query.');
      emit(MapsLoaded.fromState(state).copyWith(
        currentView: MapScreenView.searchingDestination,
        searchResults: [],
        selectedPlace: null,
      ));
      return;
    }

    logger.i('MapsCubit: Searching places for "$query"');
    emit(MapsLoading.fromOldState(state,
        currentView: MapScreenView.searchingDestination));

    final result = await searchPlacesUseCase(
      SearchPlacesParams(query: query, location: state.currentLocation),
    );

    result.fold(
      (failure) {
        logger.e('MapsCubit: Failed to search places: ${failure.message}');
        emit(MapsError.fromOldState(state, message: failure.message));
      },
      (places) {
        logger.d('MapsCubit: Found ${places.length} search results.');
        emit(MapsLoaded.fromState(state).copyWith(
          currentView: MapScreenView.searchingDestination,
          searchResults: places,
        ));
      },
    );
  }

  void selectDestinationPlace(PlaceDetails selectedPlace) {
    logger.d('MapsCubit: Selected destination place: ${selectedPlace.address}');
    // In a real app, you'd convert PlaceDetails.location to LatLng if not already,
    // or ensure your PlaceDetails always has a valid LatLng.
    final LatLng destinationLatLng = selectedPlace.location;

    final currentState =
        state is MapsLoaded ? state as MapsLoaded : MapsLoaded.fromState(state);

    emit(currentState.copyWith(
      currentView: MapScreenView.destinationSelected,
      selectedPlace: selectedPlace,
      destinationLocation: destinationLatLng,
      destinationAddress: selectedPlace.address,
      searchResults: [],
      // Update destination marker
      markers: Set.from(currentState.markers)
        ..add(
          Marker(
            markerId: const MarkerId('destinationLocation'),
            position: destinationLatLng,
            infoWindow:
                InfoWindow(title: 'Destination: ${selectedPlace.address}'),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueOrange),
          ),
        ),
    ));

    if (state.pickupLocation != null) {
      _fetchAvailableCarTypes(state.pickupLocation!);
    }
  }

  void clearDestinationSelection() {
    logger.d('MapsCubit: Clearing destination selection.');
    final currentState =
        state is MapsLoaded ? state as MapsLoaded : MapsLoaded.fromState(state);

    emit(currentState.copyWith(
      currentView: MapScreenView.initial,
      destinationLocation: null,
      destinationAddress: null,
      selectedPlace: null,
      searchResults: [],
      availableCarTypes: [],
      selectedCarType: null,
      // Remove destination marker
      markers: Set.from(currentState.markers)
        ..removeWhere(
            (marker) => marker.markerId.value == 'destinationLocation'),
    ));
  }

  // --- Driver and Car Type Management ---

  Future<void> _fetchNearbyDrivers(LatLng currentLocation) async {
    logger.i('MapsCubit: Fetching nearby drivers...');
    final result = await getNearbyDriversUseCase(
        GetNearbyDriversParams(currentLocation: currentLocation));

    result.fold(
      (failure) {
        logger
            .e('MapsCubit: Failed to fetch nearby drivers: ${failure.message}');
      },
      (drivers) {
        logger.d('MapsCubit: Found ${drivers.length} nearby drivers.');
        final Set<Marker> driverMarkers = drivers
            .map((driver) => Marker(
                  markerId: MarkerId(driver.id),
                  // position: driver.location, // <--- CORRECTED: driver.location
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueBlue), // Custom driver icon
                  infoWindow:
                      InfoWindow(title: driver.name, snippet: driver.name),
                ))
            .toSet();

        final currentState = state is MapsLoaded
            ? state as MapsLoaded
            : MapsLoaded.fromState(state);

        // Keep current location/pickup/destination markers, add/update driver markers
        final Set<Marker> existingMarkers = Set.from(currentState.markers)
          ..removeWhere((marker) => ![
                'currentLocation',
                'pickupLocation',
                'destinationLocation'
              ].contains(marker.markerId.value));

        emit(currentState.copyWith(
            nearbyDrivers: drivers,
            markers: existingMarkers..addAll(driverMarkers)));
      },
    );
  }

  Future<void> _fetchAvailableCarTypes(LatLng pickupLocation) async {
    logger.i('MapsCubit: Fetching available car types...');
    emit(MapsLoading.fromOldState(state,
        currentView: MapScreenView.selectingCar));

    final result = await getAvailableCarTypesUseCase(
        GetAvailableCarTypesParams(pickupLocation: pickupLocation));

    result.fold(
      (failure) {
        logger.e(
            'MapsCubit: Failed to fetch available car types: ${failure.message}');
        emit(MapsError.fromOldState(state,
            message: 'Failed to fetch car types: ${failure.message}'));
      },
      (carTypes) {
        logger.d('MapsCubit: Found ${carTypes.length} available car types.');
        emit(MapsLoaded.fromState(state).copyWith(
          currentView: MapScreenView.selectingCar,
          availableCarTypes: carTypes,
          selectedCarType: carTypes.isNotEmpty ? carTypes.first : null,
        ));
      },
    );
  }

  void selectCarType(CarType carType) {
    logger.d('MapsCubit: Selected car type: ${carType.name}');
    emit(MapsLoaded.fromState(state).copyWith(
      selectedCarType: carType,
      currentView: MapScreenView.selectingCar,
    ));
  }

  // --- Payment Method Integration ---

  void updateSelectedPaymentMethod(PaymentMethod method) {
    logger.d('MapsCubit: Updating selected payment method to: ${method.id}');
    emit(MapsLoaded.fromState(state).copyWith(
      selectedPaymentMethod: method,
      currentView: state.currentView == MapScreenView.selectingCar
          ? MapScreenView.selectingCar
          : MapScreenView.confirmingTrip,
    ));
  }

  // --- Trip Request and Live Updates ---

  Future<void> requestTrip() async {
    if (state.pickupLocation == null ||
        state.pickupAddress == null ||
        state.destinationLocation == null ||
        state.destinationAddress == null ||
        state.selectedCarType == null ||
        state.selectedPaymentMethod == null) {
      logger
          .w('MapsCubit: Cannot request trip. Missing essential information.');
      emit(MapsError.fromOldState(state,
          message:
              'Please ensure pickup, destination, car type, and payment are selected.'));
      return;
    }

    logger.i('MapsCubit: Requesting trip...');
    emit(MapsLoading.fromOldState(state,
        currentView: MapScreenView.findingDriver));

    final result = await requestTripUseCase(
      RequestTripParams(
        pickupLocation: state.pickupLocation!,
        pickupAddress: state.pickupAddress!,
        destinationLocation: state.destinationLocation!,
        destinationAddress: state.destinationAddress!,
        selectedCarType: state.selectedCarType!,
        selectedPaymentMethod: state.selectedPaymentMethod!,
      ),
    );

    result.fold(
      (failure) {
        logger.e('MapsCubit: Failed to request trip: ${failure.message}');
        emit(MapsError.fromOldState(state,
            message: 'Failed to request trip: ${failure.message}'));
      },
      (newTrip) {
        logger.d(
            'MapsCubit: Trip requested successfully. Trip ID: ${newTrip.id}');
        emit(MapsLoaded.fromState(state).copyWith(
          currentView: MapScreenView.findingDriver,
          activeTrip: newTrip,
        ));
        _listenToTripUpdates(newTrip.id);
      },
    );
  }

  void _listenToTripUpdates(String tripId) async {
    logger.i('MapsCubit: Starting to listen for trip updates for ID: $tripId');
    await _tripUpdatesSubscription?.cancel();

    final result = await listenToTripUpdatesUseCase(
        ListenToTripUpdatesParams(tripId: tripId));

    result.fold(
      (failure) {
        logger.e(
            'MapsCubit: Failed to set up trip updates stream: ${failure.message}');
        emit(MapsError.fromOldState(state,
            message: 'Failed to track trip: ${failure.message}'));
      },
      (tripStream) {
        _tripUpdatesSubscription = tripStream.listen(
          (updatedTrip) {
            logger.d(
                'MapsCubit: Received trip update: Status=${updatedTrip.status}, Driver=${updatedTrip.driver?.name ?? 'N/A'}');
            emit(
                TripUpdateState.fromOldState(state, trip: updatedTrip).copyWith(
              currentView: _mapTripStatusToView(updatedTrip.status),
            ));

            if (updatedTrip.status == TripStatus.tripFinished ||
                updatedTrip.status == TripStatus.cancelled) {
              _tripUpdatesSubscription?.cancel();
              logger.i(
                  'MapsCubit: Trip ${updatedTrip.id} finished or cancelled. Stream unsubscribed.');
              emit(MapsLoaded.fromState(state).copyWith(
                activeTrip: null,
                selectedCarType: null,
                destinationLocation: null,
                destinationAddress: null,
                selectedPlace: null,
                currentView: _mapTripStatusToView(updatedTrip.status),
                // Clear all dynamic markers when trip ends, except the current location if it exists
                markers: (state is MapsLoaded)
                    ? (state as MapsLoaded)
                        .markers
                        .where((m) => m.markerId.value == 'currentLocation')
                        .toSet()
                    : {},
              ));
            }
          },
          onError: (e, st) {
            logger.e('MapsCubit: Error in trip updates stream: $e',
                error: e, stackTrace: st);
            emit(MapsError.fromOldState(state,
                message: 'Error tracking trip: $e'));
            _tripUpdatesSubscription?.cancel();
          },
          onDone: () {
            logger.i(
                'MapsCubit: Trip updates stream for $tripId completed naturally.');
          },
        );
      },
    );
  }

  MapScreenView _mapTripStatusToView(TripStatus status) {
    switch (status) {
      case TripStatus.selectingCar:
        return MapScreenView.selectingCar;
      case TripStatus.findingDriver:
        return MapScreenView.findingDriver;
      case TripStatus.driverAccepted:
        return MapScreenView.driverAssigned;
      case TripStatus.driverOnTheWay:
        return MapScreenView.driverAssigned;
      case TripStatus.driverArrived:
        return MapScreenView.driverAssigned;
      case TripStatus.tripStarted:
        return MapScreenView.tripInProgress;
      case TripStatus.tripFinished:
        return MapScreenView.tripFinished;
      case TripStatus.cancelled:
        return MapScreenView.tripCancelled;
    }
  }

  // --- Other Actions ---

  void resetMapState() {
    logger.i('MapsCubit: Resetting map state.');
    _tripUpdatesSubscription?.cancel();
    emit(const MapsInitial());
    if (state.currentLocation != null) {
      // Re-fetch drivers if location is known after reset
      _fetchNearbyDrivers(state.currentLocation!);
    }
  }

  @override
  Future<void> close() {
    _tripUpdatesSubscription?.cancel();
    logger.d('MapsCubit: Closed. Trip updates subscription cancelled.');
    return super.close();
  }
}
