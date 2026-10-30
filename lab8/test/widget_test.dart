import 'package:flutter_test/flutter_test.dart';
import 'package:lab8/main.dart';

void main() {
  testWidgets('swipe to delete shows UNDO and restores the item', (tester) async {
    await tester.pumpWidget(const SmartCatalogApp());
    expect(find.text('Wireless Headphones'), findsOneWidget);

    await tester.drag(find.text('Wireless Headphones'), const Offset(-600, 0));
    await tester.pumpAndSettle();
    expect(find.text('Wireless Headphones'), findsNothing);
    expect(find.text('UNDO'), findsOneWidget);

    await tester.tap(find.text('UNDO'));
    await tester.pumpAndSettle();
    expect(find.text('Wireless Headphones'), findsOneWidget);
  });
}
