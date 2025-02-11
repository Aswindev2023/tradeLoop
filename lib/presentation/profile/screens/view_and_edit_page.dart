import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trade_loop/core/constants/colors.dart';
import 'package:trade_loop/core/utils/custom_appbar.dart';
import 'package:trade_loop/presentation/bloc/profile_bloc/profile_bloc.dart';
import 'package:trade_loop/presentation/profile/widgets/view_and_edit_sections.dart';

class ViewAndEditPage extends StatefulWidget {
  const ViewAndEditPage({super.key});

  @override
  State<ViewAndEditPage> createState() => _ViewAndEditPageState();
}

class _ViewAndEditPageState extends State<ViewAndEditPage> {
  // Controllers for handling text input fields
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController mobileController;
  late TextEditingController houseController;
  late TextEditingController cityController;
  late TextEditingController streetController;
  late TextEditingController stateController;
  late TextEditingController countryController;
  late TextEditingController postalController;

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
    // Fetch user details when the page loads
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        backgroundColor: appbarColor,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back, color: whiteColor),
        ),
        title: 'View & Edit Profile',
        fontColor: whiteColor,
        fontSize: 30,
        fontWeight: FontWeight.bold,
      ),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoaded) {
            // Update text fields with user data
            nameController.text = state.user.name;
            emailController.text = state.user.email;
            houseController.text = state.user.houseName ?? '';
            streetController.text = state.user.street ?? '';
            countryController.text = state.user.country ?? '';
            stateController.text = state.user.state ?? '';
            mobileController.text = state.user.phone ?? '';
            cityController.text = state.user.city ?? '';
            postalController.text = state.user.postalCode ?? '';
          }
        },
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Displays user profile image
                  ImageSection(state: state),
                  // Displays and allows editing of user details
                  TextFieldsSection(
                    state: state,
                    nameController: nameController,
                    emailController: emailController,
                    houseController: houseController,
                    streetController: streetController,
                    postalController: postalController,
                    cityController: cityController,
                    stateController: stateController,
                    countryController: countryController,
                    mobileController: mobileController,
                  ),
                  // Buttons for updating profile information
                  ButtonSection(
                    state: state,
                    nameController: nameController,
                    emailController: emailController,
                    mobileController: mobileController,
                    houseController: houseController,
                    cityController: cityController,
                    streetController: streetController,
                    stateController: stateController,
                    countryController: countryController,
                    postalController: postalController,
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
