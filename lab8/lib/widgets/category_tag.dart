import 'package:flutter/material.dart';
import '../utils/category_style.dart';

class CategoryTag extends StatelessWidget {
  final String label;
  const CategoryTag(this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    final color = categoryColor(label);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color.shade700),
      ),
    );
  }
}
