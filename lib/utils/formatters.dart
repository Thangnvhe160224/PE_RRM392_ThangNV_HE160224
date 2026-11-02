import '../models/currency.dart';

String formatMoney(int amountVnd, Currency currency) {
  if (currency == Currency.usd) {
    return '${(amountVnd / vndPerUsd).toStringAsFixed(2)} USD';
  }
  return '${_addCommas(amountVnd)} VND';
}

String _addCommas(int number) {
  final digits = number.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buffer.write(',');
    buffer.write(digits[i]);
  }
  return buffer.toString();
}

String formatDate(DateTime date) {
  String two(int n) => n.toString().padLeft(2, '0');
  return '${two(date.day)}/${two(date.month)}/${date.year}';
}
