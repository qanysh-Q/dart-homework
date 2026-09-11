void checkBalance({
  required String name,
  required double balance,
}) => print('$name, your current balance is $balance T');

double deposit({
  required double currentBalance,
  double? amount,
}) {
  final depositAmount = amount ?? 0.0;
  final updatedBalance = currentBalance + depositAmount;

  print('Deposit: $depositAmount T');
  print('Balance: $updatedBalance T');

  return updatedBalance;
}

double withdraw({
  required String name,
  required double currentBalance,
  double? amount,
  int? pinCode,
}) {
  final enteredPin = pinCode ?? 0000;

  if (enteredPin != 1234) {
    print('Transaction declined: incorrect PIN.');
    return currentBalance;
  }

  final withdrawAmount = amount ?? 0.0;

  if (withdrawAmount > currentBalance) {
    print('Transaction declined: insufficient funds.');
    return currentBalance;
  }

  final updatedBalance = currentBalance - withdrawAmount;

  print('Withdrawal: $withdrawAmount T');
  print('Name: $name');
  print('Balance: $updatedBalance T');

  return updatedBalance;
}

void main() {
  double balance = 10000.0;

  checkBalance(
    name: 'Qanysh',
    balance: balance,
  );

  balance = deposit(
    currentBalance: balance,
    amount: 5000.0,
  );

  balance = withdraw(
    name: 'Qanysh',
    currentBalance: balance,
    amount: 3000.0,
    pinCode: 1234,
  );

  checkBalance(
    name: 'Qanysh',
    balance: balance,
  );
}