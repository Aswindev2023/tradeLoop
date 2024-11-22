import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';
import 'package:trade_loop/core/utils/form_validation_message.dart';
import 'package:trade_loop/core/utils/snackbar_utils.dart';
import 'package:trade_loop/presentation/bloc/product_bloc/product_bloc.dart';
import 'package:trade_loop/presentation/products/model/product_model.dart';
import 'package:trade_loop/presentation/products/screens/location_picker_page.dart';
import 'package:trade_loop/presentation/products/widgets/category_dropdown.dart';
import 'package:trade_loop/presentation/products/widgets/custom_textformfield.dart';
import 'package:trade_loop/presentation/products/widgets/product_image_picker.dart';
import 'package:trade_loop/presentation/products/widgets/tag_dropdown_field.dart';
import 'package:trade_loop/presentation/profile/widgets/custom_tile_widget.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _conditionController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(InitializeProductForm());
  }

// Location Picker
  Future<void> _selectLocation() async {
    final LatLng? pickedLocation = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LocationPickerPage()),
    );

    if (pickedLocation != null) {
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          pickedLocation.latitude,
          pickedLocation.longitude,
        );

        final locationName = placemarks.isNotEmpty
            ? "${placemarks.first.locality}, ${placemarks.first.administrativeArea}, ${placemarks.first.country}"
            : "Unknown Location";
        if (mounted) {
          context.read<ProductBloc>().add(UpdateLocation(
                pickedLocation: pickedLocation,
                locationName: locationName,
              ));
        }
        print("Selected Location Name: $locationName");
      } catch (e) {
        if (mounted) {
          context.read<ProductBloc>().add(UpdateLocation(
                pickedLocation: pickedLocation,
                locationName: "Unknown Location",
              ));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ProductBloc>().state;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Product"),
        centerTitle: true,
      ),
      body: BlocListener<ProductBloc, ProductState>(
        listener: (context, state) {
          if (state is ProductAddedSuccess) {
            setState(() {
              _isLoading = false;
            });
            SnackbarUtils.showSnackbar(context, 'Product added successfully');
            context.read<ProductBloc>().add(InitializeProductForm());
            Navigator.pop(context, true);
          } else if (state is ProductError) {
            SnackbarUtils.showSnackbar(context, 'Error:${state.message}');
            setState(() {
              _isLoading = false;
            });
            print(state.message);
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image picker container
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          "Product Images",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        ProductImagePicker(
                          onImagesPicked: (images) {
                            context
                                .read<ProductBloc>()
                                .add(UpdateImages(imagePaths: images));
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Product name field
                  CustomTextFormField(
                    controller: _nameController,
                    label: "Product Name",
                    validator: (value) =>
                        value!.isEmpty ? "Enter product name" : null,
                  ),

                  const SizedBox(height: 16),
                  CategoryDropdown(
                    onCategorySelected: (category) {
                      context
                          .read<ProductBloc>()
                          .add(UpdateCategory(selectedCategory: category!));
                    },
                  ),
                  const SizedBox(height: 16),
                  // Description field
                  CustomTextFormField(
                    controller: _descriptionController,
                    label: "Description",
                    maxLines: 3,
                    validator: (value) =>
                        value!.isEmpty ? "Enter product description" : null,
                  ),

                  const SizedBox(height: 16),
                  // Price field
                  CustomTextFormField(
                      controller: _priceController,
                      label: "Price",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter a price";
                        }
                        return null;
                      }),

                  const SizedBox(height: 16),
                  // Condition field
                  CustomTextFormField(
                    controller: _conditionController,
                    label: "Condition (e.g., New, Used)",
                    validator: (value) =>
                        value!.isEmpty ? "Specify condition" : null,
                  ),

                  const SizedBox(
                    height: 16,
                  ),
                  //Tag field
                  TagDropdownField(
                    onTagsChanged: (tags) {
                      context.read<ProductBloc>().add(UpdateTags(tags: tags));
                    },
                  ),
                  const SizedBox(height: 16),

                  // Availability switch
                  SwitchListTile(
                    title: const Text("Available"),
                    value:
                        (context.watch<ProductBloc>().state is ProductFormState)
                            ? (state as ProductFormState).isAvailable
                            : false,
                    onChanged: (value) {
                      context
                          .read<ProductBloc>()
                          .add(UpdateAvailability(isAvailable: value));
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  //location picker
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomTileWidget(
                      title: (context.watch<ProductBloc>().state
                              is ProductFormState)
                          ? ((state as ProductFormState).locationName ??
                              "No location selected")
                          : "No location selected",
                      onTap: () async {
                        await _selectLocation();
                        print("UI Rebuilt with new location");
                      },
                      customFontWeight: FontWeight.w400,
                    ),
                  ),

                  const SizedBox(height: 24),
                  //  buttons

                  Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, bottom: 20),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 11, 185, 17),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                        ),
                        onPressed: _isLoading ? null : _saveProduct,
                        child: _isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                "Save",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _saveProduct() {
    final bloc = context.read<ProductBloc>();
    final state = bloc.state;
    if (state is ProductFormState) {
      if (_formKey.currentState!.validate()) {
        setState(() {
          _isLoading = true;
        });
        if (state.selectedCategory == null) {
          SnackbarUtils.showSnackbar(context, 'Please select a category');
          return;
        }
        if (state.pickedLocation == null) {
          SnackbarUtils.showSnackbar(context, 'Please select a location');
          return;
        }
        if (state.pickedImages.isEmpty) {
          SnackbarUtils.showSnackbar(
              context, 'Please select at least one image');
          return;
        }
        if (!FormValidators.isValidPrice(_priceController.text)) {
          SnackbarUtils.showSnackbar(context, 'Please enter valid price');
          return;
        }

        final newProduct = ProductModel(
          name: _nameController.text,
          description: _descriptionController.text,
          price: _priceController.text,
          condition: _conditionController.text,
          datePosted: DateTime.now().toIso8601String(),
          isAvailable: state.formFields['isAvailable'] ?? true,
          imageUrls: state.pickedImages,
          tags: state.tags,
          sellerId: FirebaseAuth.instance.currentUser!.uid,
          categoryId: state.selectedCategory!.id!,
          categoryName: state.selectedCategory!.name,
          location: state.pickedLocation,
          locationName: state.locationName!,
        );

        bloc.add(ProductAdded(newProduct: newProduct));
      } else {
        SnackbarUtils.showSnackbar(context, 'Please fill all fields');
      }
    }
  }
}
