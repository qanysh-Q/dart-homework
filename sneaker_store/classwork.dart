double processOrder({
  required String orderId,
  required double itemPrice,
  String? promoCode,
  double? deliveryFee,
}) {
  double discount = 0.0;

  if (promoCode == 'SAVE10') {
    discount = itemPrice * 0.10;
  }

  final delivery = deliveryFee ?? 500.0;

  final finalTotal = itemPrice - discount + delivery;

  print('--- Order Summary ---');
  print('Order ID: $orderId');
  print('Item price: $itemPrice T');
  print('Discount: $discount T');
  print('Delivery fee: $delivery T');
  print('Final total: $finalTotal T');

  return finalTotal;
}

void main() {
  final total = processOrder(
    orderId: 'ORD-001',
    itemPrice: 10000.0,
    promoCode: 'SAVE10',
  );

  print('Returned total: $total T');
}