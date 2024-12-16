import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';
import 'package:trade_loop/core/utils/custom_appbar.dart';
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

class EditProductPage extends StatefulWidget {
  final ProductModel product;

  const EditProductPage({super.key, required this.product});

  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _conditionController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    // Initialize the form state with product data using Bloc
    context
        .read<ProductBloc>()
        .add(InitializeProductFormWithData(widget.product));
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
    return Scaffold(
      appBar: const CustomAppbar(
        title: 'Edit Product',
        fontSize: 15,
        centerTitle: true,
      ),
      body: BlocConsumer<ProductBloc, ProductState>(
        listener: (context, state) {
          if (state is ProductAddedSuccess) {
            setState(() {
              _isLoading = false;
            });
            SnackbarUtils.showSnackbar(context, 'Product updated successfully');
            Navigator.pop(context, true); // Navigate back after update
          } else if (state is ProductError) {
            SnackbarUtils.showSnackbar(context, 'Error: ${state.message}');
            setState(() {
              _isLoading = false;
            });
          }
        },
        builder: (context, state) {
          print('the state in the edit page is $state');
          if (state is ProductFormState) {
            _nameController.text = state.formFields['name'] ?? "";
            _descriptionController.text = state.formFields['description'] ?? "";
            _priceController.text = state.formFields['price'] ?? "";
            _conditionController.text = state.formFields['condition'] ?? "";

            return Padding(
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
                              initialImages: state.pickedImages,
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
                        initialCategory: state.formFields['categoryName'],
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

                      const SizedBox(height: 16),
                      // Tag field
                      TagDropdownField(
                        onTagsChanged: (tags) {
                          context
                              .read<ProductBloc>()
                              .add(UpdateTags(tags: tags));
                        },
                        initialTags: state.formFields['tags'] ?? [],
                      ),
                      const SizedBox(height: 16),

                      // Availability switch
                      SwitchListTile(
                        title: const Text("Available"),
                        value: state.isAvailable,
                        onChanged: (value) {
                          context
                              .read<ProductBloc>()
                              .add(UpdateAvailability(isAvailable: value));
                        },
                      ),
                      const SizedBox(height: 16),

                      // Location picker
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomTileWidget(
                          title: state.locationName ?? "No location selected",
                          onTap: () async {
                            await _selectLocation();
                          },
                          customFontWeight: FontWeight.w400,
                        ),
                      ),

                      const SizedBox(height: 24),
                      // Save changes button
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
                          onPressed: _isLoading ? null : _updateProduct,
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
                                  "Save Changes",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  void _updateProduct() {
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

        final updatedProduct = widget.product.copyWith(
          name: _nameController.text,
          description: _descriptionController.text,
          price: _priceController.text,
          condition: _conditionController.text,
          isAvailable: state.isAvailable,
          categoryId: state.selectedCategory?.id,
          categoryName: state.selectedCategory?.name,
          tags: state.tags,
          locationName: state.locationName,
          location: state.pickedLocation,
          imageUrls: state.pickedImages,
        );

        bloc.add(SaveProductChanges(updatedProduct: updatedProduct));
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _conditionController.dispose();
    super.dispose();
  }
}
