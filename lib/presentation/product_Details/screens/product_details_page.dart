import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:trade_loop/core/utils/custom_appbar.dart';
import 'package:trade_loop/core/utils/custom_button.dart';
import 'package:trade_loop/core/utils/custom_text_widget.dart';
import 'package:trade_loop/presentation/bloc/product_details_bloc/product_details_bloc.dart';
import 'package:trade_loop/presentation/bloc/recently_viewed_bloc/recently_viewed_bloc.dart';
import 'package:trade_loop/presentation/home/widgets/recently_viewed_row.dart';
import 'package:trade_loop/presentation/product_Details/widgets/image_slider_widget.dart';
import 'package:trade_loop/presentation/product_Details/widgets/location_map_widget.dart';
import 'package:trade_loop/presentation/product_Details/widgets/share_product_widget.dart';
import 'package:trade_loop/presentation/products/model/product_model.dart';
import 'package:trade_loop/presentation/profile/widgets/custom_tile_widget.dart';
import 'package:trade_loop/presentation/seller_profile/screens/seller_profile_page.dart';

class ProductDetailsPage extends StatelessWidget {
  final String productId;
  final userId = FirebaseAuth.instance.currentUser!.uid;

  ProductDetailsPage({
    super.key,
    required this.productId,
  });

  @override
  Widget build(BuildContext context) {
    double parsedPrice = 0.0;

    context.read<ProductDetailsBloc>().add(FetchProductDetailsEvent(productId));
    context.read<RecentlyViewedBloc>().add(FetchRecentlyViewed(userId));

    return Scaffold(
      appBar: const CustomAppbar(
        title: 'Product Details',
        backgroundColor: const Color.fromARGB(255, 35, 17, 239),
      ),
      body: BlocBuilder<ProductDetailsBloc, ProductDetailsState>(
        builder: (context, state) {
          if (state is ProductDetailsLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is ProductDetailsLoaded) {
            final ProductModel product = state.product;
            parsedPrice = double.tryParse(product.price) ?? 0.0;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image Slider
                  Stack(children: [
                    ImageSliderWidget(imageUrls: product.imageUrls),
                    Positioned(
                        top: 8,
                        right: 8,
                        child: ShareProductWidget(
                          productId: productId,
                          productName: product.name,
                        )),
                  ]),

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

                  Divider(
                    thickness: 2,
                    color: Colors.grey[300],
                  ),

                  const SizedBox(height: 10.0),

                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CustomTextWidget(
                      text: 'Description',
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // Description
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: CustomTextWidget(
                      text: product.description,
                      fontSize: 16.0,
                      fontWeight: FontWeight.normal,
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
                  const SizedBox(height: 10.0),
                  //Availability
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
                            fontWeight: FontWeight.normal,
                            color: Colors.blueGrey,
                            overflow: TextOverflow.clip,
                            softWrap: true,
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
                        const Icon(
                          Icons.info_outline,
                          color: Colors.blue,
                        ),
                        const SizedBox(width: 8.0),
                        Expanded(
                          child: CustomTextWidget(
                            text: 'Condition: ${product.condition}',
                            fontSize: 16.0,
                            fontWeight: FontWeight.normal,
                            color: Colors.blueGrey,
                            overflow: TextOverflow.clip,
                            softWrap: true,
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
                        const Icon(
                          Icons.location_on,
                          color: Colors.red,
                        ),
                        const SizedBox(width: 8.0),
                        Expanded(
                          child: CustomTextWidget(
                            text: 'Location: ${product.locationName}',
                            fontSize: 16.0,
                            fontWeight: FontWeight.normal,
                            color: Colors.blueGrey,
                            overflow: TextOverflow.clip,
                            softWrap: true,
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

                  // Seller Info Navigation
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: CustomTileWidget(
                      title: 'View Seller Profile',
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SellerProfilePage(
                                      currentUser: userId,
                                      sellerId: product.sellerId,
                                    )));
                      },
                      customFontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  RecentlyViewedRow(userId: userId),
                  const SizedBox(height: 16.0),

                  // Contact Seller Button
                  CustomButton(label: 'Contact Seller', onTap: () {})
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
