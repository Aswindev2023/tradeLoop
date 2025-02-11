import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trade_loop/core/constants/colors.dart';
import 'package:trade_loop/core/utils/custom_text_widget.dart';
import 'package:trade_loop/presentation/bloc/category_bloc/category_bloc.dart';
import 'package:trade_loop/presentation/bloc/home_bloc/home_bloc.dart';
import 'package:trade_loop/presentation/home/screens/category_list.dart';
import 'package:trade_loop/presentation/home/screens/category_product_page.dart';

class CategoryRowWidget extends StatefulWidget {
  final String userId;
  const CategoryRowWidget({super.key, required this.userId});

  @override
  State<CategoryRowWidget> createState() => _CategoryRowWidgetState();
}

class _CategoryRowWidgetState extends State<CategoryRowWidget> {
  @override
  void initState() {
    super.initState();
    context.read<CategoryBloc>().add(LoadCategoriesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        if (state is CategoryLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is CategoryLoaded) {
          //Display list of categories in horzontal format
          return SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: state.categories.length + 1,
              itemBuilder: (context, index) {
                if (index == state.categories.length) {
                  //Navigate to category list page
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CategoryList(
                              userId: widget.userId,
                            ),
                          ));
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'All Categories',
                        style: TextStyle(
                          fontSize: 14,
                          color: allCategoryCol,
                        ),
                      ),
                    ),
                  );
                }

                final category = state.categories[index];
                return GestureDetector(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      alignment: Alignment.center,
                      //Display the name of category
                      child: Text(
                        category!.name,
                        style: const TextStyle(
                            fontSize: 14, color: allCategoryCol),
                      ),
                    ),
                  ),
                  //Navigate to products page for each category
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CategoryProductsPage(
                          userId: widget.userId,
                          categoryId: category.id!,
                          categoryName: category.name,
                        ),
                      ),
                    ).then((_) {
                      context
                          .read<HomeBloc>()
                          .add(LoadProductsEvent(widget.userId));
                    });
                  },
                );
              },
            ),
          );
        } else if (state is CategoryError) {
          return const Center(
              child: CustomTextWidget(text: 'Failed to load categories.'));
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
