// lib/core/services/location_service.dart
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart'; // Make sure this is imported

abstract class LocationService {
  Future<LatLng> getCurrentLocation();
  Stream<Position> getPositionStream();
  // Add other location-related methods your app might need
}

class LiveLocationService implements LocationService {
  final GeolocatorPlatform _geolocatorPlatform;

  LiveLocationService(this._geolocatorPlatform);

  @override
  Future<LatLng> getCurrentLocation() async {
    // Check permissions and handle errors here if not done elsewhere
    final position = await _geolocatorPlatform.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );
    return LatLng(position.latitude, position.longitude);
  }

  @override
  Stream<Position> getPositionStream() {
    // You might want to define custom settings for the stream
    return _geolocatorPlatform.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // Update every 10 meters
      ),
    );
  }
}
