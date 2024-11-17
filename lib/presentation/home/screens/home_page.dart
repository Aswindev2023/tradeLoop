import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trade_loop/presentation/bloc/home_bloc/home_bloc.dart';
import 'package:trade_loop/presentation/home/widgets/category_row_widget.dart';
import 'package:trade_loop/presentation/home/widgets/filter_bottom_sheet.dart';
import 'package:trade_loop/presentation/home/widgets/product_grid.dart';
import 'package:trade_loop/presentation/navigation/bottom_naviagation_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });
  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final int selectedIndex = 0;
  late String userId;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    userId = FirebaseAuth.instance.currentUser!.uid;

    _searchController.addListener(() {
      final query = _searchController.text;
      print("Search Query: $query, Is Searching: $_isSearching");
      if (query.isNotEmpty) {
        setState(() {
          _isSearching = true;
        });

        context.read<HomeBloc>().add(SearchProductsEvent(
              query: query,
              userId: userId,
            ));
      } else {
        setState(() {
          _isSearching = false;
        });
        context.read<HomeBloc>().add(LoadProductsEvent(userId));
      }
    });
  }

  void _openFilters() {
    showModalBottomSheet(
      context: context,
      builder: (context) => FilterBottomSheet(
        onApplyFilters: (filters) {
          context.read<HomeBloc>().add(SearchProductsEvent(
                query: _searchController.text,
                userId: userId,
                categoryId: filters['categoryId'],
                tags: filters['tags'],
              ));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 17, 28, 233),
        centerTitle: true,
        title: const Text(
          'TradeLoop',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Irish Grover',
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          if (_isSearching)
            IconButton(
              icon: const Icon(
                Icons.filter_list,
                color: Colors.white,
              ),
              onPressed: _openFilters,
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Search Bar
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search products...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(),
                ),
                suffixIcon: const Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 10),
            if (!_isSearching) ...[
              CategoryRowWidget(
                userId: userId,
              ),
              const SizedBox(height: 20),
              // Heading
              const Text(
                'New Products',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
            const SizedBox(height: 10),
            // Product Grid
            Expanded(
              child: BlocConsumer<HomeBloc, HomeState>(
                listener: (context, state) {
                  if (state is HomePageError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message)),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is HomePageLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is HomePageLoaded) {
                    if (state.products.isEmpty) {
                      return const Center(
                          child: Text("No products available."));
                    } else {
                      return ProductGrid(products: state.products);
                    }
                  } else if (state is HomePageError) {
                    return Center(
                        child:
                            Text("Failed to load products: ${state.message}"));
                  } else {
                    return const Center(child: Text("No products available."));
                  }
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBarWidget(
        selectedIndex: selectedIndex,
      ),
    );
  }
}
