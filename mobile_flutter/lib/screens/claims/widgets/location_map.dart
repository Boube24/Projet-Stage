import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationMap extends StatefulWidget {

  final double latitude;

  final double longitude;

  final Function(
      double latitude,
      double longitude,
      ) onLocationChanged;

  const LocationMap({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.onLocationChanged,
  });

  @override
  State<LocationMap> createState() =>
      _LocationMapState();
}

class _LocationMapState
    extends State<LocationMap> {

  late GoogleMapController _controller;

  late Marker _marker;

  @override
  void initState() {

    super.initState();

    _marker = Marker(

      markerId:
      const MarkerId("claim"),

      position: LatLng(
        widget.latitude,
        widget.longitude,
      ),

      draggable: true,

      onDragEnd: (position) {

        widget.onLocationChanged(
          position.latitude,
          position.longitude,
        );

      },

    );

  }

  @override
  Widget build(BuildContext context) {

    return SizedBox(

      height: 300,

      child: GoogleMap(

        initialCameraPosition:
        CameraPosition(

          target: LatLng(
            widget.latitude,
            widget.longitude,
          ),

          zoom: 15,

        ),

        markers: {_marker},

        onMapCreated: (controller) {

          _controller = controller;

        },

        onTap: (position) {

          setState(() {

            _marker = Marker(

              markerId:
              const MarkerId("claim"),

              position: position,

              draggable: true,

              onDragEnd: (newPosition) {

                widget.onLocationChanged(
                  newPosition.latitude,
                  newPosition.longitude,
                );

              },

            );

          });

          widget.onLocationChanged(
            position.latitude,
            position.longitude,
          );

        },

        myLocationEnabled: true,

        myLocationButtonEnabled: true,

      ),

    );

  }

}