import 'package:flutter/material.dart';
import '../models/product.dart';
import '../utils/category_style.dart';
import 'category_tag.dart';
import 'delete_background.dart';

class ProductListItem extends StatelessWidget {
  final Product product;
  final VoidCallback onDismissed;

  const ProductListItem({super.key, required this.product, required this.onDismissed});

  @override
  Widget build(BuildContext context) {
    final color = categoryColor(product.category);
    return Dismissible(
      key: ValueKey(product.id),
      direction: DismissDirection.endToStart,
      background: const DeleteBackground(),
      onDismissed: (_) => onDismissed(),
      child: ListTile(
        tileColor: Theme.of(context).colorScheme.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: CircleAvatar(
          radius: 26,
          backgroundColor: color.withValues(alpha: 0.15),
          child: Icon(product.icon, color: color.shade700),
        ),
        title: Text(
          product.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Wrap(
            spacing: 10,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              CategoryTag(product.category),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.star_rounded, size: 16, color: Colors.amber),
                  const SizedBox(width: 2),
                  Text(product.rating.toStringAsFixed(1),
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                ],
              ),
            ],
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.green.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            '\$${product.price.toStringAsFixed(2)}',
            style: TextStyle(fontWeight: FontWeight.w800, color: Colors.green.shade800),
          ),
        ),
      ),
    );
  }
}
