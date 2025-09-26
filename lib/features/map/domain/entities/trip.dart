import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'car_type.dart';
import 'payment_method.dart';

// Represents the driver assigned to the trip
class Driver extends Equatable {
  final String id;
  final String name;
  final String imageUrl;
  final String carModel;
  final String carPlateNumber;
  final String carImageUrl; // Asset path for the driver's specific car image
  final LatLng currentLocation; // Driver's real-time location

  const Driver({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.carModel,
    required this.carPlateNumber,
    required this.carImageUrl,
    required this.currentLocation,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        imageUrl,
        carModel,
        carPlateNumber,
        carImageUrl,
        currentLocation,
      ];
}

// Represents the overall trip state
enum TripStatus {
  selectingCar, // Initial state after destination selection
  findingDriver,
  driverAccepted,
  driverOnTheWay,
  driverArrived,
  tripStarted,
  tripFinished,
  cancelled,
}

class Trip extends Equatable {
  final String id;
  final LatLng pickupLocation;
  final String pickupAddress;
  final LatLng destinationLocation;
  final String destinationAddress;
  final CarType selectedCarType;
  final PaymentMethod selectedPaymentMethod;
  final TripStatus status;
  final Driver? driver;
  final double? fare; // Final calculated fare

  const Trip({
    required this.id,
    required this.pickupLocation,
    required this.pickupAddress,
    required this.destinationLocation,
    required this.destinationAddress,
    required this.selectedCarType,
    required this.selectedPaymentMethod,
    this.status = TripStatus.selectingCar,
    this.driver,
    this.fare,
  });

  Trip copyWith({
    String? id,
    LatLng? pickupLocation,
    String? pickupAddress,
    LatLng? destinationLocation,
    String? destinationAddress,
    CarType? selectedCarType,
    PaymentMethod? selectedPaymentMethod,
    TripStatus? status,
    Driver? driver,
    double? fare,
  }) {
    return Trip(
      id: id ?? this.id,
      pickupLocation: pickupLocation ?? this.pickupLocation,
      pickupAddress: pickupAddress ?? this.pickupAddress,
      destinationLocation: destinationLocation ?? this.destinationLocation,
      destinationAddress: destinationAddress ?? this.destinationAddress,
      selectedCarType: selectedCarType ?? this.selectedCarType,
      selectedPaymentMethod:
          selectedPaymentMethod ?? this.selectedPaymentMethod,
      status: status ?? this.status,
      driver: driver ?? this.driver,
      fare: fare ?? this.fare,
    );
  }

  @override
  List<Object?> get props => [
        id,
        pickupLocation,
        pickupAddress,
        destinationLocation,
        destinationAddress,
        selectedCarType,
        selectedPaymentMethod,
        status,
        driver,
        fare,
      ];
}
