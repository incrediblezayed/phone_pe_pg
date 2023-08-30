import 'dart:convert';
import 'dart:io';

import 'package:phone_pe_pg/src/models/payment_instruments/payment_instrument_model.dart';

/// PaymentType
/// This enum is used to specify the payment type
/// This is used in [PaymentInstrument]
enum PaymentType {
  /// UpiIntent
  upiIntent('UPI_INTENT'),

  /// UpiCollect
  upiCollect('UPI_COLLECT'),

  /// UpiQr
  upiQr('UPI_QR'),

  /// Standard Checkout
  payPage('PAY_PAGE'),

  /// Card
  card('CARD'),

  /// SavedCard
  savedCard('SAVED_CARD'),

  /// Token
  token('TOKEN'),

  /// NetBanking
  netBanking('NET_BANKING');

  /// PaymentType
  const PaymentType(this.type);

  /// PaymentType
  final String type;
}

/// PaymentRequestModel
class PaymentRequest {
  /// PaymentRequestModel
  /// This class is used to specify the payment request details
  /// This sent to the Payment API for initiating the payment
  PaymentRequest({
    this.merchantId,
    this.merchantTransactionId,
    this.merchantUserId,
    this.amount,
    this.redirectUrl,
    this.redirectMode,
    this.callbackUrl,
    this.mobileNumber,
    this.deviceContext,
    this.paymentInstrument,
  });

  /// MerchantId
  final String? merchantId;

  /// MerchantTransactionId
  /// This is the unique transaction id for the merchant
  /// This is a mandatory field
  /// and should be unique for every transaction
  /// This is used to identify the transaction
  /// And will be used for checking the status,
  /// it is generated on the client side and sent to phonepe
  /// This can be your order id or any other unique id
  final String? merchantTransactionId;

  /// MerchantUserId
  /// This is the unique user id for the merchant
  /// This is a mandatory field
  /// and should be unique for every user
  /// This is used to identify the user
  ///This is also generated on the client side and sent to phonepe
  final String? merchantUserId;

  /// Amount
  final double? amount;

  /// RedirectUrl
  /// This is the url to which the user will be redirected after the payment
  final String? redirectUrl;

  /// RedirectMode
  /// This is the mode in which the user will be redirected after the payment
  /// Such as: POST, GET, PUT
  final String? redirectMode;

  /// CallbackUrl
  /// This is the url to which the payment status will be sent
  /// This is a mandatory field
  final String? callbackUrl;

  /// MobileNumber
  /// This is the mobile number of the user
  final String? mobileNumber;

  /// DeviceContext
  /// This is the device context of the user
  /// this is only applicable for upi intent payments
  final DeviceContext? deviceContext;

  /// PaymentInstrument
  /// This is the payment instrument for the payment
  /// This is a mandatory field
  /// this identifies the type of payment and other details regarding the same
  final PaymentInstrument? paymentInstrument;

  /// Creates a copy of [PaymentRequest] with specified attributes overridden.
  PaymentRequest copyWith({
    String? merchantId,
    String? merchantTransactionId,
    String? merchantUserId,
    double? amount,
    String? callbackUrl,
    String? redirectUrl,
    String? redirectMode,
    String? mobileNumber,
    DeviceContext? deviceContext,
    PaymentInstrument? paymentInstrument,
  }) =>
      PaymentRequest(
        merchantId: merchantId ?? this.merchantId,
        merchantTransactionId:
            merchantTransactionId ?? this.merchantTransactionId,
        merchantUserId: merchantUserId ?? this.merchantUserId,
        amount: amount ?? this.amount,
        redirectUrl: redirectUrl ?? this.redirectUrl,
        redirectMode: redirectMode ?? this.redirectMode,
        callbackUrl: callbackUrl ?? this.callbackUrl,
        mobileNumber: mobileNumber ?? this.mobileNumber,
        deviceContext: deviceContext ?? this.deviceContext,
        paymentInstrument: paymentInstrument ?? this.paymentInstrument,
      );

  /// Converts the [PaymentRequest] to a JSON object.
  Map<String, dynamic> toJson() => {
        'merchantId': merchantId,
        'merchantTransactionId': merchantTransactionId,
        'merchantUserId': merchantUserId,
        'amount': ((amount ?? 0) * 100).toInt(),
        if (redirectUrl != null) 'redirectUrl': redirectUrl,
        if (redirectMode != null) 'redirectMode': redirectMode,
        'callbackUrl': callbackUrl,
        'mobileNumber': mobileNumber,
        if (deviceContext != null) 'deviceContext': deviceContext?.toJson(),
        'paymentInstrument': paymentInstrument?.toJson(),
      };

  /// Converts the [PaymentRequest] to a raw JSON object.
  String toRawJson() => jsonEncode(toJson());
}

/// DeviceContext
class DeviceContext {
  /// DeviceContext
  /// This class is used to specify the device context for the payment
  /// This is used in [PaymentRequest]
  /// This is only applicable for upi intent payments
  DeviceContext({
    this.deviceOs,
    this.merchantCallBackScheme,
  });

  ///Use this method to get the default device context
  ///It will return Android for android devices and iOS for iOS devices
  ///[merchantCallBackScheme] is required in case of iOS
  ///[merchantCallBackScheme] is the url scheme of your app
  factory DeviceContext.getDefaultDeviceContext({
    String? merchantCallBackScheme,
  }) =>
      DeviceContext(
        deviceOs: Platform.isAndroid ? 'ANDROID' : 'IOS',
        merchantCallBackScheme: merchantCallBackScheme,
      );

  /// DeviceOs
  final String? deviceOs;

  /// MerchantCallBackScheme
  final String? merchantCallBackScheme;

  /// Creates a copy of [DeviceContext] with specified attributes overridden.
  DeviceContext copyWith({
    String? deviceOs,
    String? merchantCallBackScheme,
  }) =>
      DeviceContext(
        deviceOs: deviceOs ?? this.deviceOs,
        merchantCallBackScheme:
            merchantCallBackScheme ?? this.merchantCallBackScheme,
      );

  /// Converts the [DeviceContext] to a JSON object.
  Map<String, dynamic> toJson() => {
        'deviceOS': deviceOs,
        if (merchantCallBackScheme != null)
          'merchantCallBackScheme': merchantCallBackScheme,
      };
}
