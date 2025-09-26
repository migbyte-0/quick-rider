import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../domain/entities/trip.dart';

// Make sure this is the correct path to your Driver entity

class DriverModel extends Driver {
  // DriverModel extends Driver (the entity)
  const DriverModel({
    required super.id,
    required super.name,
    required super.imageUrl,
    required super.carModel,
    required super.carPlateNumber,
    required super.carImageUrl,
    required super.currentLocation,
  });

  factory DriverModel.fromJson(Map<String, dynamic> json) {
    return DriverModel(
      id: json['id'],
      name: json['name'],
      imageUrl: json['image_url'],
      carModel: json['car_model'],
      carPlateNumber: json['car_plate_number'],
      carImageUrl: json[
          'car_image_url'], // Corrected from 'image_url' to 'car_image_url' if that's what your API uses
      currentLocation: LatLng(json['lat'], json['lng']),
    );
  }

  // Add the fromEntity factory constructor here
  factory DriverModel.fromEntity(Driver entity) {
    return DriverModel(
      id: entity.id,
      name: entity.name,
      imageUrl: entity.imageUrl,
      carModel: entity.carModel,
      carPlateNumber: entity.carPlateNumber,
      carImageUrl: entity.carImageUrl,
      currentLocation: entity.currentLocation,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image_url': imageUrl,
      'car_model': carModel,
      'car_plate_number': carPlateNumber,
      'car_image_url': carImageUrl,
      'lat': currentLocation.latitude,
      'lng': currentLocation.longitude,
    };
  }
}
