import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trade_loop/core/constants/colors.dart';
import 'package:trade_loop/core/utils/snackbar_utils.dart';
import 'package:trade_loop/presentation/bloc/wishlist_bloc/wish_list_bloc.dart';
import 'package:trade_loop/presentation/home/model/home_page_product_model.dart';

class FavIcon extends StatefulWidget {
  final HomePageProductModel product;
  final String userId;

  const FavIcon({super.key, required this.product, required this.userId});

  @override
  State<FavIcon> createState() => _FavIconState();
}

class _FavIconState extends State<FavIcon> {
  late ValueNotifier<bool> isInWishlist;

  @override
  void initState() {
    super.initState();

    final wishlistState = context.read<WishListBloc>().state;
    if (wishlistState is WishlistLoaded) {
      isInWishlist = ValueNotifier(
          wishlistState.productIds.contains(widget.product.productId));
    } else {
      isInWishlist = ValueNotifier(false);
    }
  }

  void _toggleWishlist() {
    if (isInWishlist.value) {
      context.read<WishListBloc>().add(
            RemoveProductFromWishlistEvent(
                widget.userId, widget.product.productId),
          );
      SnackbarUtils.showSnackbar(context, 'Removed from Wishlist');
    } else {
      context.read<WishListBloc>().add(
            AddProductToWishlistEvent(widget.userId, widget.product.productId),
          );
      SnackbarUtils.showSnackbar(context, 'Added to Wishlist');
    }
    isInWishlist.value = !isInWishlist.value;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWebMobile = kIsWeb && screenWidth < 600;
    final iconSize = isWebMobile ? 18.0 : 22.0;
    final containerSize = iconSize + (isWebMobile ? 10 : 14);

    return Positioned(
      top: 8,
      right: 8,
      child: ValueListenableBuilder<bool>(
        valueListenable: isInWishlist,
        builder: (context, value, child) {
          return Container(
            width: containerSize,
            height: containerSize,
            decoration: BoxDecoration(
              color: whiteColor.withOpacity(0.8),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(2, 2),
                ),
              ],
            ),
            child: IconButton(
              iconSize: iconSize,
              padding: EdgeInsets.zero,
              icon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  value ? Icons.favorite : Icons.favorite_border,
                  color: value ? red : blackColor,
                  key: ValueKey(value),
                  size: iconSize,
                ),
              ),
              onPressed: _toggleWishlist,
            ),
          );
        },
      ),
    );
  }
}
