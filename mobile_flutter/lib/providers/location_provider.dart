import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../services/location_service.dart';

class LocationProvider extends ChangeNotifier {

  Position? _currentPosition;

  Position? get currentPosition => _currentPosition;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  String? _error;

  String? get error => _error;

  Future<void> loadCurrentLocation() async {

    try {

      _isLoading = true;
      _error = null;

      notifyListeners();

      _currentPosition =
      await LocationService.getCurrentLocation();

    } catch (e) {

      _error = e.toString();

    } finally {

      _isLoading = false;

      notifyListeners();
    }
  }

  double? get latitude =>
      _currentPosition?.latitude;

  double? get longitude =>
      _currentPosition?.longitude;

  void updateLocation(
      double latitude,
      double longitude,
      ) {

    if (_currentPosition == null) return;

    _currentPosition = Position(
      latitude: latitude,
      longitude: longitude,
      timestamp: DateTime.now(),
      accuracy: _currentPosition!.accuracy,
      altitude: _currentPosition!.altitude,
      altitudeAccuracy:
      _currentPosition!.altitudeAccuracy,
      heading: _currentPosition!.heading,
      headingAccuracy:
      _currentPosition!.headingAccuracy,
      speed: _currentPosition!.speed,
      speedAccuracy:
      _currentPosition!.speedAccuracy,
    );

    notifyListeners();
  }
}