import 'package:google_maps_flutter/google_maps_flutter.dart';

class DriverEntity {
  final String id;
  final String name;
  final LatLng location;
  final double rating;

  DriverEntity({
    required this.id,
    required this.name,
    required this.location,
    required this.rating,
  });

  DriverEntity copyWith({
    String? id,
    String? name,
    LatLng? location,
    double? rating,
  }) {
    return DriverEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      location: location ?? this.location,
      rating: rating ?? this.rating,
    );
  }
}
