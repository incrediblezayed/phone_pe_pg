// To parse this JSON data, do
//
//     final upiIntentPaymentInstrument = upiIntentPaymentInstrumentFromJson(jsonString);

import 'package:phone_pe_pg/src/models/payment_instruments/account_constraints.dart';
import 'package:phone_pe_pg/src/models/payment_instruments/payment_instrument_model.dart';
import 'package:phone_pe_pg/src/models/payment_request_model.dart';

/// UpiIntentPaymentInstrument
///
class UpiIntentPaymentInstrument extends PaymentInstrument {
  /// UpiIntentPaymentInstrument
  /// This class is used to specify the upi intent details for upi intent payments
  /// This is a subclass of [PaymentInstrument]
  UpiIntentPaymentInstrument({
    required this.targetApp,
    this.type = PaymentType.upiIntent,
    this.accountConstraints = const [],
  });

  /// PaymentType,
  /// this is optional field and is set to [PaymentType.upiIntent] by default
  final PaymentType type;

  /// TargetApp
  /// This is the target app for the upi intent
  /// For Android it should be the package name of the app you want to make payment from
  /// for example: if you want to make payment from phonepe app. then the target app should be
  /// com.phonepe.app
  /// for iOS it should be the name of app in UpperCase
  /// for example: if you want to make payment from phonepe app. then the target app should be
  /// PHONEPE
  final String targetApp;

  /// AccountConstraints
  /// This is used to specify the accounts for upi intent payments
  final List<AccountConstraint> accountConstraints;

  @override
  Map<String, dynamic> toJson() => {
        'type': type.type,
        'targetApp': targetApp,
        if (accountConstraints.isNotEmpty)
          'accountConstraints':
              List<dynamic>.from(accountConstraints.map((x) => x.toJson())),
      };
}
