import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5),
        shape: BoxShape.circle,
      ),
      child: ValueListenableBuilder<bool>(
        valueListenable: isInWishlist,
        builder: (context, value, child) {
          return IconButton(
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                value ? Icons.favorite : Icons.favorite_border,
                color: value ? Colors.red : Colors.black,
                key: ValueKey(value),
              ),
            ),
            onPressed: _toggleWishlist,
          );
        },
      ),
    );
  }
}
