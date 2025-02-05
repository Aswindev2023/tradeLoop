part of 'location_cubit.dart';

sealed class LocationState extends Equatable {
  const LocationState();

  @override
  List<Object?> get props => [];
}

final class LocationInitial extends LocationState {}

final class LocationLoaded extends LocationState {
  final LatLng currentLocation;
  final LatLng? selectedLocation;

  const LocationLoaded({
    required this.currentLocation,
    this.selectedLocation,
  });

  LocationLoaded copyWith({LatLng? currentLocation, LatLng? selectedLocation}) {
    return LocationLoaded(
      currentLocation: currentLocation ?? this.currentLocation,
      selectedLocation: selectedLocation ?? this.selectedLocation,
    );
  }

  @override
  List<Object?> get props => [currentLocation, selectedLocation];
}
