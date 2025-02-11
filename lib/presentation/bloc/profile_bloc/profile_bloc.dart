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
    //Get user's profile
    on<ProfilePageLoaded>((event, emit) async {
      emit(ProfileLoading());
      try {
        final user = await userRepository.getUser(event.userId);
        emit(ProfileLoaded(user: user!));
      } catch (e) {
        emit(ProfileError(message: 'Failed to load profile: ${e.toString()}'));
      }
    });
    //Start edit user profile event
    on<EditProfilePressed>((event, emit) {
      if (state is ProfileLoaded) {
        final user = (state as ProfileLoaded).user;
        emit(ProfileEditMode(user: user));
      }
    });
    //Picking image for profile
    on<ProfileImagePicked>((event, emit) {
      if (state is ProfileEditMode) {
        final currentState = state as ProfileEditMode;

        emit(currentState.copyWith(pickedImagePath: event.imagePath));
      }
    });
    //Save edited data
    on<SaveProfileChanges>((event, emit) async {
      try {
        String? newImageUrl;
        final currentState = state as ProfileEditMode;

        emit(ProfileSaving());
        if (currentState.pickedImagePath != null &&
            currentState.pickedImagePath!.isNotEmpty) {
          // Deleting  old image
          if (event.updatedUser.imagePath != null &&
              event.updatedUser.imagePath!.isNotEmpty) {
            await imageUploadService.deleteImage(event.updatedUser.imagePath!);
          }

          // Upload  new image.
          newImageUrl = await imageUploadService
              .uploadImage(currentState.pickedImagePath!);
        }

        final updatingUser = event.updatedUser.copyWith(
          imagePath: newImageUrl ?? event.updatedUser.imagePath,
        );

        await userRepository.updateUser(
          updatingUser.uid!,
          updatingUser.toJson(),
        );

        emit(ProfileLoaded(user: updatingUser));
      } catch (e) {
        emit(ProfileError(message: 'Failed to save changes: ${e.toString()}'));
      }
    });
  }
}
