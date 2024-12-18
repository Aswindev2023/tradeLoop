import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class ShareProductWidget extends StatelessWidget {
  final String productId;
  final String productName;

  const ShareProductWidget({
    super.key,
    required this.productId,
    this.productName = '',
  });

  void _shareProduct() {
    final productLink = 'tradeloop://product/$productId';

    final shareText = productName.isNotEmpty
        ? 'Check out $productName on TradeLoop: $productLink'
        : 'Check out this product on TradeLoop: $productLink';

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
