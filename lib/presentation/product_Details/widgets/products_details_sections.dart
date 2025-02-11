import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trade_loop/core/constants/colors.dart';
import 'package:trade_loop/core/utils/custom_button.dart';
import 'package:trade_loop/core/utils/custom_text_widget.dart';
import 'package:trade_loop/presentation/chat/screens/chat_page.dart';
import 'package:trade_loop/presentation/product_Details/widgets/image_slider_widget.dart';
import 'package:trade_loop/presentation/product_Details/widgets/location_map_widget.dart';
import 'package:trade_loop/presentation/product_Details/widgets/share_product_widget.dart';
import 'package:trade_loop/presentation/products/model/product_model.dart';
import 'package:trade_loop/presentation/profile/widgets/custom_tile_widget.dart';
import 'package:trade_loop/presentation/seller_profile/screens/seller_profile_page.dart';

class ImageSection extends StatelessWidget {
  final ProductModel product;
  final String productId;

  const ImageSection({
    super.key,
    required this.product,
    required this.productId,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Stack(
        children: [
          //Display sliding image
          ImageSliderWidget(imageUrls: product.imageUrls),
          Positioned(
            top: 8,
            right: 8,
            child: ShareProductWidget(
              productId: productId,
              productName: product.name,
            ),
          ),
        ],
      ),
    );
  }
}

class ProductDetailsSection extends StatelessWidget {
  final ProductModel product;

  const ProductDetailsSection({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    double parsedPrice = double.tryParse(product.price) ?? 0.0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Product Name
          CustomTextWidget(
            text: product.name,
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 8.0),
          //Product Price
          CustomTextWidget(
            text: '₹${parsedPrice.toStringAsFixed(2)}',
            fontSize: 20.0,
            fontWeight: FontWeight.w600,
            color: priceColor,
          ),
          Divider(color: grey[300]),
          const SizedBox(height: 10.0),
          //Display Description heading & Description content
          const CustomTextWidget(
            text: 'Description',
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 8.0),
          CustomTextWidget(
            text: product.description,
            fontSize: 16.0,
            color: grey800,
          ),
          const SizedBox(height: 10.0),
          //Display Posted Date
          CustomTextWidget(
            text:
                'Posted on ${DateFormat('d MMM yyyy').format(DateTime.parse(product.datePosted))}',
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
          const SizedBox(height: 10.0),
          //Display Availability
          CustomTextWidget(
            text: product.isAvailable ? 'Available' : 'Out of Stock',
            fontSize: 16.0,
            color: blueGrey,
          ),
          const SizedBox(height: 10.0),
          //Display Condition
          CustomTextWidget(
            text: 'Condition: ${product.condition}',
            fontSize: 16.0,
            color: blueGrey,
          ),
          const SizedBox(height: 10.0),
          //Display Category Name
          CustomTextWidget(
            text: 'Category: ${product.categoryName}',
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
          ),
          const SizedBox(height: 8.0),
          //Display Tags
          Wrap(
            spacing: 8.0,
            children: product.tags
                .map((tag) => Chip(
                      label: Text(tag),
                      backgroundColor: tagBackCol,
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class LocationSection extends StatelessWidget {
  final ProductModel product;

  const LocationSection({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              const Icon(Icons.location_on, color: red),
              const SizedBox(width: 8.0),
              //Location Name
              Expanded(
                child: CustomTextWidget(
                  text: 'Location: ${product.locationName}',
                  fontSize: 16.0,
                  color: blueGrey,
                ),
              ),
            ],
          ),
        ),
        //Display Location Snippet
        LocationMapWidget(
          latitude: product.location!.latitude,
          longitude: product.location!.longitude,
        ),
      ],
    );
  }
}

class ViewSellerSection extends StatelessWidget {
  final String currentUser;
  final String sellerId;

  const ViewSellerSection({
    super.key,
    required this.currentUser,
    required this.sellerId,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: CustomTileWidget(
        title: 'View Seller Profile',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SellerProfilePage(
                currentUser: currentUser,
                sellerId: sellerId,
              ),
            ),
          );
        },
      ),
    );
  }
}

class ActionButtonSection extends StatelessWidget {
  final String userId;
  final String sellerId;

  const ActionButtonSection({
    super.key,
    required this.userId,
    required this.sellerId,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CustomButton(
          label: 'Contact Seller',
          //Navigate to Chat Section
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ChatPage(
                  sellerId: sellerId,
                  currentUserId: userId,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
