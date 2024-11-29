import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trade_loop/presentation/bloc/category_bloc/category_bloc.dart';

class FilterBottomSheet extends StatefulWidget {
  final Function(Map<String, dynamic>) onApplyFilters;

  const FilterBottomSheet({super.key, required this.onApplyFilters});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  final List<String> selectedCategoryIds = [];
  final List<String> selectedTags = [];

  final List<String> hardcodedTags = [
    "Vintage",
    "Furniture",
    "Books",
    "Fashion",
    "Vehicles",
    "Home Appliances",
    "Sports",
    "Toys",
    "Mobiles",
    "Laptops"
  ];

  void toggleTag(String tag) {
    setState(() {
      if (selectedTags.contains(tag)) {
        selectedTags.remove(tag);
      } else {
        selectedTags.add(tag);
      }
    });
  }

  void toggleCategory(String categoryId) {
    setState(() {
      if (selectedCategoryIds.contains(categoryId)) {
        print('filter bottomsheet: current categories$selectedCategoryIds');
        selectedCategoryIds.remove(categoryId);
      } else {
        selectedCategoryIds.add(categoryId);
        print('filter bottomsheet: selected categories$selectedCategoryIds');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Filter Options",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          // Categories Selector
          BlocBuilder<CategoryBloc, CategoryState>(
            builder: (context, state) {
              if (state is CategoryLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is CategoryLoaded) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Categories",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    Wrap(
                      spacing: 8,
                      children: state.categories.map((category) {
                        return FilterChip(
                          label: Text(category!.name),
                          selected: selectedCategoryIds.contains(category.id),
                          onSelected: (_) => toggleCategory(category.id!),
                        );
                      }).toList(),
                    ),
                  ],
                );
              } else {
                return const Text("Failed to load categories");
              }
            },
          ),
          const SizedBox(height: 16),
          // Tags Selector
          const Text(
            "Tags",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Wrap(
            spacing: 8,
            children: hardcodedTags.map((tag) {
              return FilterChip(
                label: Text(tag),
                selected: selectedTags.contains(tag),
                onSelected: (_) => toggleTag(tag),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          // Apply Button
          ElevatedButton(
            onPressed: () {
              print(
                  'fillter bottomsheet:populating filter with categories:$selectedCategoryIds ');
              widget.onApplyFilters({
                'categories': selectedCategoryIds,
                'tags': selectedTags,
              });
              Navigator.pop(context);
            },
            child: const Text("Apply Filters"),
          ),
        ],
      ),
    );
  }
}
