import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart';
import 'package:trade_loop/core/utils/snackbar_utils.dart';

class LocationPickerPage extends StatefulWidget {
  const LocationPickerPage({super.key});

  @override
  State<LocationPickerPage> createState() => _LocationPickerPageState();
}

class _LocationPickerPageState extends State<LocationPickerPage> {
  LatLng? _selectedLocation;
  LatLng _currentLocation = const LatLng(9.931233, 76.267303);
  final TextEditingController _searchController = TextEditingController();
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _initializeLocation() async {
    if (kIsWeb) {
      // Web-specific geolocation handling
      await _fetchLocationForWeb();
    } else {
      // Mobile-specific geolocation handling
      await _fetchUserLocation();
    }
  }

  Future<void> _fetchLocationForWeb() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        // ignore: deprecated_member_use
        desiredAccuracy: LocationAccuracy.high,
      );
      print(
          'fetched location for web is:latitude:${position.latitude}and longitude:${position.longitude} ');
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
        _selectedLocation = _currentLocation;
      });
      _mapController.move(_currentLocation, 10.0);
    } catch (e) {
      if (mounted) {
        SnackbarUtils.showSnackbar(
          context,
          'Unable to fetch location: $e',
        );
      }
    }
  }

  Future<void> _fetchUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (mounted) {
        SnackbarUtils.showSnackbar(
            context, 'Location services are disabled. Please enable them.');
      }
      return;
    }

    // Request location permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (mounted) {
          SnackbarUtils.showSnackbar(context, 'Location permission denied.');
        }
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (mounted) {
        SnackbarUtils.showSnackbar(context,
            'Location permissions are permanently denied. Please enable them in settings.');
      }
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        // ignore: deprecated_member_use
        desiredAccuracy: LocationAccuracy.high,
      );

      if (mounted) {
        setState(() {
          _currentLocation = LatLng(position.latitude, position.longitude);
          _selectedLocation = _currentLocation;
        });
        _mapController.move(_currentLocation, 10.0);
      }
    } catch (e) {
      if (mounted) {
        SnackbarUtils.showSnackbar(context, 'Failed to fetch location: $e');
      }
    }
  }

  Future<void> _searchLocation(String query) async {
    if (query.isEmpty) {
      SnackbarUtils.showSnackbar(context, 'Please enter a place to search.');
      return;
    }

    try {
      List<Location> locations = await locationFromAddress(query);
      print('searched result is:$locations');
      if (locations.isNotEmpty) {
        LatLng searchedLocation =
            LatLng(locations[0].latitude, locations[0].longitude);
        print('searched location = $searchedLocation');
        setState(() {
          _currentLocation = searchedLocation;
          _selectedLocation = searchedLocation;
        });
        _mapController.move(searchedLocation, 14.0);
      } else {
        SnackbarUtils.showSnackbar(context, 'No results found for "$query".');
      }
    } catch (e) {
      SnackbarUtils.showSnackbar(context, 'Error searching for location: $e');
    }
  }

  void _confirmLocation() {
    if (_selectedLocation != null) {
      print('seleted location is:$_selectedLocation');
      Navigator.pop(context, _selectedLocation);
    } else {
      SnackbarUtils.showSnackbar(context, 'Please select a location first.');
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
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search for a place',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                  },
                ),
              ),
              onSubmitted: _searchLocation,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: FlutterMap(
              mapController: _mapController,
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
                  urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              _selectedLocation != null
                  ? "Selected Location: (${_selectedLocation!.latitude.toStringAsFixed(5)}, ${_selectedLocation!.longitude.toStringAsFixed(5)})"
                  : "Tap on the map to pick a location.",
            ),
          ),
        ],
      ),
    );
  }
}
