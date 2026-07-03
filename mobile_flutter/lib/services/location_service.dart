import 'package:geolocator/geolocator.dart';

class LocationService {
  LocationService._();

  static Future<Position> getCurrentLocation() async {
    bool serviceEnabled =
    await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      throw Exception("Le GPS est désactivé.");
    }

    LocationPermission permission =
    await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission =
      await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      throw Exception("Permission refusée.");
    }

    if (permission ==
        LocationPermission.deniedForever) {
      throw Exception(
        "Permission refusée définitivement.",
      );
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }
}