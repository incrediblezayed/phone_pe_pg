///PaymentInstrumentModel
///
///[PaymentInstrument] is the base class for all payment instruments.
///this is an abstract class and cannot be instantiated.
///[PaymentInstrument] is required in the payment request to initiate the payment.
abstract class PaymentInstrument {
  ///Default constructor for [PaymentInstrument]
  PaymentInstrument();

  ///Converts the [PaymentInstrument] to a JSON object.
  Map<String, dynamic> toJson();
}
