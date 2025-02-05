import 'package:flutter/foundation.dart'; // For kIsWeb
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trade_loop/core/constants/colors.dart';
import 'package:trade_loop/core/utils/custom_text_widget.dart';
import 'package:trade_loop/presentation/bloc/recently_viewed_bloc/recently_viewed_bloc.dart';
import 'package:trade_loop/presentation/home/widgets/fav_icon.dart';
import 'package:trade_loop/presentation/product_Details/screens/product_details_page.dart';

class RecentlyViewedRow extends StatelessWidget {
  final String userId;

  const RecentlyViewedRow({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    const isWeb = kIsWeb;
    final cardWidth = isWeb ? screenWidth / 4.5 : screenWidth / 2.2;
    final imageHeight = cardWidth * 0.6;

    return BlocBuilder<RecentlyViewedBloc, RecentlyViewedState>(
      builder: (context, state) {
        if (state is RecentlyViewedLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is RecentlyViewedLoaded) {
          final products = state.products;

          if (products.isEmpty) {
            return const Center(
              child: CustomTextWidget(text: 'No recently viewed products'),
            );
          }

          return Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: CustomTextWidget(
                  text: 'Recently Visited',
                  color: blackColor,
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: cardWidth * 1.2, // Dynamically adjust the row height
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetailsPage(
                                productId: product.productId),
                          ),
                        );
                      },
                      child: Card(
                        elevation: 4,
                        shadowColor: blackColor.withOpacity(0.3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: grey.shade300,
                            width: 1.5,
                          ),
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
                                    width: cardWidth,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) {
                                        return child;
                                      }
                                      return Container(
                                        height: imageHeight,
                                        width: cardWidth,
                                        color: grey.shade200,
                                        child: const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      );
                                    },
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Container(
                                      height: imageHeight,
                                      width: cardWidth,
                                      color: grey.shade200,
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
                                        color: whiteColor.withOpacity(0.8),
                                        shape: BoxShape.circle,
                                      ),
                                      child: FavIcon(
                                        product: product,
                                        userId: userId,
                                      )),
                                ),
                              ],
                            ),
                            // Product Details
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 8),
                                  // Product Name
                                  CustomTextWidget(
                                    text: product.name,
                                    fontSize: cardWidth * 0.08,
                                    fontWeight: FontWeight.bold,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  // Product Price
                                  CustomTextWidget(
                                    text:
                                        '₹${product.price.toStringAsFixed(2)}',
                                    fontSize: cardWidth * 0.07,
                                    color: green,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  const SizedBox(height: 4),
                                  // Location Name
                                  CustomTextWidget(
                                    text: product.locationName,
                                    fontSize: cardWidth * 0.06,
                                    color: grey,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        } else if (state is RecentlyViewedError) {
          return Center(child: CustomTextWidget(text: state.message));
        } else {
          return Container();
        }
      },
    );
  }
}
