import 'package:flutter/material.dart';
import '../models/product.dart';
import '../utils/category_style.dart';
import 'category_tag.dart';
import 'delete_background.dart';

class ProductGridCard extends StatelessWidget {
  final Product product;
  final VoidCallback onDismissed;

  const ProductGridCard({super.key, required this.product, required this.onDismissed});

  @override
  Widget build(BuildContext context) {
    final color = categoryColor(product.category);
    final radius = BorderRadius.circular(18);
    return Dismissible(
      key: ValueKey(product.id),
      direction: DismissDirection.endToStart,
      background: DeleteBackground(borderRadius: radius),
      onDismissed: (_) => onDismissed(),
      child: Card(
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
                child: Stack(
                  children: [
                    Center(child: Icon(product.icon, size: 52, color: Colors.white)),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.35),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star_rounded, size: 14, color: Colors.amber),
                            const SizedBox(width: 2),
                            Text(
                              product.rating.toStringAsFixed(1),
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    product.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                  ),
                  const SizedBox(height: 4),
                  CategoryTag(product.category),
                  const SizedBox(height: 6),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: TextStyle(
                        fontWeight: FontWeight.w800, fontSize: 16, color: Colors.green.shade700),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
