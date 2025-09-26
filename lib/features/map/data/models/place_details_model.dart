import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../domain/entities/place_entity.dart';

class PlaceDetailsModel extends PlaceDetails {
  const PlaceDetailsModel({
    required super.placeId,
    required super.name,
    required super.address,
    required super.location,
    super.phoneNumber,
    super.website,
    super.rating,
    super.userRatingsTotal,
  });

  factory PlaceDetailsModel.fromJson(Map<String, dynamic> json) {
    final geometry = json['geometry'] as Map<String, dynamic>?;
    final location = geometry?['location'] as Map<String, dynamic>?;

    // Ensure lat and lng are not null before creating LatLng
    final double? lat = location?['lat'] as double?;
    final double? lng = location?['lng'] as double?;

    if (lat == null || lng == null) {
      throw const FormatException(
          'Invalid or missing location data for PlaceDetailsModel.fromJson');
    }

    return PlaceDetailsModel(
      placeId: json['place_id'] as String,
      name: json['name'] as String,
      address: json['formatted_address'] as String,
      location: LatLng(lat, lng), // Use the non-nullable lat/lng
      phoneNumber: json['international_phone_number'] as String?,
      website: json['website'] as String?,
      rating: (json['rating'] as num?)?.toDouble(),
      userRatingsTotal: json['user_ratings_total'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'place_id': placeId,
      'name': name,
      'formatted_address': address,
      'geometry': {
        'location': {
          'lat': location.latitude,
          'lng': location.longitude,
        }
      },
      'international_phone_number': phoneNumber,
      'website': website,
      'rating': rating,
      'user_ratings_total': userRatingsTotal,
    };
  }

  factory PlaceDetailsModel.fromEntity(PlaceDetails entity) {
    return PlaceDetailsModel(
      placeId: entity.placeId,
      name: entity.name,
      address: entity.address,
      location: entity.location,
      phoneNumber: entity.phoneNumber,
      website: entity.website,
      rating: entity.rating,
      userRatingsTotal: entity.userRatingsTotal,
    );
  }
}
