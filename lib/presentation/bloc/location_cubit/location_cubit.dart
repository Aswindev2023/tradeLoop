import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';

part 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  LocationCubit() : super(LocationInitial());

  void initializeLocation() {
    const LatLng initialLocation = LatLng(9.931233, 76.267303);
    emit(const LocationLoaded(currentLocation: initialLocation));
  }

  void setSelectedLocation(LatLng location) {
    if (state is LocationLoaded) {
      emit((state as LocationLoaded).copyWith(selectedLocation: location));
    }
  }

  void updateCurrentLocation(LatLng location) {
    if (state is LocationLoaded) {
      emit((state as LocationLoaded)
          .copyWith(currentLocation: location, selectedLocation: location));
    }
  }
}
