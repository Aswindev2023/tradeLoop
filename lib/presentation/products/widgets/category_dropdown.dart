import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trade_loop/presentation/bloc/category_bloc/category_bloc.dart';
import 'package:trade_loop/presentation/products/model/category_model.dart';

class CategoryDropdown extends StatefulWidget {
  final Function(CategoryModel?) onCategorySelected;
  final CategoryModel?
      initialCategory; // Added an optional parameter for the initial category

  const CategoryDropdown(
      {super.key, required this.onCategorySelected, this.initialCategory});

  @override
  State<CategoryDropdown> createState() => _CategoryDropdownState();
}

class _CategoryDropdownState extends State<CategoryDropdown> {
  CategoryModel? _selectedCategory;

  @override
  void initState() {
    super.initState();

    // Initialize with the current category if available
    _selectedCategory = widget.initialCategory;

    // Load categories when the widget is initialized
    context.read<CategoryBloc>().add(LoadCategoriesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        if (state is CategoryLoading) {
          return const CircularProgressIndicator();
        } else if (state is CategoryError) {
          return Text(state.message);
        } else if (state is CategoryLoaded) {
          return Padding(
            padding: const EdgeInsets.only(left: 10),
            child: DropdownButton<CategoryModel?>(
              // Allow null to handle empty category
              elevation: 8,
              value: _selectedCategory,
              hint: const Text("Select a category"),
              items: state.categories.map((category) {
                return DropdownMenuItem<CategoryModel?>(
                  value: category,
                  child: Text(category?.name ?? ''),
                );
              }).toList(),
              onChanged: (selectedCategory) {
                setState(() {
                  _selectedCategory = selectedCategory;
                });
                widget.onCategorySelected(selectedCategory);

                print('Selected category ID: ${selectedCategory?.id}');
              },
            ),
          );
        }
        return Container();
      },
    );
  }
}
