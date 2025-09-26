import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DriverEntity extends Equatable {
  final String id;
  final String name;
  final LatLng location;
  final double rating;
  final String? imageUrl; // Optional: for driver's profile picture
  final String? carModel; // Optional: e.g., "Toyota Camry"
  final String? carPlateNumber; // Optional: e.g., "ABC 123"

  const DriverEntity({
    required this.id,
    required this.name,
    required this.location,
    required this.rating,
    this.imageUrl,
    this.carModel,
    this.carPlateNumber,
  });

  @override
  List<Object?> get props =>
      [id, name, location, rating, imageUrl, carModel, carPlateNumber];
}
