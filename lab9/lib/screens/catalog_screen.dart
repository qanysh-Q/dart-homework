import 'package:flutter/material.dart';
import '../data/seed_data.dart';
import '../widgets/cart_badge_button.dart';
import '../widgets/catalog_card.dart';

/// Screen 1: 6 products with "Add to Cart" toggles and a live AppBar badge.
class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('Campus Store', style: TextStyle(fontWeight: FontWeight.w800)),
        actions: const [CartBadgeButton(), SizedBox(width: 8)],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.68,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: kProducts.length,
        itemBuilder: (context, i) => CatalogCard(product: kProducts[i]),
      ),
    );
  }
}
