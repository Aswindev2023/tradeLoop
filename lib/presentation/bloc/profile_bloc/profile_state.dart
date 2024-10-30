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
  final String? pickedImagePath;

  const ProfileEditMode({required this.user, this.pickedImagePath});
  ProfileEditMode copyWith({
    UserModel? user,
    String? pickedImagePath,
  }) {
    return ProfileEditMode(
      user: user ?? this.user,
      pickedImagePath: pickedImagePath ?? this.pickedImagePath,
    );
  }

  @override
  List<Object> get props => [user, pickedImagePath ?? ''];
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
