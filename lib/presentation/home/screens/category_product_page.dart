import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trade_loop/presentation/bloc/home_bloc/home_bloc.dart';
import 'package:trade_loop/presentation/home/widgets/product_grid.dart';

class CategoryProductsPage extends StatelessWidget {
  final String userId;
  final String categoryId;
  final String categoryName;

  const CategoryProductsPage({
    super.key,
    required this.userId,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    context.read<HomeBloc>().add(LoadCategoryProductsEvent(userId, categoryId));

    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName),
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomePageLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is HomePageLoaded) {
            if (state.products.isEmpty) {
              return const Center(child: Text('No Products Available'));
            } else {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ProductGrid(products: state.products),
              );
            }
          } else if (state is HomePageError) {
            return Center(child: Text(state.message));
          } else {
            return const Center(child: Text('No Products Available'));
          }
        },
      ),
    );
  }
}
