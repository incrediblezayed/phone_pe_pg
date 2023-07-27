// To parse this JSON data, do
//
//     final netBankingPaymentInstrument = netBankingPaymentInstrumentFromJson(jsonString);

import 'package:phone_pe_pg/src/models/payment_instruments/account_constraints.dart';
import 'package:phone_pe_pg/src/models/payment_instruments/payment_instrument_model.dart';
import 'package:phone_pe_pg/src/models/payment_request_model.dart';

/// NetBankingPaymentInstrument
class NetBankingPaymentInstrument extends PaymentInstrument {
  ///NetBankingPaymentInstrument
  ///This class is used to specify the net banking details for net banking payments
  ///This is a subclass of [PaymentInstrument]
  ///And is used in [PaymentRequest]
  NetBankingPaymentInstrument({
    required this.bankId,
    this.type = PaymentType.netBanking,
    this.accountConstraints = const [],
  });

  /// PaymentType,
  /// this is optional field and is set to [PaymentType.netBanking] by default
  ///
  final PaymentType type;

  /// BankId
  final String bankId;

  /// AccountConstraints
  /// This is used to specify the accounts for net banking payments
  final List<AccountConstraint> accountConstraints;

  @override
  Map<String, dynamic> toJson() => {
        'type': type.type,
        'bankId': bankId,
        if (accountConstraints.isNotEmpty)
          'accountConstraints':
              List<dynamic>.from(accountConstraints.map((x) => x.toJson())),
      };
}
