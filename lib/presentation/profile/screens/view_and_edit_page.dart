import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trade_loop/core/utils/form_validation_message.dart';
import 'package:trade_loop/core/utils/snackbar_utils.dart';

import 'package:trade_loop/presentation/authentication/models/user_model.dart';
import 'package:trade_loop/presentation/bloc/profile_bloc/profile_bloc.dart';
import 'package:trade_loop/presentation/profile/widgets/custom_text_field.dart';
import 'package:trade_loop/presentation/profile/widgets/edit_button.dart';
import 'package:trade_loop/presentation/profile/widgets/profile_image_widget.dart';

class ViewAndEditPage extends StatefulWidget {
  const ViewAndEditPage({super.key});

  @override
  State<ViewAndEditPage> createState() => _ViewAndEditPageState();
}

class _ViewAndEditPageState extends State<ViewAndEditPage> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController mobileController;
  late TextEditingController houseController;
  late TextEditingController cityController;
  late TextEditingController streetController;
  late TextEditingController stateController;
  late TextEditingController countryController;
  late TextEditingController postalController;
  String? imagePath;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    emailController = TextEditingController();
    mobileController = TextEditingController();
    houseController = TextEditingController();
    cityController = TextEditingController();
    streetController = TextEditingController();
    stateController = TextEditingController();
    countryController = TextEditingController();
    postalController = TextEditingController();

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      context.read<ProfileBloc>().add(ProfilePageLoaded(userId: user.uid));
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    mobileController.dispose();
    houseController.dispose();
    cityController.dispose();
    streetController.dispose();
    stateController.dispose();
    countryController.dispose();
    postalController.dispose();
    super.dispose();
  }

  bool validation(String value, String fieldName) {
    switch (fieldName) {
      case 'name':
        return FormValidators.isValidName(value) &&
            FormValidators.validateForm(value, 'Name') == null;
      case 'email':
        return FormValidators.isValidEmail(value) &&
            FormValidators.validateForm(value, 'Email') == null;
      case 'number':
        return FormValidators.isValidNumber(value) &&
            FormValidators.validateForm(value, 'Phone number') == null;
      case 'zipCode':
        return FormValidators.isValidZip(value) &&
            FormValidators.validateForm(value, 'Zip code') == null;
      default:
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 17, 28, 233),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: const Text(
          'View & Edit Profile',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoaded) {
            nameController.text = state.user.name;
            emailController.text = state.user.email;
            houseController.text = state.user.houseName ?? '';
            streetController.text = state.user.street ?? '';
            countryController.text = state.user.country ?? '';
            stateController.text = state.user.state ?? '';
            mobileController.text = state.user.phone ?? '';
            cityController.text = state.user.city ?? '';
            postalController.text = state.user.postalCode ?? '';
            imagePath = state.user.imagePath ?? '';
          } else if (state is ImageUploadFailureState) {
            SnackbarUtils.showSnackbar(context, state.message);
          }
        },
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 15),
                  ProfileImage(
                    imageUrl: imagePath ?? '',
                    onPickImage: () {
                      if (state is ProfileEditMode) {
                        context.read<ProfileBloc>().add(PickImage());
                      }
                    },
                  ),
                  const SizedBox(height: 20),
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
                    label: 'Phone',
                    controller: mobileController,
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
                  EditButton(
                    isEditing: state is ProfileEditMode,
                    onPressed: () {
                      if (state is ProfileEditMode) {
                        final name = nameController.text;
                        final email = emailController.text;
                        final phone = mobileController.text;
                        final zipCode = postalController.text;
                        if (validation(name, 'name') &&
                            validation(email, 'email') &&
                            validation(phone, 'number') &&
                            validation(zipCode, 'zipCode')) {
                          final updateUser = UserModel(
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
                            imagePath: imagePath,
                          );
                          context.read<ProfileBloc>().add(
                                SaveProfileChanges(updatedUser: updateUser),
                              );
                        }
                      } else {
                        context.read<ProfileBloc>().add(EditProfilePressed());
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}