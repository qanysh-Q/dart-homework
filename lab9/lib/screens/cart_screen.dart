import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../utils/category_style.dart';
import '../utils/format.dart';

/// Screen 2: selected products, per-item removal, total and "Clear All".
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Cart (${cart.count})', style: const TextStyle(fontWeight: FontWeight.w800)),
        actions: [
          TextButton.icon(
            onPressed: cart.isEmpty ? null : () => context.read<CartProvider>().clear(),
            icon: const Icon(Icons.delete_sweep_outlined),
            label: const Text('Clear All'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: cart.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.remove_shopping_cart, size: 64, color: scheme.primary),
                  const SizedBox(height: 16),
                  const Text('Your cart is empty',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Back to catalog'),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    itemCount: cart.items.length,
                    separatorBuilder: (_, _) => const Divider(height: 1, indent: 84),
                    itemBuilder: (context, i) {
                      final p = cart.items[i];
                      final color = categoryColor(p.category);
                      return ListTile(
                        key: ValueKey(p.id),
                        tileColor: scheme.surface,
                        leading: CircleAvatar(
                          radius: 26,
                          backgroundColor: color.withValues(alpha: 0.15),
                          child: Icon(p.icon, color: color.shade700),
                        ),
                        title: Text(p.title, style: const TextStyle(fontWeight: FontWeight.w700)),
                        subtitle: Text(formatPrice(p.price)),
                        trailing: IconButton(
                          tooltip: 'Remove ${p.title}',
                          icon: const Icon(Icons.delete_outline, color: Colors.red),
                          onPressed: () => context.read<CartProvider>().remove(p),
                        ),
                      );
                    },
                  ),
                ),
                Material(
                  elevation: 8,
                  color: scheme.surface,
                  child: SafeArea(
                    top: false,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total', style: TextStyle(fontSize: 18)),
                          Text(
                            formatPrice(cart.totalPrice),
                            key: const Key('cart_total'),
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: Colors.green.shade800),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
