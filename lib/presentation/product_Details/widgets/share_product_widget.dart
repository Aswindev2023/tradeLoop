import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class ShareProductWidget extends StatelessWidget {
  final String productId; // Unique ID for the product
  final String productName; // Optional name of the product

  const ShareProductWidget({
    super.key,
    required this.productId,
    this.productName = '',
  });

  void _shareProduct() {
    // Generate the custom link
    final productLink = 'tradeloop://product/$productId';

    // Text to share
    final shareText = productName.isNotEmpty
        ? 'Check out $productName on TradeLoop: $productLink'
        : 'Check out this product on TradeLoop: $productLink';

    // Trigger sharing
    Share.share(shareText);
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.share,
        color: Colors.white,
        size: 29,
      ),
      onPressed: _shareProduct,
      tooltip: 'Share Product',
    );
  }
}
