import 'dart:collection';
import 'package:flutter/foundation.dart';
import '../models/product.dart';

/// Single source of truth for the cart. Both screens read from it, so any
/// change made on one screen is instantly reflected on the other.
class CartProvider extends ChangeNotifier {
  final List<Product> _items = [];

  UnmodifiableListView<Product> get items => UnmodifiableListView(_items);

  int get count => _items.length;

  bool get isEmpty => _items.isEmpty;

  double get totalPrice => _items.fold(0.0, (sum, p) => sum + p.price);

  bool contains(Product product) => _items.any((p) => p.id == product.id);

  /// "Add to Cart" toggle: adds the product, or removes it if already added.
  void toggle(Product product) {
    if (contains(product)) {
      remove(product);
    } else {
      _items.add(product);
      notifyListeners();
    }
  }

  void remove(Product product) {
    final before = _items.length;
    _items.removeWhere((p) => p.id == product.id);
    if (_items.length != before) notifyListeners();
  }

  void clear() {
    if (_items.isEmpty) return;
    _items.clear();
    notifyListeners();
  }
}
