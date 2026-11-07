import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../screens/cart_screen.dart';

/// AppBar cart icon with a live item-count badge.
class CartBadgeButton extends StatelessWidget {
  const CartBadgeButton({super.key});

  @override
  Widget build(BuildContext context) {
    final count = context.select<CartProvider, int>((c) => c.count);
    return IconButton(
      tooltip: 'Cart',
      onPressed: () => Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => const CartScreen())),
      icon: Badge(
        isLabelVisible: count > 0,
        label: Text('$count', key: const Key('cart_badge_count')),
        child: const Icon(Icons.shopping_cart_outlined),
      ),
    );
  }
}
