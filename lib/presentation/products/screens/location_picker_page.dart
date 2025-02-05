// ignore_for_file: use_build_context_synchronously, deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart';
import 'package:trade_loop/core/constants/colors.dart';
import 'package:trade_loop/core/utils/custom_text_widget.dart';
import 'package:trade_loop/core/utils/snackbar_utils.dart';
import 'package:trade_loop/presentation/bloc/location_cubit/location_cubit.dart';

class LocationPickerPage extends StatefulWidget {
  const LocationPickerPage({super.key});

  @override
  State<LocationPickerPage> createState() => _LocationPickerPageState();
}

class _LocationPickerPageState extends State<LocationPickerPage> {
  final TextEditingController _searchController = TextEditingController();
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    context.read<LocationCubit>().initializeLocation();
    _initializeLocation();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _initializeLocation() async {
    if (kIsWeb) {
      await _fetchLocationForWeb();
    } else {
      await _fetchUserLocation();
    }
  }

  Future<void> _fetchLocationForWeb() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      context
          .read<LocationCubit>()
          .updateCurrentLocation(LatLng(position.latitude, position.longitude));
      _mapController.move(LatLng(position.latitude, position.longitude), 10.0);
    } catch (e) {
      SnackbarUtils.showSnackbar(context, 'Unable to fetch location: $e');
    }
  }

  Future<void> _fetchUserLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      SnackbarUtils.showSnackbar(
          context, 'Location services are disabled. Please enable them.');
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        SnackbarUtils.showSnackbar(context, 'Location permission denied.');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      SnackbarUtils.showSnackbar(context,
          'Location permissions are permanently denied. Please enable them in settings.');
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      context
          .read<LocationCubit>()
          .updateCurrentLocation(LatLng(position.latitude, position.longitude));
      _mapController.move(LatLng(position.latitude, position.longitude), 10.0);
    } catch (e) {
      SnackbarUtils.showSnackbar(context, 'Failed to fetch location: $e');
    }
  }

  Future<void> _searchLocation(String query) async {
    if (query.isEmpty) {
      SnackbarUtils.showSnackbar(context, 'Please enter a place to search.');
      return;
    }

    try {
      List<Location> locations = await locationFromAddress(query);
      if (locations.isNotEmpty) {
        LatLng searchedLocation =
            LatLng(locations[0].latitude, locations[0].longitude);
        context.read<LocationCubit>().updateCurrentLocation(searchedLocation);
        _mapController.move(searchedLocation, 14.0);
      } else {
        SnackbarUtils.showSnackbar(context, 'No results found for "$query".');
      }
    } catch (e) {
      SnackbarUtils.showSnackbar(context, 'Error searching for location: $e');
    }
  }

  void _confirmLocation() {
    final state = context.read<LocationCubit>().state;
    if (state is LocationLoaded && state.selectedLocation != null) {
      Navigator.pop(context, state.selectedLocation);
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
      body: BlocBuilder<LocationCubit, LocationState>(
        builder: (context, state) {
          LatLng center = (state is LocationLoaded)
              ? state.currentLocation
              : const LatLng(9.931233, 76.267303);
          return Column(
            children: [
              Expanded(
                child: FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: center,
                    initialZoom: 10.0,
                    onTap: (tapPosition, point) {
                      context.read<LocationCubit>().setSelectedLocation(point);
                    },
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                      subdomains: const ['a', 'b', 'c'],
                    ),
                    if (state is LocationLoaded &&
                        state.selectedLocation != null)
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: state.selectedLocation!,
                            child: const Icon(
                              Icons.location_pin,
                              color: red,
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
                child: CustomTextWidget(
                  text: (state is LocationLoaded &&
                          state.selectedLocation != null)
                      ? "Selected Location: (${state.selectedLocation!.latitude.toStringAsFixed(5)}, ${state.selectedLocation!.longitude.toStringAsFixed(5)})"
                      : "Tap on the map to pick a location.",
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
