import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trade_loop/core/constants/colors.dart';
import 'package:trade_loop/core/utils/custom_appbar.dart';
import 'package:trade_loop/core/utils/form_validation_message.dart';
import 'package:trade_loop/core/utils/location_utils.dart';
import 'package:trade_loop/core/utils/snackbar_utils.dart';
import 'package:trade_loop/presentation/bloc/boolean_cubit/bool_cubit.dart';
import 'package:trade_loop/presentation/bloc/product_bloc/product_bloc.dart';
import 'package:trade_loop/presentation/products/model/product_model.dart';
import 'package:trade_loop/presentation/products/widgets/category_dropdown.dart';
import 'package:trade_loop/presentation/products/widgets/product_page_sections.dart';
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

  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(InitializeProductForm());
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ProductBloc>().state;

    return Scaffold(
      appBar: CustomAppbar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(
                context,
                true,
              );
            },
            icon: const Icon(
              Icons.arrow_back,
              color: iconColor,
            )),
        title: 'Add Product',
        fontSize: 25,
        centerTitle: true,
        backgroundColor: appbarColor,
      ),
      body: BlocListener<ProductBloc, ProductState>(
        listener: (context, state) {
          if (state is ProductAddedSuccess) {
            SnackbarUtils.showSnackbar(context, 'Product added successfully');
            context.read<BoolCubit>().setLoading(false);
            context.read<ProductBloc>().add(InitializeProductForm());
            Navigator.pop(context, true);
          } else if (state is ProductError) {
            SnackbarUtils.showSnackbar(context, 'Error:${state.message}');
            context.read<BoolCubit>().setLoading(false);
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
                  ProductImageSection(
                    onImagesPicked: (images) {
                      context
                          .read<ProductBloc>()
                          .add(UpdateImages(imagePaths: images));
                    },
                  ),
                  const SizedBox(height: 24),
                  // Product name field
                  ProductPageDetailsSection(
                    conditionController: _conditionController,
                    descriptionController: _descriptionController,
                    nameController: _nameController,
                    priceController: _priceController,
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

                  //Tag field
                  TagDropdownField(
                    onTagsChanged: (tags) {
                      context.read<ProductBloc>().add(UpdateTags(tags: tags));
                    },
                    initialTags: const [],
                  ),
                  const SizedBox(height: 16),

                  // Availability switch
                  ProductAvailabilitySection(
                    isAvailable:
                        (context.watch<ProductBloc>().state is ProductFormState)
                            ? (state as ProductFormState).isAvailable
                            : false,
                    onAvailabilityChanged: (value) {
                      context
                          .read<ProductBloc>()
                          .add(UpdateAvailability(isAvailable: value));
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  //location picker
                  ProductLocationSection(
                    locationName:
                        (context.watch<ProductBloc>().state is ProductFormState)
                            ? ((state as ProductFormState).locationName ??
                                "No location selected")
                            : "No location selected",
                    onLocationSelected: () async {
                      await selectLocation(context);
                    },
                  ),
                  const SizedBox(height: 24),

                  //  buttons
                  ProductPageButtonSection(
                    onPressed: _saveProduct,
                    isLoading: context.watch<BoolCubit>().state,
                    title: 'Save',
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
    final bloc = context.read<ProductBloc>();
    final state = bloc.state;
    if (state is ProductFormState) {
      if (_formKey.currentState!.validate()) {
        //set loading state
        context.read<BoolCubit>().setLoading(true);
        if (state.selectedCategory == null) {
          SnackbarUtils.showSnackbar(context, 'Please select a category');
          _resetLoadingState();
          return;
        }

        if (state.pickedLocation == null) {
          SnackbarUtils.showSnackbar(context, 'Please select a location');
          _resetLoadingState();
          return;
        }
        if (state.pickedImages.isEmpty) {
          SnackbarUtils.showSnackbar(
              context, 'Please select at least one image');
          _resetLoadingState();
          return;
        }
        if (!FormValidators.isValidPrice(_priceController.text)) {
          SnackbarUtils.showSnackbar(context, 'Please enter valid price');
          _resetLoadingState();
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

  void _resetLoadingState() {
    Future.delayed(const Duration(seconds: 1), () {
      context.read<BoolCubit>().setLoading(false);
    });
  }
}
