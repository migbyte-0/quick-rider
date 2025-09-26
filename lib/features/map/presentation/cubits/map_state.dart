import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:quickrider/features/map/domain/entities/place_entity.dart'; // Import PlaceEntity

import '../../domain/entities/car_type.dart';
import '../../domain/entities/payment_method.dart';
import '../../domain/entities/trip.dart';

// Note: PlaceEntity is not directly used in MapsState, but PlaceDetails is.
// If PlaceEntity is the base for PlaceDetails, keep this import.
// For now, let's assume it's just PlaceDetails that's relevant here.
// import 'package:quickrider/features/map/domain/entities/place_entity.dart';

enum MapScreenView {
  initial, // User hasn't interacted much, just seeing the map
  searchingDestination, // User is actively typing a destination
  destinationSelected, // Destination is picked, showing car types
  selectingCar, // User is choosing a car type
  confirmingTrip, // User is about to confirm the trip (final check)
  findingDriver, // Trip requested, waiting for a driver
  driverAssigned, // Driver is assigned and on the way
  tripInProgress, // Trip has started
  tripFinished, // Trip completed
  tripCancelled, // Trip cancelled
}

abstract class MapsState extends Equatable {
  final MapScreenView currentView;
  final LatLng? currentLocation;
  final LatLng? pickupLocation; // Where the user wants to be picked up
  final String? pickupAddress;
  final LatLng? destinationLocation;
  final String? destinationAddress;
  final List<PlaceDetails> searchResults;
  final PlaceDetails? selectedPlace;
  final List<Driver> nearbyDrivers;
  final List<CarType> availableCarTypes;
  final CarType? selectedCarType;
  final List<PaymentMethod> userPaymentMethods;
  final PaymentMethod? selectedPaymentMethod;
  final Trip? activeTrip; // The current trip being managed
  final Set<Marker> markers; // <--- ADDED
  final Set<Circle> circles; // <--- ADDED

  const MapsState({
    this.currentView = MapScreenView.initial,
    this.currentLocation,
    this.pickupLocation,
    this.pickupAddress,
    this.destinationLocation,
    this.destinationAddress,
    this.searchResults = const [],
    this.selectedPlace,
    this.nearbyDrivers = const [],
    this.availableCarTypes = const [],
    this.selectedCarType,
    this.userPaymentMethods = const [],
    this.selectedPaymentMethod,
    this.activeTrip,
    this.markers = const {}, // <--- INITIALIZE
    this.circles = const {}, // <--- INITIALIZE
  });

  // Helper getter to determine if the map is currently in a searching state
  bool get isSearching =>
      currentView == MapScreenView.searchingDestination; // <--- ADDED

  @override
  List<Object?> get props => [
        currentView,
        currentLocation,
        pickupLocation,
        pickupAddress,
        destinationLocation,
        destinationAddress,
        searchResults,
        selectedPlace,
        nearbyDrivers,
        availableCarTypes,
        selectedCarType,
        userPaymentMethods,
        selectedPaymentMethod,
        activeTrip,
        markers, // <--- ADDED
        circles, // <--- ADDED
      ];

  // Abstract copyWith for base state
  MapsState copyWith({
    MapScreenView? currentView,
    LatLng? currentLocation,
    LatLng? pickupLocation,
    String? pickupAddress,
    LatLng? destinationLocation,
    String? destinationAddress,
    List<PlaceDetails>? searchResults,
    PlaceDetails? selectedPlace,
    List<Driver>? nearbyDrivers,
    List<CarType>? availableCarTypes,
    CarType? selectedCarType,
    List<PaymentMethod>? userPaymentMethods,
    PaymentMethod? selectedPaymentMethod,
    Trip? activeTrip,
    Set<Marker>? markers, // <--- ADDED
    Set<Circle>? circles, // <--- ADDED
  });
}

class MapsInitial extends MapsState {
  const MapsInitial();

  @override
  MapsInitial copyWith({
    MapScreenView? currentView,
    LatLng? currentLocation,
    LatLng? pickupLocation,
    String? pickupAddress,
    LatLng? destinationLocation,
    String? destinationAddress,
    List<PlaceDetails>? searchResults,
    PlaceDetails? selectedPlace,
    List<Driver>? nearbyDrivers,
    List<CarType>? availableCarTypes,
    CarType? selectedCarType,
    List<PaymentMethod>? userPaymentMethods,
    PaymentMethod? selectedPaymentMethod,
    Trip? activeTrip,
    Set<Marker>? markers,
    Set<Circle>? circles,
  }) {
    // Initial state is immutable and does not usually copyWith other values.
    // However, if you want to allow changing properties from MapsInitial (e.g., initial location),
    // you would implement it like MapsLoaded.copyWith.
    // For now, keeping it as immutable initial state.
    return const MapsInitial();
  }
}

