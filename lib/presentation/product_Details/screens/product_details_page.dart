import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:trade_loop/core/constants/colors.dart';
import 'package:trade_loop/core/utils/custom_appbar.dart';
import 'package:trade_loop/core/utils/custom_text_widget.dart';
import 'package:trade_loop/presentation/bloc/product_details_bloc/product_details_bloc.dart';
import 'package:trade_loop/presentation/bloc/recently_viewed_bloc/recently_viewed_bloc.dart';
import 'package:trade_loop/presentation/home/screens/home_page.dart';
import 'package:trade_loop/presentation/home/widgets/recently_viewed_row.dart';
import 'package:trade_loop/presentation/product_Details/widgets/products_details_sections.dart';

class ProductDetailsPage extends StatelessWidget {
  final String productId;
  final userId = FirebaseAuth.instance.currentUser!.uid;

  ProductDetailsPage({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    context.read<ProductDetailsBloc>().add(FetchProductDetailsEvent(productId));
    context.read<RecentlyViewedBloc>().add(FetchRecentlyViewed(userId));

    return Scaffold(
      appBar: CustomAppbar(
        title: 'Product Details',
        backgroundColor: appbarColor,
        //Navigate back to homepage
        leading: IconButton(
            onPressed: () {
              context
                  .read<RecentlyViewedBloc>()
                  .add(AddRecentlyViewed(productId, userId));
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomePage(),
                ),
                (route) => false,
              );
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      body: BlocBuilder<ProductDetailsBloc, ProductDetailsState>(
        builder: (context, state) {
          if (state is ProductDetailsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProductDetailsLoaded) {
            final product = state.product;
            //Product Details section
            return SingleChildScrollView(
              child: Column(
                children: [
                  //Image section
                  ImageSection(product: product, productId: productId),
                  //General Details such as name,price,description,category,tags..etc
                  ProductDetailsSection(product: product),
                  const SizedBox(
                    height: 10,
                  ),
                  //Display Location
                  LocationSection(product: product),
                  //Navigate to seller's profile
                  ViewSellerSection(
                    currentUser: userId,
                    sellerId: product.sellerId,
                  ),
                  const SizedBox(height: 16.0),
                  //Display the recently viewed products
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RecentlyViewedRow(userId: userId),
                  ),
                  //Contact Seller Button
                  ActionButtonSection(
                    userId: userId,
                    sellerId: product.sellerId,
                  ),
                ],
              ),
            );
          } else if (state is ProductDetailsError) {
            return Center(
              child: CustomTextWidget(
                text: 'Failed to load product details: ${state.error}',
                color: red,
              ),
            );
          }

          return const Center(
              child: CustomTextWidget(text: 'Unexpected state!'));
        },
      ),
    );
  }
}
