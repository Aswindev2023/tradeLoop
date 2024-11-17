import 'package:flutter/material.dart';
import 'package:trade_loop/presentation/home/model/home_page_product_model.dart';
import 'package:trade_loop/presentation/home/widgets/filter_bottom_sheet.dart';
import 'package:trade_loop/presentation/home/widgets/product_grid.dart';

class SearchPage extends StatefulWidget {
  final List<HomePageProductModel> initialProducts;

  const SearchPage({super.key, required this.initialProducts});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<HomePageProductModel> _filteredProducts = [];
  final TextEditingController _searchController = TextEditingController();
  String? _selectedCategoryId;
  List<String> _selectedTags = [];
  Map<String, int> _priceRange = {'min': 0, 'max': 5000};

  @override
  void initState() {
    super.initState();
    _filteredProducts = widget.initialProducts;
  }

  void _applyFilters(Map<String, dynamic> filters) {
    setState(() {
      _selectedCategoryId = filters['categoryId'] as String?;
      _selectedTags = filters['tags'] as List<String>;
      _priceRange = filters['priceRange'] as Map<String, int>;
    });
    _filterProducts(_searchController.text);
  }

  void _filterProducts(String query) {
    setState(() {
      _filteredProducts = widget.initialProducts.where((product) {
        final matchesQuery = product.name
                .toLowerCase()
                .contains(query.toLowerCase()) ||
            product.tags
                .any((tag) => tag.toLowerCase().contains(query.toLowerCase()));
        final matchesCategory = _selectedCategoryId == null ||
            product.categoryId == _selectedCategoryId;
        final matchesTags = _selectedTags.isEmpty ||
            _selectedTags.any((tag) => product.tags.contains(tag));
        final matchesPrice = product.price >= _priceRange['min']! &&
            product.price <= _priceRange['max']!;
        return matchesQuery && matchesCategory && matchesTags && matchesPrice;
      }).toList();
    });
  }

  void _openFilters() {
    showModalBottomSheet(
      context: context,
      builder: (context) => FilterBottomSheet(
        onApplyFilters: _applyFilters,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Search products...',
            border: InputBorder.none,
          ),
          onChanged: _filterProducts,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _openFilters,
          ),
        ],
      ),
      body: ProductGrid(products: _filteredProducts),
    );
  }
}
