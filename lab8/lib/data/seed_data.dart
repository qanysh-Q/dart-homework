import 'dart:math';
import 'package:flutter/material.dart';
import '../models/product.dart';

/// Initial catalog. Returns a fresh list every call, so "Reset Catalog"
/// restores exactly the original seed data.
List<Product> buildSeedProducts() => [
      const Product(id: '1', title: 'Wireless Headphones', category: 'Electronics', rating: 4.8, price: 99.99, icon: Icons.headphones),
      const Product(id: '2', title: 'Ergonomic Chair', category: 'Furniture', rating: 4.6, price: 249.99, icon: Icons.chair),
      const Product(id: '3', title: 'Running Shoes', category: 'Sports', rating: 4.9, price: 79.99, icon: Icons.directions_run),
      const Product(id: '4', title: 'Smart Watch', category: 'Electronics', rating: 4.5, price: 199.99, icon: Icons.watch),
      const Product(id: '5', title: 'Minimalist Backpack', category: 'Accessories', rating: 4.7, price: 59.99, icon: Icons.backpack),
      const Product(id: '6', title: 'Coffee Maker', category: 'Home', rating: 4.4, price: 129.99, icon: Icons.coffee),
    ];

const List<Product> _pool = [
  Product(id: '', title: 'Gaming Mouse', category: 'Electronics', rating: 4.5, price: 49.99, icon: Icons.mouse),
  Product(id: '', title: 'Desk Lamp', category: 'Home', rating: 4.5, price: 34.99, icon: Icons.light),
  Product(id: '', title: 'Bluetooth Speaker', category: 'Electronics', rating: 4.5, price: 89.99, icon: Icons.speaker),
  Product(id: '', title: 'Water Bottle', category: 'Sports', rating: 4.5, price: 24.99, icon: Icons.local_drink),
];

final Random _random = Random();

/// Simulates a product "arriving from the network" on pull-to-refresh.
/// The id is unique, so ValueKey(product.id) never collides.
Product generateNewProduct() {
  final base = _pool[_random.nextInt(_pool.length)];
  return Product(
    id: 'new_${DateTime.now().microsecondsSinceEpoch}',
    title: base.title,
    category: base.category,
    rating: 4.5 + _random.nextInt(5) * 0.1,
    price: base.price,
    icon: base.icon,
  );
}
