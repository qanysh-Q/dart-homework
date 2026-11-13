import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';

void main() => runApp(const ProductExplorerApp());

class Product {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String imageUrl;
  final double rating;
  final int reviewCount;

  const Product({required this.id, required this.title, required this.price,
    required this.description, required this.category, required this.imageUrl,
    required this.rating, required this.reviewCount});

  factory Product.fromJson(Map<String, dynamic> json) {
    double asDouble(dynamic value, [double fallback = 0]) {
      if (value is num) return value.toDouble();
      return double.tryParse(value?.toString() ?? '') ?? fallback;
    }
    int asInt(dynamic value, [int fallback = 0]) {
      if (value is num) return value.toInt();
      return int.tryParse(value?.toString() ?? '') ?? fallback;
    }
    final rawRating = json['rating'];
    final ratingMap = rawRating is Map ? rawRating : const {};
    return Product(
      id: asInt(json['id']),
      title: (json['title'] ?? 'Untitled product').toString(),
      price: asDouble(json['price']),
      description: (json['description'] ?? 'No description available.').toString(),
      category: (json['category'] ?? 'Uncategorized').toString(),
      imageUrl: (json['image'] ?? '').toString(),
      rating: asDouble(ratingMap['rate']),
      reviewCount: asInt(ratingMap['count']),
    );
  }
}

class ProductExplorerApp extends StatelessWidget {
  const ProductExplorerApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Shoply',
    theme: ThemeData(colorSchemeSeed: const Color(0xff5b5bd6), useMaterial3: true,
      scaffoldBackgroundColor: const Color(0xfff7f7fb)),
    home: const ProductFeedScreen(),
  );
}

class ProductFeedScreen extends StatefulWidget {
  const ProductFeedScreen({super.key});
  @override
  State<ProductFeedScreen> createState() => _ProductFeedScreenState();
}

class _ProductFeedScreenState extends State<ProductFeedScreen> {
  static final _uri = Uri.parse('https://fakestoreapi.com/products');
  List<Product> _products = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() { super.initState(); _loadProducts(); }

  Future<void> _loadProducts() async {
    setState(() { _loading = true; _error = null; });
    try {
      final response = await http.get(_uri).timeout(const Duration(seconds: 10));
      if (response.statusCode != 200) throw Exception('Server returned ${response.statusCode}');
      final decoded = jsonDecode(response.body);
      if (decoded is! List) throw const FormatException('Unexpected response');
      final items = decoded.whereType<Map<String, dynamic>>().map(Product.fromJson).toList();
      if (!mounted) return;
      setState(() { _products = items; _loading = false; });
    } catch (_) {
      if (!mounted) return;
      setState(() { _loading = false; _error = 'Could not connect. Check your internet connection and try again.'; });
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Discover'), centerTitle: false),
    body: _loading
      ? const Center(child: CircularProgressIndicator())
      : _error != null
        ? _ErrorView(message: _error!, onRetry: _loadProducts)
        : RefreshIndicator(onRefresh: _loadProducts, child: _products.isEmpty
          ? ListView(children: const [SizedBox(height: 220), Center(child: Text('No products found'))])
          : GridView.builder(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            physics: const AlwaysScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, childAspectRatio: .63, crossAxisSpacing: 14, mainAxisSpacing: 14),
            itemCount: _products.length,
            itemBuilder: (context, index) => _ProductCard(product: _products[index]),
          )),
  );
}

class _ErrorView extends StatelessWidget {
  final String message; final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});
  @override
  Widget build(BuildContext context) => Center(child: Padding(
    padding: const EdgeInsets.all(32), child: Column(mainAxisSize: MainAxisSize.min, children: [
      const Icon(Icons.wifi_off_rounded, size: 64, color: Colors.grey),
      const SizedBox(height: 16), const Text('You are offline', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
      const SizedBox(height: 8), Text(message, textAlign: TextAlign.center),
      const SizedBox(height: 20), FilledButton.icon(onPressed: onRetry,
        icon: const Icon(Icons.refresh), label: const Text('Retry Connection')),
    ]),
  ));
}

class _ProductCard extends StatelessWidget {
  final Product product;
  const _ProductCard({required this.product});
  @override
  Widget build(BuildContext context) => Card(
    clipBehavior: Clip.antiAlias, elevation: 1, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
    child: InkWell(onTap: () => Navigator.push(context, MaterialPageRoute(
      builder: (_) => ProductDetailScreen(product: product))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(child: Container(width: double.infinity, color: Colors.white, padding: const EdgeInsets.all(14),
          child: Hero(tag: 'product_image_${product.id}', child: _ProductImage(url: product.imageUrl)))),
        Padding(padding: const EdgeInsets.fromLTRB(12, 10, 12, 12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(product.category.toUpperCase(), maxLines: 1, overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 10, letterSpacing: 1, color: Colors.deepPurple, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5), Text(product.title, maxLines: 2, overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w600, height: 1.2)),
          const SizedBox(height: 8), Row(children: [Text('\$${product.price.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const Spacer(), const Icon(Icons.star, size: 15, color: Colors.amber), Text(product.rating.toStringAsFixed(1), style: const TextStyle(fontSize: 12))]),
        ])),
      ])),
  );
}

