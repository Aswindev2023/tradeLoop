import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trade_loop/presentation/bloc/home_bloc/home_bloc.dart';
import 'package:trade_loop/presentation/home/widgets/filter_bottom_sheet.dart';

void openFilters({
  required BuildContext context,
  required String userId,
  required TextEditingController searchController,
}) {
  showModalBottomSheet(
    context: context,
    builder: (context) => FilterBottomSheet(
      onApplyFilters: (filters) {
        context.read<HomeBloc>().add(SearchProductsEvent(
              query: searchController.text,
              userId: userId,
              categoryId: filters['categories'],
              tags: filters['tags'],
              priceRanges: filters['priceRanges'],
            ));
      },
    ),
  );
}
