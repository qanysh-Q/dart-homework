import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/seed_data.dart';
import '../models/product.dart';
import '../widgets/empty_state.dart';
import '../widgets/product_grid_card.dart';
import '../widgets/product_list_item.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  bool _isGridView = false;
  final List<Product> _products = buildSeedProducts();

  /// Pull-to-refresh: 1.5 s simulated request, new item goes to index 0.
  Future<void> _handleRefresh() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;
    setState(() => _products.insert(0, generateNewProduct()));
  }

  void _removeProduct(int index) {
    final removed = _products[index];
    HapticFeedback.mediumImpact();
    setState(() => _products.removeAt(index));

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          content: Text('Removed ${removed.title}'),
          duration: const Duration(seconds: 4),
          action: SnackBarAction(
            label: 'UNDO',
            onPressed: () {
              if (!mounted) return;
              // Restore at the original index (clamped if the list changed meanwhile).
              setState(() => _products.insert(min(index, _products.length), removed));
            },
          ),
        ),
      );
  }

  void _resetCatalog() {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    setState(() {
      _products
        ..clear()
        ..addAll(buildSeedProducts());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Smart Catalog', style: TextStyle(fontWeight: FontWeight.w800)),
            Text('${_products.length} products · pull to refresh · swipe to delete',
                style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurfaceVariant)),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(_isGridView ? Icons.view_list_rounded : Icons.grid_view_rounded),
            tooltip: _isGridView ? 'Switch to List' : 'Switch to Grid',
            onPressed: () => setState(() => _isGridView = !_isGridView),
          ),
        ],
      ),
      body: _products.isEmpty
          ? EmptyState(onReset: _resetCatalog)
          : RefreshIndicator(
              onRefresh: _handleRefresh,
              child: _isGridView ? _buildGrid() : _buildList(),
            ),
    );
  }

  Widget _buildList() {
    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: _products.length,
      separatorBuilder: (context, index) => const Divider(height: 1, thickness: 0.5, indent: 84),
      itemBuilder: (context, index) => ProductListItem(
        product: _products[index],
        onDismissed: () => _removeProduct(index),
      ),
    );
  }

  Widget _buildGrid() {
    return GridView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.72,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: _products.length,
      itemBuilder: (context, index) => ProductGridCard(
        product: _products[index],
        onDismissed: () => _removeProduct(index),
      ),
    );
  }
}
