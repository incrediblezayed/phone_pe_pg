// To parse this JSON data, do
//
//     final upiTransactionResponse = upiTransactionResponseFromJson(jsonString);

import 'dart:convert';

/// UpiPaymentStatus,
/// this enum is used to determine the status of the transaction
/// [success] - when the transaction is successful
/// [failure] - when the transaction is failed
/// [pending] - when the transaction is pending
enum UpiPaymentStatus {
  /// when the transaction is successful
  success(status: 'SUCCESS'),

  /// when the transaction is failed
  failure(status: 'FAILED'),

  /// when the transaction is pending
  pending(status: 'PENDING');

  /// constructor for the enum
  const UpiPaymentStatus({required this.status});

  /// the status of the transaction
  final String status;
}

/// UpiTransactionResponse
class UpiTransactionResponse {
  /// UpiTransactionResponse
  /// This class is used to parse the response from the upi transaction
  /// this is the response generated from upi transaction
  UpiTransactionResponse({
    required this.status,
    required this.isExternalMerchant,
    required this.txnRef,
    required this.bleTxId,
    required this.txnId,
    required this.response,
    required this.responseCode,
  });

  /// Parses the JSON response from the upi transaction
  factory UpiTransactionResponse.fromJson(Map<String, dynamic> json) =>
      UpiTransactionResponse(
        status: UpiPaymentStatus.values.firstWhere(
          (element) => element.status
              .toLowerCase()
              .contains(json['Status'].toString().toLowerCase()),
          orElse: () => UpiPaymentStatus.pending,
        ),
        isExternalMerchant: json['isExternalMerchant'],
        txnRef: json['txnRef'],
        bleTxId: json['bleTxId'],
        txnId: json['txnId'],
        response: json['response'],
        responseCode: json['responseCode'],
      );

  /// Parses the raw JSON response from the upi transaction
  factory UpiTransactionResponse.fromRawJson(String str) =>
      UpiTransactionResponse.fromJson(json.decode(str));

  /// Status of the transaction
  final UpiPaymentStatus? status;

  /// isExternalMerchant
  final bool? isExternalMerchant;

  /// txnRef
  /// This is the transaction reference id
  final String? txnRef;

  /// bleTxId
  final String? bleTxId;

  /// txnId
  /// This is the transaction id
  final String? txnId;

  /// response
  /// This is the response from the transaction
  final String? response;

  /// responseCode
  /// This is the response code from the transaction
  final String? responseCode;
}
