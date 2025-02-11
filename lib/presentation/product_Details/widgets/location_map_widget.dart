import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:trade_loop/core/constants/colors.dart';

class LocationMapWidget extends StatelessWidget {
  final double latitude;
  final double longitude;

  const LocationMapWidget({
    super.key,
    required this.latitude,
    required this.longitude,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: grey),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: FlutterMap(
          options: MapOptions(
            initialCenter: LatLng(latitude, longitude),
            initialZoom: 13.0,
          ),
          children: [
            // Loads map tiles from OpenStreetMap
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.trade_loop',
            ),
            // Adds a marker to indicate the location
            MarkerLayer(
              markers: [
                Marker(
                  point: LatLng(latitude, longitude),
                  child: const Icon(
                    Icons.location_on,
                    color: red,
                    size: 30.0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
