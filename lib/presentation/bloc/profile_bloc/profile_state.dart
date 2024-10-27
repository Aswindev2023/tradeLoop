part of 'profile_bloc.dart';

sealed class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

final class ProfileInitial extends ProfileState {}

final class ProfileLoading extends ProfileState {}

final class ProfileLoaded extends ProfileState {
  final UserModel user;

  const ProfileLoaded({required this.user});

  @override
  List<Object> get props => [user];
}

final class ProfileEditMode extends ProfileState {
  final UserModel user;

  const ProfileEditMode({required this.user});

  @override
  List<Object> get props => [user];
}

final class ProfileSaving extends ProfileState {}

final class ProfileSaved extends ProfileState {
  final UserModel user;

  const ProfileSaved({required this.user});

  @override
  List<Object> get props => [user];
}

final class ProfileError extends ProfileState {
  final String message;

  const ProfileError({required this.message});

  @override
  List<Object> get props => [message];
}

final class ImageUploading extends ProfileState {}

final class ImagePickedState extends ProfileState {
  final String imagePath;

  const ImagePickedState({required this.imagePath});

  @override
  List<Object> get props => [imagePath];
}

final class ImageUploadSuccessState extends ProfileState {
  final String imageUrl;

  const ImageUploadSuccessState({required this.imageUrl});

  @override
  List<Object> get props => [imageUrl];
}

final class ImageUploadFailureState extends ProfileState {
  final String message;

  const ImageUploadFailureState({required this.message});

  @override
  List<Object> get props => [message];
}
