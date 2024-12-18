import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trade_loop/core/utils/custom_appbar.dart';
import 'package:trade_loop/core/utils/snackbar_utils.dart';
import 'package:trade_loop/presentation/bloc/wishlist_bloc/wish_list_bloc.dart';

class WishlistedProductsPage extends StatelessWidget {
  final String userId;

  const WishlistedProductsPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    print('User ID from WishlistedProductsPage: $userId');
    context.read<WishListBloc>().add(FetchWishlistEvent(userId));

    return Scaffold(
      appBar: const CustomAppbar(
        title: 'Wishlist',
        fontColor: Colors.white,
        fontSize: 30,
        fontWeight: FontWeight.bold,
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 17, 28, 233),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 15.0),
        child: BlocBuilder<WishListBloc, WishListState>(
          builder: (context, state) {
            if (state is WishlistLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is WishlistLoaded) {
              final products = state.products;
              if (products.isEmpty) {
                return const Center(child: Text("Your wishlist is empty."));
              }
              return ListView.separated(
                itemCount: products.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final product = products[index];

                  return SizedBox(
                    height: 100,
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 8.0),
                      leading: CircleAvatar(
                        radius: 35,
                        backgroundImage: product.imageUrls.isNotEmpty
                            ? NetworkImage(product.imageUrls.first)
                            : const AssetImage('images/profile-user.png')
                                as ImageProvider,
                      ),
                      title: Text(
                        product.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.favorite, color: Colors.red),
                        onPressed: () {
                          context.read<WishListBloc>().add(
                              RemoveProductFromWishlistEvent(
                                  userId, product.productId));
                          SnackbarUtils.showSnackbar(
                              context, 'Removed from Wishlist');
                        },
                      ),
                    ),
                  );
                },
              );
            } else if (state is WishlistError) {
              return Center(child: Text(state.message));
            } else {
              return const Center(child: Text('No products found.'));
            }
          },
        ),
      ),
    );
  }
}
