import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart';
import 'package:trade_loop/presentation/bloc/product_bloc/product_bloc.dart';
import 'package:trade_loop/presentation/products/screens/location_picker_page.dart';

Future<void> selectLocation(BuildContext context) async {
  final LatLng? pickedLocation = await Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const LocationPickerPage()),
  );
  print('Returned location coordinates from location picker: $pickedLocation');

  if (pickedLocation != null) {
    try {
      String locationName;
      if (kIsWeb) {
        // Use Nominatim API for web
        final url = Uri.parse(
            'https://nominatim.openstreetmap.org/reverse?lat=${pickedLocation.latitude}&lon=${pickedLocation.longitude}&format=json');
        final response = await http.get(url);

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          locationName = data['address'] != null
              ? "${data['address']['city'] ?? data['address']['town'] ?? data['address']['village']}, ${data['address']['state']}, ${data['address']['country']}"
              : "Unknown Location";
          print('Location name fetched from Nominatim: $locationName');
        } else {
          throw Exception('Failed to fetch location name for web.');
        }
      } else {
        // Use placemarkFromCoordinates for mobile
        List<Placemark> placemarks = await placemarkFromCoordinates(
          pickedLocation.latitude,
          pickedLocation.longitude,
        );
        print('Placemark of the location: $placemarks');
        locationName = placemarks.isNotEmpty
            ? "${placemarks.first.locality}, ${placemarks.first.administrativeArea}, ${placemarks.first.country}"
            : "Unknown Location";
      }

      context.read<ProductBloc>().add(UpdateLocation(
            pickedLocation: pickedLocation,
            locationName: locationName,
          ));

      print("Selected Location Name: $locationName");
    } catch (e) {
      context.read<ProductBloc>().add(UpdateLocation(
            pickedLocation: pickedLocation,
            locationName: "Unknown Location",
          ));
      print('Error in reverse geocoding: $e');
    }
  }
}
