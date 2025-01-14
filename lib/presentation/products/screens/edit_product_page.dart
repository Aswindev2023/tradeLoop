import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trade_loop/core/constants/colors.dart';
import 'package:trade_loop/core/utils/custom_appbar.dart';
import 'package:trade_loop/core/utils/form_validation_message.dart';
import 'package:trade_loop/core/utils/location_utils.dart';
import 'package:trade_loop/core/utils/snackbar_utils.dart';
import 'package:trade_loop/presentation/bloc/product_bloc/product_bloc.dart';
import 'package:trade_loop/presentation/products/model/product_model.dart';
import 'package:trade_loop/presentation/products/widgets/category_dropdown.dart';
import 'package:trade_loop/presentation/products/widgets/product_page_sections.dart';
import 'package:trade_loop/presentation/products/widgets/tag_dropdown_field.dart';

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
    context
        .read<ProductBloc>()
        .add(InitializeProductFormWithData(widget.product));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(
        title: 'Edit Product',
        fontSize: 20,
        centerTitle: true,
        backgroundColor: appbarColor,
      ),
      body: BlocConsumer<ProductBloc, ProductState>(
        listener: (context, state) {
          if (state is ProductAddedSuccess) {
            setState(() {
              _isLoading = false;
            });
            SnackbarUtils.showSnackbar(context, 'Product updated successfully');
            Navigator.pop(context, true);
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
                      ProductImageSection(
                        onImagesPicked: (images) {
                          context
                              .read<ProductBloc>()
                              .add(UpdateImages(imagePaths: images));
                        },
                        initialImages: state.pickedImages,
                      ),
                      const SizedBox(height: 24),
                      //Product Details Section
                      ProductPageDetailsSection(
                        nameController: _nameController,
                        descriptionController: _descriptionController,
                        priceController: _priceController,
                        conditionController: _conditionController,
                      ),

                      const SizedBox(height: 16),
                      CategoryDropdown(
                        onCategorySelected: (category) {
                          context
                              .read<ProductBloc>()
                              .add(UpdateCategory(selectedCategory: category!));
                        },
                        initialCategory: state.selectedCategory,
                      ),

                      const SizedBox(height: 16),
                      // Tag field
                      TagDropdownField(
                        onTagsChanged: (tags) {
                          context
                              .read<ProductBloc>()
                              .add(UpdateTags(tags: tags));
                        },
                        initialTags: state.tags,
                      ),
                      const SizedBox(height: 16),

                      // Availability switch
                      ProductAvailabilitySection(
                        isAvailable: state.isAvailable,
                        onAvailabilityChanged: (value) {
                          context
                              .read<ProductBloc>()
                              .add(UpdateAvailability(isAvailable: value));
                        },
                      ),
                      const SizedBox(height: 16),

                      // Location picker
                      ProductLocationSection(
                        locationName:
                            state.locationName ?? "No location selected",
                        onLocationSelected: () async {
                          await selectLocation(context);
                        },
                      ),

                      const SizedBox(height: 24),
                      // Save changes button
                      ProductPageButtonSection(
                          onPressed: _updateProduct,
                          isLoading: _isLoading,
                          title: 'Save Changes'),
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
