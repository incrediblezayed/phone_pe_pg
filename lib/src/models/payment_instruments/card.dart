// To parse this JSON data, do
//
//     final cardPaymentInstrument = cardPaymentInstrumentFromJson(jsonString);

import 'package:phone_pe_pg/src/models/payment_instruments/payment_instrument_model.dart';
import 'package:phone_pe_pg/src/models/payment_request_model.dart';

/// CardPaymentInstrument
class CardPaymentInstrument extends PaymentInstrument {
  /// CardPaymentInstrument
  /// This class is used to specify the card details for card payments
  /// This is a subclass of [PaymentInstrument]
  /// And is used in [PaymentRequest]
  CardPaymentInstrument({
    required this.authMode,
    required this.saveCard,
    required this.cardDetails,
    this.type = PaymentType.card,
  });

  /// PaymentType,
  /// this is optional field and is set to [PaymentType.card] by default
  final PaymentType type;

  /// AuthMode for the card payment
  final String authMode;

  /// SaveCard
  /// This is used to save the card for future payments
  /// set this to true to save the card
  final bool saveCard;

  ///
  final CardDetails cardDetails;

  @override
  Map<String, dynamic> toJson() => {
        'type': type.type,
        'authMode': authMode,
        'saveCard': saveCard,
        'cardDetails': cardDetails.toJson(),
      };
}

/// CardDetails
class CardDetails {
  /// CardDetails
  /// This class is used to specify the card details for card payments
  CardDetails({
    required this.encryptedCardNumber,
    required this.encryptionKeyId,
    required this.cardHolderName,
    required this.expiry,
    required this.encryptedCvv,
    required this.billingAddress,
  });

  /// EncryptedCardNumber
  /// This is the encrypted card number
  /// You have to encrypt the card number with RSA2048 encryption
  /// You can check further details on https://developer.phonepe.com/v1/reference/pay-api-1
  final String encryptedCardNumber;

  /// EncryptionKeyId
  /// This is the encryption key id
  /// Check further details on https://developer.phonepe.com/v1/reference/pay-api-1
  final int encryptionKeyId;

  /// CardHolderName
  final String cardHolderName;

  /// Expiry
  final Expiry expiry;

  /// EncryptedCvv
  /// This is the encrypted cvv
  /// You have to encrypt the cvv with RSA2048 encryption
  /// You can check further details on https://developer.phonepe.com/v1/reference/pay-api-1
  final String encryptedCvv;

  /// BillingAddress
  final BillingAddress billingAddress;

  /// Converts the [CardDetails] to a JSON object.
  Map<String, dynamic> toJson() => {
        'encryptedCardNumber': encryptedCardNumber,
        'encryptionKeyId': encryptionKeyId,
        'cardHolderName': cardHolderName,
        'expiry': expiry.toJson(),
        'encryptedCvv': encryptedCvv,
        'billingAddress': billingAddress.toJson(),
      };
}

/// BillingAddress
class BillingAddress {
  /// BillingAddress
  /// This class is used to specify the billing address for card payments
  /// This is used in [CardDetails]
  BillingAddress({
    required this.line1,
    required this.line2,
    required this.city,
    required this.state,
    required this.zip,
    required this.country,
  });

  /// Line1 of the address
  final String line1;

  /// Line2 of the address
  final String line2;

  /// City
  final String city;

  /// State
  final String state;

  /// Zip or Pincode
  final String zip;

  /// Country
  final String country;

  /// Converts the [BillingAddress] to a JSON object.
  Map<String, dynamic> toJson() => {
        'line1': line1,
        'line2': line2,
        'city': city,
        'state': state,
        'zip': zip,
        'country': country,
      };
}

/// Expiry
class Expiry {
  /// Expiry
  /// This class is used to specify the expiry details for card payments
  /// This is used in [CardDetails]
  Expiry({
    required this.month,
    required this.year,
  });

  /// Month
  final String month;

  /// Year
  final String year;

  /// Converts the [Expiry] to a JSON object.
  Map<String, dynamic> toJson() => {
        'month': month,
        'year': year,
      };
}
