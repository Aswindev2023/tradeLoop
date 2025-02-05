import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trade_loop/core/constants/colors.dart';
import 'package:trade_loop/core/utils/custom_appbar.dart';
import 'package:trade_loop/core/utils/custom_button.dart';
import 'package:trade_loop/core/utils/custom_text_widget.dart';
import 'package:trade_loop/presentation/bloc/product_bloc/product_bloc.dart';
import 'package:trade_loop/presentation/bloc/product_details_bloc/product_details_bloc.dart';
import 'package:trade_loop/presentation/product_Details/widgets/products_details_sections.dart';
import 'package:trade_loop/presentation/products/model/product_model.dart';
import 'package:trade_loop/presentation/products/screens/edit_product_page.dart';

class UserProductDetailsPage extends StatefulWidget {
  final String productId;
  final String userId;

  const UserProductDetailsPage(
      {super.key, required this.productId, required this.userId});

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
      appBar: CustomAppbar(
        title: 'Product Details',
        backgroundColor: appbarColor,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context, true);
              context
                  .read<ProductBloc>()
                  .add(LoadProducts(userId: widget.userId));
            },
            icon: const Icon(Icons.arrow_back)),
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
                  ImageSection(product: product, productId: widget.productId),
                  const SizedBox(height: 16.0),
                  ProductDetailsSection(product: product),
                  const SizedBox(height: 16.0),
                  LocationSection(product: product),
                  const SizedBox(height: 16.0),
                  EditProductButton(
                    product: product,
                    productId: widget.productId,
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
            child: CustomTextWidget(text: 'Unexpected state!'),
          );
        },
      ),
    );
  }
}

class EditProductButton extends StatelessWidget {
  final ProductModel product;
  final String productId;

  const EditProductButton({
    super.key,
    required this.product,
    required this.productId,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomButton(
          label: 'Edit Product',
          onTap: () => _handleEditProduct(context),
        ),
      ),
    );
  }

  void _handleEditProduct(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProductPage(product: product),
      ),
    );

    if (result == true && context.mounted) {
      context.read<ProductDetailsBloc>().add(
            FetchProductDetailsEvent(productId),
          );
    }
  }
}
