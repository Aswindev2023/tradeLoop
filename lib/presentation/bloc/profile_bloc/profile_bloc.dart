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
      print('Edit button pressed');
      if (state is ProfileLoaded) {
        final user = (state as ProfileLoaded).user;
        emit(ProfileEditMode(user: user));
      }
    });

    on<ProfileImagePicked>((event, emit) {
      if (state is ProfileEditMode) {
        final currentState = state as ProfileEditMode;
        print('profile image picked bloc : ${event.imagePath}');
        emit(currentState.copyWith(pickedImagePath: event.imagePath));
      }
    });

    on<SaveProfileChanges>((event, emit) async {
      print('calling saveprofile changes bloc');

      try {
        String? newImageUrl;
        final currentState = state as ProfileEditMode;

        print('this is the current sate${currentState.pickedImagePath}');
        emit(ProfileSaving());
        if (currentState.pickedImagePath != null &&
            currentState.pickedImagePath!.isNotEmpty) {
          print('Uploading image from: ${currentState.pickedImagePath}');
          // Deleting  old image
          if (event.updatedUser.imagePath != null &&
              event.updatedUser.imagePath!.isNotEmpty) {
            await imageUploadService.deleteImage(event.updatedUser.imagePath!);
          }

          print('Uploading image...');

          // Upload  new image.
          newImageUrl = await imageUploadService
              .uploadImage(currentState.pickedImagePath!);
        }

        print('this is the retrived image url after storing:$newImageUrl');

        final updatingUser = event.updatedUser.copyWith(
          imagePath: newImageUrl ?? event.updatedUser.imagePath,
        );

        print('Attempting to update user: ${updatingUser.uid}');

        await userRepository.updateUser(
          updatingUser.uid!,
          updatingUser.toJson(),
        );

        emit(ProfileLoaded(user: updatingUser));

        print('profile updated sucessfully');
      } catch (e) {
        print('save profile bloc failed$e');
        emit(ProfileError(message: 'Failed to save changes: ${e.toString()}'));
      }
    });
  }
}
