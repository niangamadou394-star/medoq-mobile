import 'package:geolocator/geolocator.dart';
import '../shared/utils/constants.dart';

class LocationResult {
  final double latitude;
  final double longitude;
  final double? accuracy;

  const LocationResult({
    required this.latitude,
    required this.longitude,
    this.accuracy,
  });

  static const LocationResult defaultLocation = LocationResult(
    latitude: AppConstants.defaultLatitude,
    longitude: AppConstants.defaultLongitude,
  );
}

class LocationService {
  static Future<bool> requestPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  static Future<LocationResult> getCurrentLocation() async {
    try {
      final hasPermission = await requestPermission();
      if (!hasPermission) {
        return LocationResult.defaultLocation;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      return LocationResult(
        latitude: position.latitude,
        longitude: position.longitude,
        accuracy: position.accuracy,
      );
    } catch (e) {
      // Return Dakar as default fallback
      return LocationResult.defaultLocation;
    }
  }

  static Future<LocationPermission> getPermissionStatus() async {
    return await Geolocator.checkPermission();
  }

  static Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  static Future<void> openLocationSettings() async {
    await Geolocator.openLocationSettings();
  }

  static double calculateDistance({
    required double startLat,
    required double startLng,
    required double endLat,
    required double endLng,
  }) {
    return Geolocator.distanceBetween(startLat, startLng, endLat, endLng);
  }

  static Stream<Position> getPositionStream() {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 50, // Update every 50 meters
      ),
    );
  }
}
