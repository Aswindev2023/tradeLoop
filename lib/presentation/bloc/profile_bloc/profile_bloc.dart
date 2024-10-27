import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:trade_loop/presentation/authentication/models/user_model.dart';
import 'package:trade_loop/repositories/image_upload_service.dart';
import 'package:trade_loop/repositories/user_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserRepository userRepository = UserRepository();
  final ImageUploadService imageUploadService = ImageUploadService();
  ProfileBloc() : super(ProfileInitial()) {
    on<ProfilePageLoaded>((event, emit) async {
      emit(ProfileLoading());
      try {
        final user = await userRepository.getUser(event.userId);
        emit(ProfileLoaded(user: user!));
      } catch (e) {
        emit(ProfileError(message: 'Failed to load profile: ${e.toString()}'));
      }
    });
    on<EditProfilePressed>((event, emit) {
      if (state is ProfileLoaded) {
        final user = (state as ProfileLoaded).user;
        emit(ProfileEditMode(user: user));
      }
    });
    on<PickImage>((event, emit) async {
      if (state is! ProfileEditMode) return;

      emit(ImageUploading());
      final imagePath = await imageUploadService.pickImage();
      if (imagePath != null) {
        final user = (state as ProfileEditMode).user;
        final updatedUser = user..imagePath = imagePath;
        emit(ProfileEditMode(user: updatedUser));
      } else {
        emit(const ImageUploadFailureState(message: 'No image selected.'));
      }
    });

    on<SaveProfileChanges>((event, emit) async {
      emit(ProfileSaving());
      try {
        String? imageUrl;
        if (event.updatedUser.imagePath != null) {
          imageUrl = await imageUploadService
              .uploadImage(event.updatedUser.imagePath!);
          if (imageUrl != null) {
            event.updatedUser.imagePath = imageUrl;
          }
        }
        await userRepository.updateUser(
            event.updatedUser.uid!, event.updatedUser.toJson());
        emit(ProfileSaved(user: event.updatedUser));
      } catch (e) {
        emit(ProfileError(message: 'Failed to save changes: ${e.toString()}'));
      }
    });
  }
}
