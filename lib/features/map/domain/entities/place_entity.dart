import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlaceDetails extends Equatable {
  final String placeId;
  final String name; // This is different from PlaceEntity's 'mainText'
  final String address;
  final LatLng
      location; // This is different from PlaceEntity's 'latLng' (which is nullable)
  final String? phoneNumber;
  final String? website;
  final double? rating;
  final int? userRatingsTotal;

  const PlaceDetails({
    required this.placeId,
    required this.name,
    required this.address,
    required this.location,
    this.phoneNumber,
    this.website,
    this.rating,
    this.userRatingsTotal,
  });

  @override
  List<Object?> get props => [
        placeId,
        name,
        address,
        location,
        phoneNumber,
        website,
        rating,
        userRatingsTotal,
      ];
}