class MapsLoading extends MapsState {
  const MapsLoading({
    super.currentView,
    super.currentLocation,
    super.pickupLocation,
    super.pickupAddress,
    super.destinationLocation,
    super.destinationAddress,
    super.searchResults,
    super.selectedPlace,
    super.nearbyDrivers,
    super.availableCarTypes,
    super.selectedCarType,
    super.userPaymentMethods,
    super.selectedPaymentMethod,
    super.activeTrip,
    super.markers, // <--- ADDED
    super.circles, // <--- ADDED
  });

  factory MapsLoading.fromOldState(MapsState oldState,
      {MapScreenView? currentView}) {
    return MapsLoading(
      currentView: currentView ?? oldState.currentView,
      currentLocation: oldState.currentLocation,
      pickupLocation: oldState.pickupLocation,
      pickupAddress: oldState.pickupAddress,
      destinationLocation: oldState.destinationLocation,
      destinationAddress: oldState.destinationAddress,
      searchResults: oldState.searchResults,
      selectedPlace: oldState.selectedPlace,
      nearbyDrivers: oldState.nearbyDrivers,
      availableCarTypes: oldState.availableCarTypes,
      selectedCarType: oldState.selectedCarType,
      userPaymentMethods: oldState.userPaymentMethods,
      selectedPaymentMethod: oldState.selectedPaymentMethod,
      activeTrip: oldState.activeTrip,
      markers: oldState.markers, // <--- ADDED
      circles: oldState.circles, // <--- ADDED
    );
  }

  @override
  MapsLoading copyWith({
    MapScreenView? currentView,
    LatLng? currentLocation,
    LatLng? pickupLocation,
    String? pickupAddress,
    LatLng? destinationLocation,
    String? destinationAddress,
    List<PlaceDetails>? searchResults,
    PlaceDetails? selectedPlace,
    List<Driver>? nearbyDrivers,
    List<CarType>? availableCarTypes,
    CarType? selectedCarType,
    List<PaymentMethod>? userPaymentMethods,
    PaymentMethod? selectedPaymentMethod,
    Trip? activeTrip,
    Set<Marker>? markers,
    Set<Circle>? circles,
  }) {
    return MapsLoading(
      currentView: currentView ?? this.currentView,
      currentLocation: currentLocation ?? this.currentLocation,
      pickupLocation: pickupLocation ?? this.pickupLocation,
      pickupAddress: pickupAddress ?? this.pickupAddress,
      destinationLocation: destinationLocation ?? this.destinationLocation,
      destinationAddress: destinationAddress ?? this.destinationAddress,
      searchResults: searchResults ?? this.searchResults,
      selectedPlace: selectedPlace ?? this.selectedPlace,
      nearbyDrivers: nearbyDrivers ?? this.nearbyDrivers,
      availableCarTypes: availableCarTypes ?? this.availableCarTypes,
      selectedCarType: selectedCarType ?? this.selectedCarType,
      userPaymentMethods: userPaymentMethods ?? this.userPaymentMethods,
      selectedPaymentMethod:
          selectedPaymentMethod ?? this.selectedPaymentMethod,
      activeTrip: activeTrip ?? this.activeTrip,
      markers: markers ?? this.markers,
      circles: circles ?? this.circles,
    );
  }
}

class MapsLoaded extends MapsState {
  const MapsLoaded({
    required super.currentView,
    super.currentLocation,
    super.pickupLocation,
    super.pickupAddress,
    super.destinationLocation,
    super.destinationAddress,
    super.searchResults,
    super.selectedPlace,
    super.nearbyDrivers,
    super.availableCarTypes,
    super.selectedCarType,
    super.userPaymentMethods,
    super.selectedPaymentMethod,
    super.activeTrip,
    super.markers, // <--- ADDED
    super.circles, // <--- ADDED
  });

  factory MapsLoaded.fromState(MapsState oldState) {
    return MapsLoaded(
      currentView: oldState.currentView,
      currentLocation: oldState.currentLocation,
      pickupLocation: oldState.pickupLocation,
      pickupAddress: oldState.pickupAddress,
      destinationLocation: oldState.destinationLocation,
      destinationAddress: oldState.destinationAddress,
      searchResults: oldState.searchResults,
      // REMOVED: isSearching is a getter, not a constructor parameter
      selectedPlace: oldState.selectedPlace,
      nearbyDrivers: oldState.nearbyDrivers,
      availableCarTypes: oldState.availableCarTypes,
      selectedCarType: oldState.selectedCarType,
      userPaymentMethods: oldState.userPaymentMethods,
      selectedPaymentMethod: oldState.selectedPaymentMethod,
      activeTrip: oldState.activeTrip,
      markers: oldState.markers, // <--- ADDED
      circles: oldState.circles, // <--- ADDED
    );
  }

