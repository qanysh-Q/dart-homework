import 'package:flutter/material.dart';
import '../models/product.dart';

/// The 6 products shown on the catalog screen.
const List<Product> kProducts = [
  Product(id: '1', title: 'Narxoz Hoodie', category: 'Clothing', price: 14900, icon: Icons.checkroom),
  Product(id: '2', title: 'Mechanical Keyboard', category: 'Gadgets', price: 32500, icon: Icons.keyboard),
  Product(id: '3', title: 'Flutter & Dart Book', category: 'Books', price: 8900, icon: Icons.menu_book),
  Product(id: '4', title: 'Dotted Notebook A5', category: 'Stationery', price: 3200, icon: Icons.edit_note),
  Product(id: '5', title: 'Cold Brew Coffee', category: 'Drinks', price: 1500, icon: Icons.local_cafe),
  Product(id: '6', title: 'Wireless Earbuds', category: 'Gadgets', price: 18700, icon: Icons.headphones),
];
