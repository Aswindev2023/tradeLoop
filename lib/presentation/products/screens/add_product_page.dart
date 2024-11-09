import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trade_loop/core/utils/snackbar_utils.dart';
import 'package:trade_loop/presentation/bloc/product_bloc/product_bloc.dart';
import 'package:trade_loop/presentation/products/model/category_model.dart';
import 'package:trade_loop/presentation/products/model/product_model.dart';
import 'package:trade_loop/presentation/products/widgets/category_dropdown.dart';
import 'package:trade_loop/presentation/products/widgets/custom_textformfield.dart';
import 'package:trade_loop/presentation/products/widgets/product_image_picker.dart';
import 'package:trade_loop/presentation/products/widgets/tag_dropdown_field.dart';

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
  List<String> _pickedImages = [];
  bool _isAvailable = true;
  List<String> _tags = [];
  bool _isLoading = false;
  CategoryModel? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductBloc, ProductState>(
      listener: (context, state) {
        if (state is ProductAddedSuccess) {
          SnackbarUtils.showSnackbar(context, 'Product added successfully');
          Navigator.pop(context, true);
          setState(() {
            _isLoading = false;
          });
        } else if (state is ProductError) {
          SnackbarUtils.showSnackbar(context, 'Error:${state.message}');
          setState(() {
            _isLoading = false;
          });
          print('${state.message}');
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Add Product"),
          centerTitle: true,
        ),
        body: Padding(
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
                            setState(() {
                              _pickedImages = images;
                            });
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
                      setState(() {
                        _selectedCategory = category;
                      });
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
                    validator: (value) => value!.isEmpty ? "Enter price" : null,
                  ),

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
                      setState(() {
                        _tags = tags;
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  // Availability switch
                  SwitchListTile(
                    title: const Text("Available"),
                    value: _isAvailable,
                    onChanged: (value) {
                      setState(() {
                        _isAvailable = value;
                      });
                    },
                  ),
                  const SizedBox(height: 24),
                  //  buttons

                  Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, bottom: 20),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 11, 185, 17),
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
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _saveProduct() {
    if (_formKey.currentState!.validate() && _selectedCategory != null) {
      setState(() {
        _isLoading = true;
      });
      final newProduct = ProductModel(
        name: _nameController.text,
        description: _descriptionController.text,
        price: _priceController.text,
        condition: _conditionController.text,
        datePosted: DateTime.now().toIso8601String(),
        isAvailable: _isAvailable,
        imageUrls: _pickedImages,
        tags: _tags,
        sellerId: FirebaseAuth.instance.currentUser!.uid,
        categoryId: _selectedCategory!.id!,
        categoryName: _selectedCategory!.name,
      );

      context.read<ProductBloc>().add(ProductAdded(newProduct: newProduct));
    }
  }
}
