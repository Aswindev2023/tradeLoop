import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trade_loop/core/constants/colors.dart';
import 'package:trade_loop/core/utils/custom_appbar.dart';
import 'package:trade_loop/presentation/bloc/category_bloc/category_bloc.dart';
import 'package:trade_loop/presentation/home/screens/category_product_page.dart';
import 'package:trade_loop/presentation/home/screens/home_page.dart';

class CategoryList extends StatefulWidget {
  final String userId;
  const CategoryList({super.key, required this.userId});

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  @override
  void initState() {
    super.initState();
    context.read<CategoryBloc>().add(LoadCategoriesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: blackColor),
          //Navigate back to homepage
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          },
        ),
        title: 'Categories',
        fontSize: 25,
        fontWeight: FontWeight.w400,
        backgroundColor: appbarWhiteColor,
      ),
      body: BlocBuilder<CategoryBloc, CategoryState>(
        builder: (context, state) {
          if (state is CategoryLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is CategoryLoaded) {
            //Display list of categories available
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.separated(
                itemCount: state.categories.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final category = state.categories[index];
                  return ListTile(
                    title: Text(category!.name),
                    onTap: () {
                      //Navigate to products page for each category
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CategoryProductsPage(
                            userId: widget.userId,
                            categoryId: category.id!,
                            categoryName: category.name,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            );
          } else if (state is CategoryError) {
            return Center(
              child: Text('Error: ${state.message}'),
            );
          }

          return const Center(
            child: Text('No categories found.'),
          );
        },
      ),
    );
  }
}
