import 'package:flutter/material.dart';
import 'package:trade_loop/presentation/product_Details/screens/product_details_page.dart';
import 'package:uni_links/uni_links.dart';

/// Handles deep links by navigating to the corresponding product details page if a valid product link is detected.

Future<void> handleDeepLinks(BuildContext context) async {
  final initialLink = await getInitialLink();
  if (initialLink != null && initialLink.startsWith('tradeloop://product/')) {
    final productId = initialLink.split('/').last;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductDetailsPage(
            productId: productId,
          ),
        ),
      );
    });
  }
}
