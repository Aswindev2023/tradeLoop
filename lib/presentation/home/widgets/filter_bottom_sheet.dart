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
  String? selectedCategoryId;
  final List<String> selectedTags = [];
  RangeValues priceRange = const RangeValues(0, 1000);

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
          // Category Dropdown
          BlocBuilder<CategoryBloc, CategoryState>(
            builder: (context, state) {
              if (state is CategoryLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is CategoryLoaded) {
                return DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: "Category",
                    border: OutlineInputBorder(),
                  ),
                  items: state.categories
                      .map((category) => DropdownMenuItem(
                            value: category!.id,
                            child: Text(category.name),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCategoryId = value;
                    });
                  },
                );
              } else {
                return const Text("Failed to load categories");
              }
            },
          ),
          const SizedBox(height: 16),
          // Tags Selector
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Price Range"),
              RangeSlider(
                values: priceRange,
                min: 0,
                max: 5000,
                divisions: 100,
                labels: RangeLabels(
                  "\$${priceRange.start.round()}",
                  "\$${priceRange.end.round()}",
                ),
                onChanged: (values) {
                  setState(() {
                    priceRange = values;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Apply Button
          ElevatedButton(
            onPressed: () {
              widget.onApplyFilters({
                'categoryId': selectedCategoryId,
                'tags': selectedTags,
                'priceRange': {
                  'min': priceRange.start.round(),
                  'max': priceRange.end.round(),
                },
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
