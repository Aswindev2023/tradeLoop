import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trade_loop/core/utils/snackbar_utils.dart';
import 'package:trade_loop/presentation/bloc/profile_bloc/profile_bloc.dart';
import 'package:trade_loop/presentation/profile/widgets/custom_text_field.dart';
import 'package:trade_loop/presentation/profile/widgets/edit_button.dart';
import 'package:trade_loop/presentation/profile/widgets/profile_image_widget.dart';
import 'package:trade_loop/presentation/profile/widgets/profile_page_validation.dart';

class ImageSection extends StatelessWidget {
  final ProfileState state;

  const ImageSection({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    String? initialImageUrl;
    bool isEditable = false;

    if (state is ProfileLoaded) {
      initialImageUrl = (state as ProfileLoaded).user.imagePath;
    } else if (state is ProfileEditMode) {
      initialImageUrl = (state as ProfileEditMode).user.imagePath;
      isEditable = true;
    }

    return Column(
      children: [
        const SizedBox(height: 15),
        ProfileImage(
          initialImageUrl: initialImageUrl,
          isEditable: isEditable,
          onImagePicked: (path) {
            if (path != null) {
              context
                  .read<ProfileBloc>()
                  .add(ProfileImagePicked(imagePath: path));
            }
          },
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

//Text Fields Section
class TextFieldsSection extends StatelessWidget {
  final ProfileState state;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController mobileController;
  final TextEditingController houseController;
  final TextEditingController cityController;
  final TextEditingController streetController;
  final TextEditingController stateController;
  final TextEditingController countryController;
  final TextEditingController postalController;

  const TextFieldsSection({
    super.key,
    required this.state,
    required this.nameController,
    required this.emailController,
    required this.mobileController,
    required this.houseController,
    required this.cityController,
    required this.streetController,
    required this.stateController,
    required this.countryController,
    required this.postalController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextField(
          label: 'Name',
          controller: nameController,
          isEditable: state is ProfileEditMode,
        ),
        CustomTextField(
          label: 'Email',
          controller: emailController,
          isEditable: state is ProfileEditMode,
        ),
        CustomTextField(
          label: 'House Number / Apartment Name',
          controller: houseController,
          isEditable: state is ProfileEditMode,
        ),
        CustomTextField(
          label: 'Street Address',
          controller: streetController,
          isEditable: state is ProfileEditMode,
        ),
        CustomTextField(
          label: 'Zip Code/Postal Code',
          controller: postalController,
          isEditable: state is ProfileEditMode,
        ),
        CustomTextField(
          label: 'City',
          controller: cityController,
          isEditable: state is ProfileEditMode,
        ),
        CustomTextField(
          label: 'State',
          controller: stateController,
          isEditable: state is ProfileEditMode,
        ),
        CustomTextField(
          label: 'Country',
          controller: countryController,
          isEditable: state is ProfileEditMode,
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

//Edit & Save Button Section
class ButtonSection extends StatelessWidget {
  final ProfileState state;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController mobileController;
  final TextEditingController houseController;
  final TextEditingController cityController;
  final TextEditingController streetController;
  final TextEditingController stateController;
  final TextEditingController countryController;
  final TextEditingController postalController;

  const ButtonSection({
    super.key,
    required this.state,
    required this.nameController,
    required this.emailController,
    required this.mobileController,
    required this.houseController,
    required this.cityController,
    required this.streetController,
    required this.stateController,
    required this.countryController,
    required this.postalController,
  });

  @override
  Widget build(BuildContext context) {
    return EditButton(
      isEditing: state is ProfileEditMode,
      onPressed: () {
        if (state is ProfileEditMode) {
          final validation = ProfilePageValidation(
            emailController.text,
            nameController.text,
            mobileController.text,
            postalController.text,
          );

          if (validation.isValidEdit(
            emailController.text,
            nameController.text,
            mobileController.text,
            postalController.text,
          )) {
            final updateUser = (state as ProfileEditMode).user.copyWith(
                  uid: FirebaseAuth.instance.currentUser!.uid,
                  name: nameController.text,
                  email: emailController.text,
                  city: cityController.text,
                  state: stateController.text,
                  street: streetController.text,
                  postalCode: postalController.text,
                  country: countryController.text,
                  houseName: houseController.text,
                  phone: mobileController.text,
                );
            context
                .read<ProfileBloc>()
                .add(SaveProfileChanges(updatedUser: updateUser));
            SnackbarUtils.showSnackbar(context, 'Profile Saved');
          } else {
            SnackbarUtils.showSnackbar(
                context, 'Invalid input in one or more fields');
          }
        } else {
          context.read<ProfileBloc>().add(EditProfilePressed());
        }
      },
    );
  }
}
