// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trade_loop/core/utils/snackbar_utils.dart';
import 'package:trade_loop/presentation/bloc/location_cubit/location_cubit.dart';

class LocationHelper {
  final BuildContext context;
  final MapController mapController;

  LocationHelper({required this.context, required this.mapController});

  Future<void> initializeLocation() async {
    if (kIsWeb) {
      await fetchLocationForWeb();
    } else {
      await fetchUserLocation();
    }
  }

  Future<void> fetchLocationForWeb() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      if (context.mounted) {
        context.read<LocationCubit>().updateCurrentLocation(
            LatLng(position.latitude, position.longitude));
        mapController.move(LatLng(position.latitude, position.longitude), 10.0);
      }
    } catch (e) {
      if (context.mounted) {
        SnackbarUtils.showSnackbar(context, 'Unable to fetch location: $e');
      }
    }
  }

  Future<void> fetchUserLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (context.mounted) {
        SnackbarUtils.showSnackbar(
            context, 'Location services are disabled. Please enable them.');
      }
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied && context.mounted) {
        SnackbarUtils.showSnackbar(context, 'Location permission denied.');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever && context.mounted) {
      SnackbarUtils.showSnackbar(context,
          'Location permissions are permanently denied. Please enable them in settings.');
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      if (context.mounted) {
        context.read<LocationCubit>().updateCurrentLocation(
            LatLng(position.latitude, position.longitude));
        mapController.move(LatLng(position.latitude, position.longitude), 10.0);
      }
    } catch (e) {
      if (context.mounted) {
        SnackbarUtils.showSnackbar(context, 'Failed to fetch location: $e');
      }
    }
  }

  Future<void> searchLocation(String query) async {
    if (query.isEmpty) {
      if (context.mounted) {
        SnackbarUtils.showSnackbar(context, 'Please enter a place to search.');
      }
      return;
    }

    try {
      List<Location> locations = await locationFromAddress(query);
      if (locations.isNotEmpty) {
        LatLng searchedLocation =
            LatLng(locations[0].latitude, locations[0].longitude);
        if (context.mounted) {
          context.read<LocationCubit>().updateCurrentLocation(searchedLocation);
          mapController.move(searchedLocation, 14.0);
        }
      } else if (context.mounted) {
        SnackbarUtils.showSnackbar(context, 'No results found for "$query".');
      }
    } catch (e) {
      if (context.mounted) {
        SnackbarUtils.showSnackbar(context, 'Error searching for location: $e');
      }
    }
  }

  void confirmLocation() {
    if (!context.mounted) return;
    final state = context.read<LocationCubit>().state;
    if (state is LocationLoaded && state.selectedLocation != null) {
      Navigator.pop(context, state.selectedLocation);
    } else {
      SnackbarUtils.showSnackbar(context, 'Please select a location first.');
    }
  }
}
