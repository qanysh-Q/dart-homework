import 'package:flutter/material.dart';

/// One accent color per category, used for avatars, tags and grid headers.
MaterialColor categoryColor(String category) {
  switch (category) {
    case 'Electronics':
      return Colors.indigo;
    case 'Furniture':
      return Colors.brown;
    case 'Sports':
      return Colors.orange;
    case 'Accessories':
      return Colors.pink;
    case 'Home':
      return Colors.teal;
    default:
      return Colors.blueGrey;
  }
}
