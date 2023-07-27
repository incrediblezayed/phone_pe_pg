// To parse this JSON data, do
//
//     final tokenPaymentInstrument = tokenPaymentInstrumentFromJson(jsonString);

import 'package:phone_pe_pg/src/models/payment_instruments/index.dart';
import 'package:phone_pe_pg/src/models/payment_instruments/payment_instrument_model.dart';
import 'package:phone_pe_pg/src/models/payment_request_model.dart';

/// TokenPaymentInstrument
class TokenPaymentInstrument extends PaymentInstrument {
  /// TokenPaymentInstrument
  /// This class is used to specify the token details for token payments
  /// This is a subclass of [PaymentInstrument]
  /// And is used in [PaymentRequest]
  TokenPaymentInstrument({
    required this.authMode,
    required this.tokenDetails,
    this.type = PaymentType.token,
  });

  /// PaymentType,
  /// this is optional field and is set to [PaymentType.token] by default
  final PaymentType type;

  /// AuthMode for the token payment
  final String authMode;

  /// TokenDetails
  final TokenDetails tokenDetails;

  @override
  Map<String, dynamic> toJson() => {
        'type': type.type,
        'authMode': authMode,
        'tokenDetails': tokenDetails.toJson(),
      };
}

/// TokenDetails
class TokenDetails {
  /// TokenDetails
  /// This class is used to specify the token details for token payments
  /// This is used in [TokenPaymentInstrument]
  TokenDetails({
    required this.encryptedCvv,
    required this.cryptogram,
    required this.encryptedToken,
    required this.encryptionKeyId,
    required this.expiry,
    required this.panSuffix,
    required this.cardHolderName,
  });

  /// EncryptedCvv
  /// This is the encrypted cvv
  /// You have to encrypt the cvv with RSA2048 encryption
  /// you can check further details on htthttps://developer.phonepe.com/v1/reference/pay-api-1
  final String encryptedCvv;

  /// Cryptogram
  final String cryptogram;

  /// EncryptedToken
  final String encryptedToken;

  /// EncryptionKeyId
  final int encryptionKeyId;

  /// Expiry
  final Expiry expiry;

  /// PanSuffix
  final String panSuffix;

  /// CardHolderName
  final String cardHolderName;

  /// Converts the [TokenDetails] to a JSON object.
  Map<String, dynamic> toJson() => {
        'encryptedCvv': encryptedCvv,
        'cryptogram': cryptogram,
        'encryptedToken': encryptedToken,
        'encryptionKeyId': encryptionKeyId,
        'expiry': expiry.toJson(),
        'panSuffix': panSuffix,
        'cardHolderName': cardHolderName,
      };
}
