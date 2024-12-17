import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trade_loop/presentation/bloc/category_bloc/category_bloc.dart';
import 'package:trade_loop/presentation/products/model/category_model.dart';

class CategoryDropdown extends StatefulWidget {
  final Function(CategoryModel?) onCategorySelected;
  final CategoryModel? initialCategory;

  const CategoryDropdown(
      {super.key, required this.onCategorySelected, this.initialCategory});

  @override
  State<CategoryDropdown> createState() => _CategoryDropdownState();
}

class _CategoryDropdownState extends State<CategoryDropdown> {
  String? _selectedCategoryId; // Store the category id as the selected value

  @override
  void initState() {
    super.initState();
    _selectedCategoryId = widget.initialCategory?.id;

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
            child: DropdownButton<String?>(
              // Use category ID as value
              elevation: 8,
              value: _selectedCategoryId,
              hint: const Text("Select a category"),
              items: state.categories.map((category) {
                return DropdownMenuItem<String?>(
                  value: category?.id, // Use category id as the value
                  child: Text(category?.name ?? ''),
                );
              }).toList(),
              onChanged: (selectedCategoryId) {
                setState(() {
                  _selectedCategoryId = selectedCategoryId;
                });
                final selectedCategory = state.categories.firstWhere(
                    (category) => category!.id == selectedCategoryId);
                widget.onCategorySelected(selectedCategory);

                print('Selected category ID: $selectedCategoryId');
              },
            ),
          );
        }
        return Container();
      },
    );
  }
}
