// To parse this JSON data, do
//
//     final upiIntentPaymentInstrument = upiIntentPaymentInstrumentFromJson(jsonString);

import 'package:phone_pe_pg/src/models/payment_instruments/account_constraints.dart';
import 'package:phone_pe_pg/src/models/payment_instruments/payment_instrument_model.dart';
import 'package:phone_pe_pg/src/models/payment_request_model.dart';

/// UpiQrPaymentInstrument
class UpiQrPaymentInstrument extends PaymentInstrument {
  /// UpiQrPaymentInstrument
  /// This class is used to specify the upi qr details for upi qr payments
  /// This is a subclass of [PaymentInstrument]
  UpiQrPaymentInstrument({
    this.type = PaymentType.upiQr,
    this.accountConstraints = const [],
  });

  /// PaymentType,
  /// this is optional field and is set to [PaymentType.upiQr] by default
  final PaymentType type;

  /// AccountConstraints
  /// This is used to specify the accounts for upi qr payments
  final List<AccountConstraint> accountConstraints;

  @override
  Map<String, dynamic> toJson() => {
        'type': type.type,
        if (accountConstraints.isNotEmpty)
          'accountConstraints':
              List<dynamic>.from(accountConstraints.map((x) => x.toJson())),
      };
}
