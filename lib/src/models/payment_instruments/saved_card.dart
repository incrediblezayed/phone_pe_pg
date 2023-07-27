// To parse this JSON data, do
//
//     final savedCardPaymentInstrument = savedCardPaymentInstrumentFromJson(jsonString);

import 'package:phone_pe_pg/src/models/payment_instruments/payment_instrument_model.dart';
import 'package:phone_pe_pg/src/models/payment_request_model.dart';

/// SavedCardPaymentInstrument
class SavedCardPaymentInstrument extends PaymentInstrument {
  /// SavedCardPaymentInstrument
  /// This class is used to specify the saved card details for saved card payments
  /// This is a subclass of [PaymentInstrument]
  SavedCardPaymentInstrument({
    required this.authMode,
    required this.cardDetails,
    this.type = PaymentType.savedCard,
  });

  /// PaymentType,
  /// this is optional field and is set to [PaymentType.savedCard] by default
  final PaymentType type;

  /// AuthMode for the saved card payment
  final String authMode;

  /// CardDetails
  final SavedCardDetails cardDetails;

  @override
  Map<String, dynamic> toJson() => {
        'type': type.type,
        'authMode': authMode,
        'cardDetails': cardDetails.toJson(),
      };
}

/// SavedCardDetails
class SavedCardDetails {
  /// SavedCardDetails
  /// This class is used to specify the saved card details for saved card payments
  /// This is used in [SavedCardPaymentInstrument]
  SavedCardDetails({
    required this.cardId,
    required this.encryptedCvv,
    required this.encryptionKeyId,
  });

  /// CardId
  final String cardId;

  /// EncryptedCvv
  final String encryptedCvv;

  /// EncryptionKeyId
  final int encryptionKeyId;

  /// Converts the [SavedCardDetails] to a JSON object.
  Map<String, dynamic> toJson() => {
        'cardId': cardId,
        'encryptedCvv': encryptedCvv,
        'encryptionKeyId': encryptionKeyId,
      };
}
