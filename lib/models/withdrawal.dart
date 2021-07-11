import 'package:cash_pump/assets/assets.gen.dart';
import 'package:number_display/number_display.dart';
import 'package:timeago/timeago.dart' as timeago;

final moneiteryDisplay = createDisplay(
  length: 5,
  decimal: 2,
  placeholder: '--',
  separator: ',',
  decimalPoint: '.',
  units: ['K', 'M', 'B', 'T'],
);

class Withdrawal {
  final DateTime time;
  final double amount;
  final WithdrawalMethod method;
  final String id;

  const Withdrawal({
    required this.time,
    required this.amount,
    required this.method,
    required this.id,
  });

  String fstr(WithdrawalField field) {
    switch (field) {
      case WithdrawalField.Time:
        return timeago.format(time);
      case WithdrawalField.Amount:
        return '\$ ${moneiteryDisplay(amount)}';
      case WithdrawalField.Method:
        return method.str;
      case WithdrawalField.Id:
        return id;
    }
  }
}

enum WithdrawalField { Time, Amount, Method, Id }

extension WithdrawalFieldExtension on WithdrawalField {
  String get str {
    switch (this) {
      case WithdrawalField.Time:
        return 'Time';
      case WithdrawalField.Amount:
        return 'Amount';
      case WithdrawalField.Method:
        return 'Method';
      case WithdrawalField.Id:
        return 'ID';
    }
  }
}

enum WithdrawalMethod { Payoneer, Paypal, Paytm, WebMoney }

extension WithdrawalMethodExtension on WithdrawalMethod {
  String get str {
    switch (this) {
      case WithdrawalMethod.Payoneer:
        return 'Payoneer';
      case WithdrawalMethod.Paypal:
        return 'Paypal';
      case WithdrawalMethod.Paytm:
        return 'Paytm';
      case WithdrawalMethod.WebMoney:
        return 'WebMoney';
    }
  }

  SvgGenImage get logo {
    switch (this) {
      case WithdrawalMethod.Payoneer:
        return Assets.images.brands.payoneer;
      case WithdrawalMethod.Paypal:
        return Assets.images.brands.payPal;
      case WithdrawalMethod.Paytm:
        return Assets.images.brands.paytm;
      case WithdrawalMethod.WebMoney:
        return Assets.images.brands.webMoney;
    }
  }
}
