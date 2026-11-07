import 'package:flutter/material.dart';

/// One accent color per category, used for avatars, tags and grid headers.
MaterialColor categoryColor(String category) {
  switch (category) {
    case 'Clothing':
      return Colors.pink;
    case 'Gadgets':
      return Colors.indigo;
    case 'Books':
      return Colors.deepOrange;
    case 'Stationery':
      return Colors.teal;
    case 'Drinks':
      return Colors.brown;
    default:
      return Colors.blueGrey;
  }
}
