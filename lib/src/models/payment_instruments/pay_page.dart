// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:phone_pe_pg/src/models/payment_instruments/payment_instrument_model.dart';
import 'package:phone_pe_pg/src/models/payment_request_model.dart';

@immutable
class PayPagePaymentInstrument extends PaymentInstrument {
  final PaymentType type;
  PayPagePaymentInstrument({
    this.type = PaymentType.payPage,
  });

  PayPagePaymentInstrument copyWith({
    PaymentType? type,
  }) {
    return PayPagePaymentInstrument(
      type: type ?? this.type,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'type': type.type,
    };
  }

  @override
  String toString() => 'PayPagePaymentInstrument(type: $type)';

  @override
  bool operator ==(covariant PayPagePaymentInstrument other) {
    if (identical(this, other)) return true;

    return other.type == type;
  }

  @override
  int get hashCode => type.hashCode;
}
