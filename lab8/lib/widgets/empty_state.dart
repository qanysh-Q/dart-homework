import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  final VoidCallback onReset;
  const EmptyState({super.key, required this.onReset});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(color: scheme.primaryContainer, shape: BoxShape.circle),
              child: Icon(Icons.remove_shopping_cart, size: 64, color: scheme.primary),
            ),
            const SizedBox(height: 24),
            const Text('Catalog is Empty',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            Text('You removed every product.',
                style: TextStyle(color: scheme.onSurfaceVariant)),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onReset,
              icon: const Icon(Icons.restart_alt),
              label: const Text('Reset Catalog'),
            ),
          ],
        ),
      ),
    );
  }
}
