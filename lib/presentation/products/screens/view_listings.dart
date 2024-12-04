import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trade_loop/core/utils/custom_appbar.dart';
import 'package:trade_loop/presentation/bloc/product_bloc/product_bloc.dart';
import 'package:trade_loop/presentation/navigation/bottom_naviagation_widget.dart';
import 'package:trade_loop/presentation/products/screens/add_product_page.dart';

class ViewListings extends StatelessWidget {
  final int selectedIndex = 2;
  final userId = FirebaseAuth.instance.currentUser?.uid;

  ViewListings({super.key});

  @override
  Widget build(BuildContext context) {
    print('this is the user id from viewListing page:$userId');
    context.read<ProductBloc>().add(LoadProducts(userId: userId!));
    return Scaffold(
      appBar: const CustomAppbar(
        title: 'My listings',
        centerTitle: true,
        fontColor: Colors.white,
        fontSize: 30,
        fontWeight: FontWeight.bold,
        backgroundColor: Color.fromARGB(255, 17, 28, 233),
      ),
      body: Padding(
        padding:
            const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0, top: 15),
        child: BlocBuilder<ProductBloc, ProductState>(
          builder: (context, state) {
            if (state is ProductLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProductsLoaded) {
              final products = state.products;
              if (products.isEmpty) {
                return const Center(child: Text("No products found."));
              }
              return ListView.separated(
                itemCount: products.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final product = products[index];

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: product.imageUrls.isNotEmpty
                          ? NetworkImage(product.imageUrls.first)
                          : const AssetImage('images/profile-user.png')
                              as ImageProvider,
                    ),
                    title: Text(product.name),
                    trailing: IconButton(
                      icon: const Icon(Icons.arrow_forward),
                      onPressed: () {},
                    ),
                  );
                },
              );
            } else if (state is ProductError) {
              return Center(child: Text(state.message));
            } else {
              return const Center(child: Text('No Products Listed '));
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddProductPage()));
          if (result == true) {
            context.read<ProductBloc>().add(LoadProducts(userId: userId!));
          }
        },
        backgroundColor: const Color.fromARGB(255, 62, 28, 255),
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 40,
        ),
      ),
      bottomNavigationBar:
          BottomNavigationBarWidget(selectedIndex: selectedIndex),
    );
  }
}
