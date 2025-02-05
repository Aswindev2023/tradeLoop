import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trade_loop/core/constants/colors.dart';
import 'package:trade_loop/core/utils/custom_text_widget.dart';
import 'package:trade_loop/presentation/home/model/home_page_product_model.dart';
import 'package:trade_loop/presentation/home/widgets/fav_icon.dart';
import 'package:trade_loop/presentation/product_Details/screens/product_details_page.dart';
import 'package:flutter/foundation.dart';

class ProductGrid extends StatelessWidget {
  final List<HomePageProductModel> products;
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  ProductGrid({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    const isWeb = kIsWeb;
    final crossAxisCount = isWeb ? (screenWidth > 1200 ? 4 : 3) : 2;
    final cardWidth = screenWidth / crossAxisCount - (isWeb ? 24 : 16);
    final imageHeight = cardWidth * 0.6;

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: isWeb ? 0.9 : 0.8,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ProductDetailsPage(productId: product.productId),
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
                // Product Image with Favorite Icon
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

                          return Container(
                            height: imageHeight,
                            width: double.infinity,
                            color: grey.shade200,
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: imageHeight,
                          width: double.infinity,
                          color: grey.shade200,
                          alignment: Alignment.center,
                          child: const Icon(Icons.broken_image, size: 40),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: FavIcon(product: product, userId: userId),
                    ),
                  ],
                ),
                // Product Details
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 6.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Name
                      CustomTextWidget(
                        text: product.name,
                        fontSize: cardWidth * 0.08,
                        fontWeight: FontWeight.bold,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      // Product Price
                      CustomTextWidget(
                        text: '₹${product.price.toStringAsFixed(2)}',
                        fontSize: cardWidth * 0.07,
                        fontWeight: FontWeight.w600,
                        color: green,
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
    );
  }
}
