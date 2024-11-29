import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trade_loop/core/utils/custom_text_widget.dart';
import 'package:trade_loop/presentation/bloc/recently_viewed_bloc/recently_viewed_bloc.dart';

import 'package:trade_loop/presentation/product_Details/screens/product_details_page.dart';

class RecentlyViewedRow extends StatelessWidget {
  final String userId;

  const RecentlyViewedRow({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final imageHeight = screenWidth / 3;

    return BlocBuilder<RecentlyViewedBloc, RecentlyViewedState>(
      builder: (context, state) {
        if (state is RecentlyViewedLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is RecentlyViewedLoaded) {
          final products = state.products;

          if (products.isEmpty) {
            return const Center(
              child: Text('No recently viewed products'),
            );
          }

          return Column(
            children: [
              const Text(
                'Recently Visited',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 250,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return GestureDetector(
                      child: Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Image with Favorite Icon
                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(12),
                                  ),
                                  child: Image.network(
                                    product.imageUrls[0],
                                    fit: BoxFit.cover,
                                    height: imageHeight,
                                    width: screenWidth / 2,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    },
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Container(
                                      color: Colors.grey.shade200,
                                      alignment: Alignment.center,
                                      child: const Icon(Icons.broken_image,
                                          size: 40),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.7),
                                      shape: BoxShape.circle,
                                    ),
                                    child: IconButton(
                                      icon: const Icon(Icons.favorite_border),
                                      color: Colors.red,
                                      iconSize: 24,
                                      onPressed: () {},
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            // Product Details
                            Padding(
                              padding: EdgeInsets.all(screenWidth * 0.03),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Product Name
                                  CustomTextWidget(
                                    text: product.name,
                                    fontSize: screenWidth * 0.04,
                                    fontWeight: FontWeight.bold,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: screenWidth * 0.01),
                                  // Product Price
                                  CustomTextWidget(
                                    text:
                                        '₹${product.price.toStringAsFixed(2)}',
                                    fontSize: screenWidth * 0.035,
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  SizedBox(height: screenWidth * 0.01),
                                  // Location Name
                                  SizedBox(
                                    width: screenWidth / 2.4,
                                    child: CustomTextWidget(
                                      text: product.locationName,
                                      fontSize: screenWidth * 0.03,
                                      color: Colors.grey,
                                      maxLines: 1,
                                      overflow: TextOverflow.fade,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetailsPage(
                                productId: product.productId),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        } else if (state is RecentlyViewedError) {
          return Center(child: Text(state.message));
        } else {
          return Container();
        }
      },
    );
  }
}
