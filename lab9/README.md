# LW9 — Multi-Screen Global Cart with Live Badge

Provider + ChangeNotifier. `CartProvider` wraps `MaterialApp`.

- Screen 1 (Catalog): 6 products, "Add to Cart" toggles, live AppBar badge.
- Screen 2 (Cart): selected items, per-item remove, total price, "Clear All".
- Changes on Screen 2 sync to Screen 1 instantly (shared provider state).

Run: `flutter pub get && flutter run` · Test: `flutter test`