  @override
  MapsLoaded copyWith({
    MapScreenView? currentView,
    LatLng? currentLocation,
    Set<Marker>? markers, // <--- ADDED
    Set<Circle>? circles, // <--- ADDED
    LatLng? pickupLocation,
    String? pickupAddress,
    LatLng? destinationLocation,
    String? destinationAddress,
    List<PlaceDetails>? searchResults,
    PlaceDetails? selectedPlace,
    List<Driver>? nearbyDrivers,
    List<CarType>? availableCarTypes,
    CarType? selectedCarType,
    List<PaymentMethod>? userPaymentMethods,
    PaymentMethod? selectedPaymentMethod,
    Trip? activeTrip,
  }) {
    return MapsLoaded(
      currentView: currentView ?? this.currentView,
      currentLocation: currentLocation ?? this.currentLocation,
      markers: markers ?? this.markers, // <--- ADDED
      circles: circles ?? this.circles, // <--- ADDED
      pickupLocation: pickupLocation ?? this.pickupLocation,
      pickupAddress: pickupAddress ?? this.pickupAddress,
      destinationLocation: destinationLocation ?? this.destinationLocation,
      destinationAddress: destinationAddress ?? this.destinationAddress,
      searchResults: searchResults ?? this.searchResults,
      selectedPlace: selectedPlace ?? this.selectedPlace,
      nearbyDrivers: nearbyDrivers ?? this.nearbyDrivers,
      availableCarTypes: availableCarTypes ?? this.availableCarTypes,
      selectedCarType: selectedCarType ?? this.selectedCarType,
      userPaymentMethods: userPaymentMethods ?? this.userPaymentMethods,
      selectedPaymentMethod:
          selectedPaymentMethod ?? this.selectedPaymentMethod,
      activeTrip: activeTrip ?? this.activeTrip,
    );
  }
}

class MapsError extends MapsState {
  final String message;

  const MapsError({
    required this.message,
    super.currentView,
    super.currentLocation,
    super.pickupLocation,
    super.pickupAddress,
    super.destinationLocation,
    super.destinationAddress,
    super.searchResults,
    super.selectedPlace,
    super.nearbyDrivers,
    super.availableCarTypes,
    super.selectedCarType,
    super.userPaymentMethods,
    super.selectedPaymentMethod,
    super.activeTrip,
    super.markers, // <--- ADDED
    super.circles, // <--- ADDED
  });

  factory MapsError.fromOldState(MapsState oldState,
      {required String message}) {
    return MapsError(
      message: message,
      currentView: oldState.currentView,
      currentLocation: oldState.currentLocation,
      pickupLocation: oldState.pickupLocation,
      pickupAddress: oldState.pickupAddress,
      destinationLocation: oldState.destinationLocation,
      destinationAddress: oldState.destinationAddress,
      searchResults: oldState.searchResults,
      selectedPlace: oldState.selectedPlace,
      nearbyDrivers: oldState.nearbyDrivers,
      availableCarTypes: oldState.availableCarTypes,
      selectedCarType: oldState.selectedCarType,
      userPaymentMethods: oldState.userPaymentMethods,
      selectedPaymentMethod: oldState.selectedPaymentMethod,
      activeTrip: oldState.activeTrip,
      markers: oldState.markers, // <--- ADDED
      circles: oldState.circles, // <--- ADDED
    );
  }

  @override
  List<Object?> get props => [...super.props, message];