class _ProductImage extends StatelessWidget {
  final String url; const _ProductImage({required this.url});
  @override
  Widget build(BuildContext context) => url.isEmpty
    ? const Icon(Icons.image_not_supported_outlined, size: 60, color: Colors.grey)
    : Image.network(url, fit: BoxFit.contain, errorBuilder: (_, __, ___) => const Icon(Icons.broken_image_outlined, size: 60));
}

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});
  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _page = 0;
  final _controller = PageController();
  // Fake Store API provides one image per product. Keep PageView ready for more images.
  List<String> get _images => widget.product.imageUrl.isEmpty ? [] : [widget.product.imageUrl];

  Future<void> _showShareSheet() async {
    final link = 'narxoz://store/product/${widget.product.id}';
    await showModalBottomSheet<void>(context: context, showDragHandle: true,
      builder: (sheetContext) => SafeArea(child: Padding(padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Share product', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 14), const Text('Deep link'),
          const SizedBox(height: 8), Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.black.withValues(alpha: .05), borderRadius: BorderRadius.circular(12)),
            child: Row(children: [Expanded(child: SelectableText(link)), IconButton(tooltip: 'Copy link', icon: const Icon(Icons.copy), onPressed: () async {
              await Clipboard.setData(ClipboardData(text: link));
              if (sheetContext.mounted) ScaffoldMessenger.of(sheetContext).showSnackBar(const SnackBar(content: Text('Link copied')));
            })])),
          const SizedBox(height: 12), SizedBox(width: double.infinity, child: OutlinedButton.icon(
            onPressed: () => Share.share(link), icon: const Icon(Icons.share), label: const Text('Share link'))),
        ]))));
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    return Scaffold(
      appBar: AppBar(title: const Text('Product details'), actions: [IconButton(onPressed: _showShareSheet, icon: const Icon(Icons.share_outlined), tooltip: 'Share')]),
      body: ListView(padding: const EdgeInsets.only(bottom: 24), children: [
        SizedBox(height: 330, child: PageView.builder(controller: _controller, itemCount: _images.isEmpty ? 1 : _images.length,
          onPageChanged: (page) => setState(() => _page = page),
          itemBuilder: (_, index) => Container(color: Colors.white, padding: const EdgeInsets.all(28),
            child: index == 0 ? Hero(tag: 'product_image_${product.id}', child: _ProductImage(url: product.imageUrl)) : _ProductImage(url: _images[index])))),
        if (_images.length > 1) Padding(padding: const EdgeInsets.only(top: 12), child: Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(_images.length, (i) => AnimatedContainer(
          duration: const Duration(milliseconds: 250), margin: const EdgeInsets.symmetric(horizontal: 3), width: _page == i ? 20 : 7, height: 7,
          decoration: BoxDecoration(color: _page == i ? Colors.deepPurple : Colors.black26, borderRadius: BorderRadius.circular(8)))))) ,
        Center(child: Padding(padding: const EdgeInsets.only(top: 8), child: Text('${_page + 1} / ${_images.isEmpty ? 1 : _images.length}', style: const TextStyle(color: Colors.black54)))),
        Padding(padding: const EdgeInsets.fromLTRB(20, 22, 20, 12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: Colors.deepPurple.withValues(alpha: .1), borderRadius: BorderRadius.circular(20)),
            child: Text(product.category, style: const TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.w600))),
          const SizedBox(height: 14), Text(product.title, style: const TextStyle(fontSize: 24, height: 1.2, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12), Row(children: [const Icon(Icons.star, color: Colors.amber), const SizedBox(width: 4), Text('${product.rating.toStringAsFixed(1)} (${product.reviewCount} reviews)')]),
          const SizedBox(height: 16), Text('\$${product.price.toStringAsFixed(2)}', style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
          const SizedBox(height: 22), const Text('Description', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8), Text(product.description, style: const TextStyle(fontSize: 15, height: 1.55, color: Colors.black87)),
        ])),
      ]),
      bottomNavigationBar: SafeArea(child: Padding(padding: const EdgeInsets.fromLTRB(16, 10, 16, 14), child: SizedBox(height: 54,
        child: FilledButton.icon(onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Added to cart'))),
          icon: const Icon(Icons.shopping_bag_outlined), label: const Text('Add to Cart'))))),
    );
  }
}
