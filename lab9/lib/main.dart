import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/cart_provider.dart';
import 'screens/catalog_screen.dart';

void main() => runApp(const CartApp());

class CartApp extends StatelessWidget {
  const CartApp({super.key});

  @override
  Widget build(BuildContext context) {
    // The provider wraps MaterialApp, so every route can reach the same cart.
    return ChangeNotifierProvider(
      create: (_) => CartProvider(),
      child: MaterialApp(
        title: 'Campus Store',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
          scaffoldBackgroundColor: const Color(0xFFF1F7F6),
          appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFFF1F7F6), scrolledUnderElevation: 0),
          useMaterial3: true,
        ),
        home: const CatalogScreen(),
      ),
    );
  }
}
