// To parse this JSON data, do
//
//     final paymentResponseModel = paymentResponseModelFromJson(jsonString);

import 'package:phone_pe_pg/phone_pe_pg.dart';

/// PaymentResponseModel
class PaymentResponseModel {
  /// PaymentResponseModel
  /// This class is used to parse the response from the payment request
  /// this is the response generated from pay api
  PaymentResponseModel({
    this.success,
    this.code,
    this.message,
    this.data,
  });

  /// Parses the JSON response from the payment request
  factory PaymentResponseModel.fromJson(Map<String, dynamic> json) =>
      PaymentResponseModel(
        success: json['success'],
        code: json['code'],
        message: json['message'],
        data: json['data'] == null ? null : Data.fromJson(json['data']),
      );

  /// Success
  final bool? success;

  /// Code
  /// This is the response code from the payment request
  final String? code;

  /// Message
  final String? message;

  /// Data
  final Data? data;
}

/// Data
class Data {
  /// Data
  Data({
    this.merchantId,
    this.merchantTransactionId,
    this.instrumentResponse,
  });

  /// Parses the JSON response from the payment request
  factory Data.fromJson(Map<String, dynamic> json) => Data(
        merchantId: json['merchantId'],
        merchantTransactionId: json['merchantTransactionId'],
        instrumentResponse: json['instrumentResponse'] == null
            ? null
            : InstrumentResponse.fromJson(json['instrumentResponse']),
      );

  /// MerchantId
  final String? merchantId;

  /// MerchantTransactionId
  final String? merchantTransactionId;

  /// InstrumentResponse
  /// This will be null if the payment is not successful
  final InstrumentResponse? instrumentResponse;
}

/// InstrumentResponse
class InstrumentResponse {
  /// InstrumentResponse
  /// This class is used to parse the instrument response from the payment request
  InstrumentResponse({
    this.type,
    this.qrData,
    this.intentUrl,
    this.redirectInfo,
  });

  /// Parses the JSON response from the payment request
  factory InstrumentResponse.fromJson(Map<String, dynamic> json) =>
      InstrumentResponse(
        type: json['type'] == null
            ? null
            : PaymentType.values
                .firstWhere((element) => element.type == json['type']),
        qrData: json['qrData'],
        intentUrl: json['intentUrl'],
        redirectInfo: json['redirectInfo'] == null
            ? null
            : RedirectInfo.fromJson(json['redirectInfo']),
      );

  /// PaymentType
  /// This is the type of payment instrument used for the payment
  final PaymentType? type;

  /// QrData
  /// This is the qr data for the payment
  final String? qrData;

  /// IntentUrl
  /// This is the intent url for the upi intent payment
  final String? intentUrl;

  /// RedirectInfo
  /// This is the redirect info for the payment
  /// This will only be available for the payment type such as net banking and card
  final RedirectInfo? redirectInfo;
}

/// RedirectInfo
class RedirectInfo {
  /// RedirectInfo
  /// This class is used to parse the redirect info from the payment request
  RedirectInfo({
    this.url,
    this.method,
  });

  /// Parses the JSON response from the payment request
  factory RedirectInfo.fromJson(Map<String, dynamic> json) => RedirectInfo(
        url: json['url'],
        method: json['method'],
      );

  /// Url
  final String? url;

  /// Method
  /// This is the method for the redirect info
  /// This can be GET or POST
  final String? method;
}
