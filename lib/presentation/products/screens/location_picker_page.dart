import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:trade_loop/core/utils/snackbar_utils.dart';

class LocationPickerPage extends StatefulWidget {
  const LocationPickerPage({super.key});

  @override
  State<LocationPickerPage> createState() => _LocationPickerPageState();
}

class _LocationPickerPageState extends State<LocationPickerPage> {
  LatLng? _selectedLocation;
  LatLng _currentLocation = const LatLng(9.931233, 76.267303);

  @override
  void initState() {
    super.initState();
    _fetchUserLocation();
  }

  Future<void> requestLocationPermission() async {
    // Request location permission using permission_handler
    if (await Permission.location.request().isGranted && mounted) {
      // Permission granted
    } else {
      // Permission denied
      SnackbarUtils.showSnackbar(
          context, 'Location permission is required to pick a location.');
    }
  }

  Future<void> _fetchUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled && mounted) {
      SnackbarUtils.showSnackbar(
          context, 'Location services are disabled. Please enable them.');
      return;
    }
    await requestLocationPermission();
    // Check location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied && mounted) {
        SnackbarUtils.showSnackbar(context, 'Location permission denied.');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever && mounted) {
      SnackbarUtils.showSnackbar(context,
          'Location permissions are permanently denied. Please enable them in settings.');
      return;
    }

    // Get current position
    Position position = await Geolocator.getCurrentPosition(
      // ignore: deprecated_member_use
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
      _selectedLocation = _currentLocation;
    });
  }

  void _confirmLocation() {
    if (_selectedLocation != null) {
      Navigator.pop(context, _selectedLocation);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a location first.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Pick Location'),
          actions: [
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: _confirmLocation,
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: _currentLocation,
                  initialZoom: 10.0,
                  onTap: (tapPosition, point) {
                    setState(() {
                      _selectedLocation = point;
                    });
                  },
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                    subdomains: const ['a', 'b', 'c'],
                  ),
                  if (_selectedLocation != null)
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: _selectedLocation!,
                          child: const Icon(
                            Icons.location_pin,
                            color: Colors.red,
                            size: 40,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                _selectedLocation != null
                    ? "Selected Location: (${_selectedLocation!.latitude.toStringAsFixed(5)}, ${_selectedLocation!.longitude.toStringAsFixed(5)})"
                    : "Tap on the map to pick a location.",
              ),
            ),
          ],
        ));
  }
}
