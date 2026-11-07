import 'package:flutter/material.dart';

class Product {
  final String id;
  final String title;
  final String category;
  final double price;
  final IconData icon;

  const Product({
    required this.id,
    required this.title,
    required this.category,
    required this.price,
    required this.icon,
  });
}
