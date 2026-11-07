import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../utils/category_style.dart';
import '../utils/format.dart';

class CatalogCard extends StatelessWidget {
  final Product product;
  const CatalogCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final color = categoryColor(product.category);
    final inCart = context.select<CartProvider, bool>((c) => c.contains(product));
    final radius = BorderRadius.circular(18);

    return Card(
      margin: EdgeInsets.zero,
      elevation: 3,
      shadowColor: color.withValues(alpha: 0.4),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: radius),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [color.shade300, color.shade700],
                ),
              ),
              child: Center(child: Icon(product.icon, size: 52, color: Colors.white)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(product.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                const SizedBox(height: 4),
                Text(formatPrice(product.price),
                    style: TextStyle(
                        fontWeight: FontWeight.w800, fontSize: 16, color: Colors.green.shade700)),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: inCart
                      ? FilledButton.icon(
                          onPressed: () => context.read<CartProvider>().toggle(product),
                          icon: const Icon(Icons.check, size: 18),
                          label: const Text('In Cart'),
                        )
                      : OutlinedButton.icon(
                          onPressed: () => context.read<CartProvider>().toggle(product),
                          icon: const Icon(Icons.add_shopping_cart, size: 18),
                          label: const Text('Add to Cart'),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
