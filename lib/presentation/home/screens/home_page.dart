import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trade_loop/core/constants/colors.dart';
import 'package:trade_loop/core/utils/custom_appbar.dart';
import 'package:trade_loop/core/utils/custom_text_widget.dart';
import 'package:trade_loop/core/utils/filter_utils.dart';
import 'package:trade_loop/core/utils/snackbar_utils.dart';
import 'package:trade_loop/presentation/bloc/home_bloc/home_bloc.dart';
import 'package:trade_loop/presentation/bloc/boolean_cubit/bool_cubit.dart';
import 'package:trade_loop/presentation/home/widgets/category_row_widget.dart';
import 'package:trade_loop/presentation/home/widgets/product_grid.dart';
import 'package:trade_loop/presentation/navigation/bottom_naviagation_widget.dart';
import 'package:trade_loop/presentation/navigation/side_navigation_bar_widget.dart';

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

  @override
  void initState() {
    super.initState();
    userId = FirebaseAuth.instance.currentUser!.uid;
    context.read<HomeBloc>().add(LoadProductsEvent(userId));

    _searchController.addListener(() {
      final query = _searchController.text;
      context.read<BoolCubit>().updateSearchState(query);

      if (query.isNotEmpty) {
        context.read<HomeBloc>().add(SearchProductsEvent(
              query: query,
              userId: userId,
            ));
      } else {
        context.read<HomeBloc>().add(LoadProductsEvent(userId));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        backgroundColor: appbarColor,
        centerTitle: true,
        title: 'TradeLoop',
        fontColor: whiteColor,
        fontFamily: 'Irish Grover',
        fontSize: 30,
        fontWeight: FontWeight.bold,
        actions: [
          BlocBuilder<BoolCubit, bool>(
            builder: (context, isSearching) {
              return Visibility(
                visible: isSearching,
                child: IconButton(
                  icon: const Icon(Icons.filter_list, color: whiteColor),
                  onPressed: () => openFilters(
                    context: context,
                    userId: userId,
                    searchController: _searchController,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      drawer: (kIsWeb)
          ? SideNavigationBarWidget(selectedIndex: selectedIndex)
          : null,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Search Bar
            TextField(
              autofocus: false,
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
            const Divider(),
            BlocBuilder<BoolCubit, bool>(
              builder: (context, isSearching) {
                return isSearching
                    ? const SizedBox()
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CategoryRowWidget(userId: userId),
                          const Divider(thickness: 2),
                          const SizedBox(height: 10),
                          const CustomTextWidget(
                            text: 'New Products',
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: blueAcc,
                          ),
                        ],
                      );
              },
            ),

            const SizedBox(height: 10),
            // Product Grid
            Expanded(
              child: BlocConsumer<HomeBloc, HomeState>(
                listener: (context, state) {
                  if (state is HomePageError) {
                    SnackbarUtils.showSnackbar(context, state.message);
                  }
                },
                builder: (context, state) {
                  if (state is HomePageLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is HomePageLoaded) {
                    if (state.products.isEmpty) {
                      return const Center(
                          child:
                              CustomTextWidget(text: "No products available."));
                    } else {
                      return ProductGrid(products: state.products);
                    }
                  } else if (state is HomePageError) {
                    return Center(
                        child: CustomTextWidget(
                            text: "Failed to load products: ${state.message}"));
                  } else {
                    return const Center(
                        child:
                            CustomTextWidget(text: "No products available."));
                  }
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: (kIsWeb)
          ? null
          : BottomNavigationBarWidget(
              selectedIndex: selectedIndex,
            ),
    );
  }
}
