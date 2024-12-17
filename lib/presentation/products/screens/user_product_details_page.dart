import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:trade_loop/core/constants/colors.dart';
import 'package:trade_loop/core/utils/custom_appbar.dart';
import 'package:trade_loop/core/utils/custom_button.dart';
import 'package:trade_loop/core/utils/custom_text_widget.dart';
import 'package:trade_loop/presentation/bloc/product_details_bloc/product_details_bloc.dart';
import 'package:trade_loop/presentation/product_Details/widgets/image_slider_widget.dart';
import 'package:trade_loop/presentation/product_Details/widgets/location_map_widget.dart';
import 'package:trade_loop/presentation/products/screens/edit_product_page.dart';

class UserProductDetailsPage extends StatefulWidget {
  final String productId;

  const UserProductDetailsPage({super.key, required this.productId});

  @override
  State<UserProductDetailsPage> createState() => _UserProductDetailsPageState();
}

class _UserProductDetailsPageState extends State<UserProductDetailsPage> {
  double parsedPrice = 0.0;

  @override
  void initState() {
    super.initState();
    context
        .read<ProductDetailsBloc>()
        .add(FetchProductDetailsEvent(widget.productId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(
        title: 'Product Details',
        backgroundColor: appbarColor,
      ),
      body: BlocBuilder<ProductDetailsBloc, ProductDetailsState>(
        builder: (context, state) {
          if (state is ProductDetailsLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is ProductDetailsLoaded) {
            final product = state.product;
            parsedPrice = double.tryParse(product.price) ?? 0.0;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image Slider
                  ImageSliderWidget(imageUrls: product.imageUrls),
                  const SizedBox(height: 16.0),

                  // Product Name
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: CustomTextWidget(
                      text: product.name,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),

                  // Price
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: CustomTextWidget(
                      text: '₹${parsedPrice.toStringAsFixed(2)}',
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600,
                      color: const Color.fromARGB(255, 51, 0, 255),
                    ),
                  ),
                  Divider(thickness: 2, color: Colors.grey[300]),
                  const SizedBox(height: 10.0),

                  // Description
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CustomTextWidget(
                      text: 'Description',
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: CustomTextWidget(
                      text: product.description,
                      fontSize: 16.0,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 10.0),

                  // Date Posted
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: CustomTextWidget(
                      text:
                          'Posted on ${DateFormat('d MMM yyyy').format(DateTime.parse(product.datePosted))}',
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  // Availability
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        const CustomTextWidget(text: 'Availability:'),
                        const SizedBox(width: 8.0),
                        Expanded(
                          child: CustomTextWidget(
                            text: product.isAvailable
                                ? 'Available'
                                : 'Out of Stock',
                            fontSize: 16.0,
                            color: Colors.blueGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16.0),

                  // Condition
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline, color: Colors.blue),
                        const SizedBox(width: 8.0),
                        Expanded(
                          child: CustomTextWidget(
                            text: 'Condition: ${product.condition}',
                            fontSize: 16.0,
                            color: Colors.blueGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16.0),

                  // Category and Tags
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextWidget(
                          text: 'Category: ${product.categoryName}',
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                        ),
                        const SizedBox(height: 8.0),
                        Wrap(
                          spacing: 8.0,
                          children: product.tags
                              .map((tag) => Chip(
                                    label: Text(tag),
                                    backgroundColor: const Color.fromARGB(
                                        255, 211, 233, 251),
                                  ))
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16.0),

                  // Location
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        const Icon(Icons.location_on, color: Colors.red),
                        const SizedBox(width: 8.0),
                        Expanded(
                          child: CustomTextWidget(
                            text: 'Location: ${product.locationName}',
                            fontSize: 16.0,
                            color: Colors.blueGrey,
                          ),
                        ),
                      ],
                    ),
                  ),

                  LocationMapWidget(
                    latitude: product.location!.latitude,
                    longitude: product.location!.longitude,
                  ),
                  const SizedBox(height: 16.0),

                  // Edit Product Button
                  CustomButton(
                    label: 'Edit Product',
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              EditProductPage(product: product),
                        ),
                      );
                      if (mounted && result == true) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (mounted) {
                            context.read<ProductDetailsBloc>().add(
                                  FetchProductDetailsEvent(widget.productId),
                                );
                          }
                        });
                      }
                    },
                  ),
                ],
              ),
            );
          } else if (state is ProductDetailsError) {
            return Center(
              child: Text(
                'Failed to load product details: ${state.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          return const Center(
            child: Text('Unexpected state!'),
          );
        },
      ),
    );
  }
}
