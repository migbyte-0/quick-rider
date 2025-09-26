import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:quickrider/features/map/data/models/payment_method.dart'
    show PaymentMethodModel;

import '../../domain/entities/trip.dart';
import 'car_type_model.dart';
import 'driver_model.dart';

class TripModel extends Trip {
  const TripModel({
    required super.id,
    required super.pickupLocation,
    required super.pickupAddress,
    required super.destinationLocation,
    required super.destinationAddress,
    required super.selectedCarType,
    required super.selectedPaymentMethod,
    super.status,
    super.driver,
    super.fare,
  });

  factory TripModel.fromJson(Map<String, dynamic> json) {
    return TripModel(
      id: json['id'],
      pickupLocation: LatLng(json['pickup_lat'], json['pickup_lng']),
      pickupAddress: json['pickup_address'],
      destinationLocation:
          LatLng(json['destination_lat'], json['destination_lng']),
      destinationAddress: json['destination_address'],
      selectedCarType: CarTypeModel.fromJson(json['selected_car_type']),
      selectedPaymentMethod:
          PaymentMethodModel.fromJson(json['selected_payment_method']),
      status: TripStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => TripStatus.selectingCar,
      ),
      driver:
          json['driver'] != null ? DriverModel.fromJson(json['driver']) : null,
      fare: (json['fare'] as num?)?.toDouble(),
    );
  }

  factory TripModel.fromEntity(Trip trip) {
    return TripModel(
      id: trip.id,
      pickupLocation: trip.pickupLocation,
      pickupAddress: trip.pickupAddress,
      destinationLocation: trip.destinationLocation,
      destinationAddress: trip.destinationAddress,
      selectedCarType: CarTypeModel.fromEntity(trip.selectedCarType),
      selectedPaymentMethod:
          PaymentMethodModel.fromEntity(trip.selectedPaymentMethod),
      status: trip.status,
      driver: trip.driver != null ? DriverModel.fromEntity(trip.driver!) : null,
      fare: trip.fare,
    );
  }

  // Helper for mock data in stream
  static TripModel mockTrip(
      {required String tripId, required TripStatus status}) {
    const CarTypeModel mockCarType = CarTypeModel(
      id: 'comfort',
      name: 'Comfort',
      minPrice: 20,
      maxPrice: 40,
      seats: 4,
      imageUrl: 'assets/images/car_comfort.png',
      etaMinutes: 2,
    );
    final PaymentMethodModel mockPaymentMethod = PaymentMethodModel.cash();
    const DriverModel mockDriver = DriverModel(
      id: 'DRV001',
      name: 'Ahmed',
      imageUrl: 'assets/images/driver_ahmed.png',
      carModel: 'Toyota Camry',
      carPlateNumber: '3892',
      carImageUrl: 'assets/images/car_camry.png',
      currentLocation: LatLng(24.137, 47.279),
    );

    return TripModel(
      id: tripId,
      pickupLocation: const LatLng(24.136, 47.278),
      pickupAddress: 'Current Location',
      destinationLocation: const LatLng(24.140, 47.280),
      destinationAddress: 'الدلم Saudi Arabia',
      selectedCarType: mockCarType,
      selectedPaymentMethod: mockPaymentMethod,
      status: status,
      driver: mockDriver,
      fare: 35.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pickup_lat': pickupLocation.latitude,
      'pickup_lng': pickupLocation.longitude,
      'pickup_address': pickupAddress,
      'destination_lat': destinationLocation.latitude,
      'destination_lng': destinationLocation.longitude,
      'destination_address': destinationAddress,
      'selected_car_type': (selectedCarType as CarTypeModel).toJson(),
      'selected_payment_method':
          (selectedPaymentMethod as PaymentMethodModel).toJson(),
      'status': status.toString().split('.').last,
      'driver': (driver as DriverModel?)?.toJson(),
      'fare': fare,
    };
  }
}
