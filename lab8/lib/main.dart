import 'package:flutter/material.dart';
import 'screens/catalog_screen.dart';

void main() => runApp(const SmartCatalogApp());

class SmartCatalogApp extends StatelessWidget {
  const SmartCatalogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Catalog',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        scaffoldBackgroundColor: const Color(0xFFF6F4FB),
        appBarTheme: const AppBarTheme(backgroundColor: Color(0xFFF6F4FB), scrolledUnderElevation: 0),
        useMaterial3: true,
      ),
      home: const CatalogScreen(),
    );
  }
}
