import 'package:flutter/material.dart';
import 'package:trade_loop/presentation/profile/widgets/custom_text_field.dart';
import 'package:trade_loop/presentation/profile/widgets/edit_button.dart';
import 'package:trade_loop/presentation/profile/widgets/profile_image_widget.dart';

class ViewAndEditPage extends StatefulWidget {
  const ViewAndEditPage({super.key});

  @override
  State<ViewAndEditPage> createState() => _ViewAndEditPageState();
}

class _ViewAndEditPageState extends State<ViewAndEditPage> {
  bool _obscurePassword = true;
  bool isEditing = false;

  String name = 'John Wick';
  String email = 'johnwick@example.com';
  String mobile = '';
  String address = '';
  String password = 'wick John';

  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController mobileController;
  late TextEditingController addressController;
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: name);
    emailController = TextEditingController(text: email);
    mobileController = TextEditingController(text: mobile);
    addressController = TextEditingController(text: address);
    passwordController = TextEditingController(text: password);
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    mobileController.dispose();
    addressController.dispose();
    super.dispose();
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 15),
              ProfileImage(
                imageUrl:
                    'https://imgs.search.brave.com/lXARFlhuh5b05jTaVbYAR4Hkm6ej0pvCgysnSklYjr8/rs:fit:500:0:0:0/g:ce/aHR0cHM6Ly9tZWRp/YS5pc3RvY2twaG90/by5jb20vaWQvMTMz/ODI4OTgyNC9waG90/by9jbG9zZS11cC1p/bWFnZS1vZi1pbmRp/YW4tbWFuLXdpdGgt/YnV6ei1jdXQtaGFp/cnN0eWxlLXRvLWRp/c2d1aXNlLXJlY2Vk/aW5nLWhhaXJsaW5l/LXdlYXJpbmctdC53/ZWJwP2E9MSZiPTEm/cz02MTJ4NjEyJnc9/MCZrPTIwJmM9X1pD/WlY5T1BSVmJvYUQy/TnhMVWI3RjFYZEtk/dnlOUVNZVzNleXFV/eHpVUT0',
                onEdit: () {},
              ),
              const SizedBox(height: 20),
              CustomTextField(
                label: 'Name',
                controller: nameController,
                isEditable: isEditing,
              ),
              CustomTextField(
                label: 'Email',
                controller: emailController,
                isEditable: isEditing,
              ),
              CustomTextField(
                label: 'Password',
                controller: passwordController,
                isEditable: isEditing,
                isObscured: _obscurePassword,
                toggleVisibility: _togglePasswordVisibility,
              ),
              CustomTextField(
                label: 'Mobile',
                controller: mobileController,
                isEditable: isEditing,
              ),
              CustomTextField(
                label: 'Address',
                controller: addressController,
                isEditable: isEditing,
              ),
              const SizedBox(height: 20),
              EditButton(
                isEditing: isEditing,
                onPressed: () {
                  setState(() {
                    isEditing = !isEditing;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
