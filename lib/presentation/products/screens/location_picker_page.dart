import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:trade_loop/core/constants/colors.dart';
import 'package:trade_loop/core/utils/custom_text_widget.dart';
import 'package:trade_loop/core/utils/location_helper.dart';
import 'package:trade_loop/presentation/bloc/location_cubit/location_cubit.dart';

class LocationPickerPage extends StatefulWidget {
  const LocationPickerPage({super.key});

  @override
  State<LocationPickerPage> createState() => _LocationPickerPageState();
}

class _LocationPickerPageState extends State<LocationPickerPage> {
  final TextEditingController _searchController = TextEditingController();
  final MapController _mapController = MapController();
  late LocationHelper _locationHelper;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _locationHelper =
        LocationHelper(context: context, mapController: _mapController);
  }

  @override
  void initState() {
    super.initState();
    context.read<LocationCubit>().initializeLocation();
    Future.microtask(() => _locationHelper.initializeLocation());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pick Location'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _locationHelper.confirmLocation,
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
                  onPressed: () => _searchController.clear(),
                ),
              ),
              onSubmitted: _locationHelper.searchLocation,
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
