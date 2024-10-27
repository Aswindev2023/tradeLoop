part of 'profile_bloc.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class ProfilePageLoaded extends ProfileEvent {
  final String userId;

  const ProfilePageLoaded({required this.userId});

  @override
  List<Object> get props => [userId];
}

class EditProfilePressed extends ProfileEvent {}

class SaveProfileChanges extends ProfileEvent {
  final UserModel updatedUser;

  const SaveProfileChanges({required this.updatedUser});

  @override
  List<Object> get props => [updatedUser];
}

class PickImage extends ProfileEvent {}
