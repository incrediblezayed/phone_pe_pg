// To parse this JSON data, do
//
//     final upiIntentPaymentInstrument = upiIntentPaymentInstrumentFromJson(jsonString);

import 'package:phone_pe_pg/src/models/payment_instruments/account_constraints.dart';
import 'package:phone_pe_pg/src/models/payment_instruments/payment_instrument_model.dart';
import 'package:phone_pe_pg/src/models/payment_request_model.dart';

/// UpiIntentPaymentInstrument
class UpiCollectPaymentInstrument extends PaymentInstrument {
  /// UpiIntentPaymentInstrument
  /// This class is used to specify the upi collect details for upi collect payments
  /// This is a subclass of [PaymentInstrument]
  UpiCollectPaymentInstrument({
    required this.vpa,
    this.type = PaymentType.upiCollect,
    this.accountConstraints = const [],
  });

  /// PaymentType,
  /// this is optional field and is set to [PaymentType.upiCollect] by default
  final PaymentType type;

  /// Vpa
  /// This is the vpa of user from which you want to collect the payment
  /// This is a mandatory field
  final String vpa;

  /// AccountConstraints
  /// This is used to specify the accounts for upi collect payments
  final List<AccountConstraint> accountConstraints;

  @override
  Map<String, dynamic> toJson() => {
        'type': type.type,
        'vpa': vpa,
        if (accountConstraints.isNotEmpty)
          'accountConstraints':
              List<dynamic>.from(accountConstraints.map((x) => x.toJson())),
      };
}
