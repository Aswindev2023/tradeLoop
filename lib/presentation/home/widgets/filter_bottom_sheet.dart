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
  final List<Map<String, dynamic>> selectedPriceRanges = [];

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

  final List<Map<String, dynamic>> priceRanges = [
    {'label': '0 - 100', 'min': 0, 'max': 100},
    {'label': '100 - 500', 'min': 100, 'max': 500},
    {'label': '500 - 1000', 'min': 500, 'max': 1000},
    {'label': '1000 - 5000', 'min': 1000, 'max': 5000},
    {'label': '5000 - 10000', 'min': 5000, 'max': 10000},
    {'label': '10k - 50k', 'min': 10000, 'max': 50000},
    {'label': '50k - 100k', 'min': 50000, 'max': 100000},
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
        selectedCategoryIds.remove(categoryId);
      } else {
        selectedCategoryIds.add(categoryId);
      }
    });
  }

  void togglePriceRange(Map<String, dynamic> range) {
    setState(() {
      if (selectedPriceRanges.contains(range)) {
        selectedPriceRanges.remove(range);
      } else {
        selectedPriceRanges.add(range);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final bottomSheetHeight = mediaQuery.size.height * 0.75;

    return Container(
      height: bottomSheetHeight,
      padding: EdgeInsets.symmetric(
        horizontal: mediaQuery.size.width * 0.05,
        vertical: 16,
      ),
      child: SingleChildScrollView(
        child: Column(
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
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
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

            // Price Range Selector
            const Text(
              "Price Range",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            Wrap(
              spacing: 8,
              children: priceRanges.map((range) {
                return FilterChip(
                  label: Text(range['label']),
                  selected: selectedPriceRanges.contains(range),
                  onSelected: (_) => togglePriceRange(range),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // Apply Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  widget.onApplyFilters({
                    'categories': selectedCategoryIds,
                    'tags': selectedTags,
                    'priceRanges': selectedPriceRanges,
                  });
                  Navigator.pop(context);
                },
                child: const Text("Apply Filters"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
