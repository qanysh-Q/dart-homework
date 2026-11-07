import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lab9/main.dart';

String badge(WidgetTester t) => t.widget<Text>(find.byKey(const Key('cart_badge_count'))).data!;

void main() {
  testWidgets('catalog shows products and no badge when cart is empty', (t) async {
    await t.pumpWidget(const CartApp());
    expect(find.text('Add to Cart'), findsWidgets);
    expect(find.byKey(const Key('cart_badge_count')), findsNothing);
  });

  testWidgets('Screen 2 removal and Clear All sync back to Screen 1', (t) async {
    await t.pumpWidget(const CartApp());

    // Screen 1: add two items -> badge = 2, buttons flip to "In Cart".
    await t.tap(find.text('Add to Cart').at(0));
    await t.pump();
    await t.tap(find.text('Add to Cart').at(0));
    await t.pump();
    expect(badge(t), '2');
    expect(find.text('In Cart'), findsNWidgets(2));

    // Screen 2: both items, total = 14 900 + 32 500 = 47 400.
    await t.tap(find.byTooltip('Cart'));
    await t.pumpAndSettle();
    expect(find.text('Cart (2)'), findsOneWidget);
    expect(t.widget<Text>(find.byKey(const Key('cart_total'))).data, '47 400 ₸');

    // Remove one item on Screen 2 -> total updates, badge on Screen 1 = 1.
    await t.tap(find.byTooltip('Remove Narxoz Hoodie'));
    await t.pumpAndSettle();
    expect(find.text('Cart (1)'), findsOneWidget);
    expect(t.widget<Text>(find.byKey(const Key('cart_total'))).data, '32 500 ₸');
    await t.pageBack();
    await t.pumpAndSettle();
    expect(badge(t), '1');
    expect(find.text('In Cart'), findsOneWidget);

    // Clear All on Screen 2 -> Screen 1 badge disappears, all buttons reset.
    await t.tap(find.byTooltip('Cart'));
    await t.pumpAndSettle();
    await t.tap(find.text('Clear All'));
    await t.pumpAndSettle();
    expect(find.text('Your cart is empty'), findsOneWidget);
    await t.pageBack();
    await t.pumpAndSettle();
    expect(find.byKey(const Key('cart_badge_count')), findsNothing);
    expect(find.text('In Cart'), findsNothing);
  });

  testWidgets('toggle twice removes the item again', (t) async {
    await t.pumpWidget(const CartApp());
    await t.tap(find.text('Add to Cart').first);
    await t.pump();
    expect(badge(t), '1');
    await t.tap(find.text('In Cart'));
    await t.pump();
    expect(find.byKey(const Key('cart_badge_count')), findsNothing);
  });
}
