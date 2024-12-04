import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trade_loop/core/utils/custom_text_widget.dart';
import 'package:trade_loop/presentation/bloc/recently_viewed_bloc/recently_viewed_bloc.dart';
import 'package:trade_loop/presentation/home/model/home_page_product_model.dart';
import 'package:trade_loop/presentation/home/widgets/fav_icon.dart';
import 'package:trade_loop/presentation/product_Details/screens/product_details_page.dart';

class ProductGrid extends StatelessWidget {
  final List<HomePageProductModel> products;
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  ProductGrid({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final imageHeight = screenWidth / 3;
    final cardPadding = screenWidth * 0.02;

    return GridView.builder(
      padding: EdgeInsets.all(cardPadding),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: cardPadding,
        mainAxisSpacing: cardPadding,
      ),
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
                        width: double.infinity,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: Colors.grey.shade200,
                          alignment: Alignment.center,
                          child: const Icon(Icons.broken_image, size: 40),
                        ),
                      ),
                    ),
                    Positioned(
                        top: 8,
                        right: 8,
                        child: FavIcon(product: product, userId: userId)),
                  ],
                ),
                // Product Details
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(screenWidth * 0.03),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Product Name
                        Flexible(
                          child: CustomTextWidget(
                            text: product.name,
                            fontSize: screenWidth * 0.04,
                            fontWeight: FontWeight.bold,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        SizedBox(height: screenWidth * 0.01),
                        // Product Price
                        CustomTextWidget(
                          text: '₹${product.price.toStringAsFixed(2)}',
                          fontSize: screenWidth * 0.035,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),

                        SizedBox(height: screenWidth * 0.01),
                        // Location Name
                        Flexible(
                          child: CustomTextWidget(
                            text: product.locationName,
                            fontSize: screenWidth * 0.03,
                            color: Colors.grey,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ProductDetailsPage(productId: product.productId),
              ),
            ).then((_) {
              context
                  .read<RecentlyViewedBloc>()
                  .add(AddRecentlyViewed(product.productId, userId));
            });
          },
        );
      },
    );
  }
}