  @override
  MapsError copyWith({
    MapScreenView? currentView,
    LatLng? currentLocation,
    Set<Marker>? markers,
    Set<Circle>? circles,
    LatLng? pickupLocation,
    String? pickupAddress,
    LatLng? destinationLocation,
    String? destinationAddress,
    List<PlaceDetails>? searchResults,
    PlaceDetails? selectedPlace,
    List<Driver>? nearbyDrivers,
    List<CarType>? availableCarTypes,
    CarType? selectedCarType,
    List<PaymentMethod>? userPaymentMethods,
    PaymentMethod? selectedPaymentMethod,
    Trip? activeTrip,
    String? message,
  }) {
    return MapsError(
      message: message ?? this.message,
      currentView: currentView ?? this.currentView,
      currentLocation: currentLocation ?? this.currentLocation,
      markers: markers ?? this.markers,
      circles: circles ?? this.circles,
      pickupLocation: pickupLocation ?? this.pickupLocation,
      pickupAddress: pickupAddress ?? this.pickupAddress,
      destinationLocation: destinationLocation ?? this.destinationLocation,
      destinationAddress: destinationAddress ?? this.destinationAddress,
      searchResults: searchResults ?? this.searchResults,
      selectedPlace: selectedPlace ?? this.selectedPlace,
      nearbyDrivers: nearbyDrivers ?? this.nearbyDrivers,
      availableCarTypes: availableCarTypes ?? this.availableCarTypes,
      selectedCarType: selectedCarType ?? this.selectedCarType,
      userPaymentMethods: userPaymentMethods ?? this.userPaymentMethods,
      selectedPaymentMethod:
          selectedPaymentMethod ?? this.selectedPaymentMethod,
      activeTrip: activeTrip ?? this.activeTrip,
    );
  }
}

class TripUpdateState extends MapsState {
  // `trip` here refers to the current state of the trip,
  // which will also populate the `activeTrip` in the base class.
  final Trip trip;

  const TripUpdateState({
    required this.trip,
    required super.currentView,
    super.currentLocation,
    super.pickupLocation,
    super.pickupAddress,
    super.destinationLocation,
    super.destinationAddress,
    super.searchResults,
    super.selectedPlace,
    super.nearbyDrivers,
    super.availableCarTypes,
    super.selectedCarType,
    super.userPaymentMethods,
    super.selectedPaymentMethod,
    super.markers, // <--- ADDED
    super.circles, // <--- ADDED
  }) : super(
            activeTrip:
                trip); // Pass `trip` to `activeTrip` in the super constructor

  factory TripUpdateState.fromOldState(MapsState oldState,
      {required Trip trip}) {
    return TripUpdateState(
      trip: trip,
      currentView: oldState.currentView,
      currentLocation: oldState.currentLocation,
      pickupLocation: oldState.pickupLocation,
      pickupAddress: oldState.pickupAddress,
      destinationLocation: oldState.destinationLocation,
      destinationAddress: oldState.destinationAddress,
      searchResults: oldState.searchResults,
      selectedPlace: oldState.selectedPlace,
      nearbyDrivers: oldState.nearbyDrivers,
      availableCarTypes: oldState.availableCarTypes,
      selectedCarType: oldState.selectedCarType,
      userPaymentMethods: oldState.userPaymentMethods,
      selectedPaymentMethod: oldState.selectedPaymentMethod,
      markers: oldState.markers, // <--- ADDED
      circles: oldState.circles, // <--- ADDED
    );
  }

  @override
  TripUpdateState copyWith({
    // Changed `trip` to `activeTrip` to match base class signature
    Trip? activeTrip,
    MapScreenView? currentView,
    LatLng? currentLocation,
    Set<Marker>? markers,
    Set<Circle>? circles,
    LatLng? pickupLocation,
    String? pickupAddress,
    LatLng? destinationLocation,
    String? destinationAddress,
    List<PlaceDetails>? searchResults,
    PlaceDetails? selectedPlace,
    List<Driver>? nearbyDrivers,
    List<CarType>? availableCarTypes,
    CarType? selectedCarType,
    List<PaymentMethod>? userPaymentMethods,
    PaymentMethod? selectedPaymentMethod,
  }) {
    return TripUpdateState(
      trip: activeTrip ?? trip, // Use activeTrip here
      currentView: currentView ?? this.currentView,
      currentLocation: currentLocation ?? this.currentLocation,
      markers: markers ?? this.markers,
      circles: circles ?? this.circles,
      pickupLocation: pickupLocation ?? this.pickupLocation,
      pickupAddress: pickupAddress ?? this.pickupAddress,
      destinationLocation: destinationLocation ?? this.destinationLocation,
      destinationAddress: destinationAddress ?? this.destinationAddress,
      searchResults: searchResults ?? this.searchResults,
      selectedPlace: selectedPlace ?? this.selectedPlace,
      nearbyDrivers: nearbyDrivers ?? this.nearbyDrivers,
      availableCarTypes: availableCarTypes ?? this.availableCarTypes,
      selectedCarType: selectedCarType ?? this.selectedCarType,
      userPaymentMethods: userPaymentMethods ?? this.userPaymentMethods,
      selectedPaymentMethod:
          selectedPaymentMethod ?? this.selectedPaymentMethod,
    );
  }

  @override
  List<Object?> get props => [...super.props, trip];
}
