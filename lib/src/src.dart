import 'package:flutter/material.dart';
import 'package:phone_pe_pg/phone_pe_pg.dart';
import 'package:phone_pe_pg/src/models/payment_response_model.dart';
import 'package:phone_pe_pg/src/platform_handler/phone_pe_pg_platform_interface.dart';
import 'package:phone_pe_pg/src/repository/payment_repository.dart';
import 'package:phone_pe_pg/src/ui/phonepe_standard_checkout.dart';

/// PhonePePg
class PhonePePg {
  /// PhonePePg
  /// [isUAT] is used to specify whether the payment is to be made in UAT or PROD
  /// [saltKey] is the salt key provided by the phonepe
  /// [saltIndex] is the salt index provided by the phonepe
  PhonePePg({
    required this.isUAT,
    required this.saltKey,
    required this.saltIndex,
    this.prodUrl,
  }) : assert(
          isUAT || (prodUrl != null && prodUrl.isNotEmpty),
          'Prod URL should not be null if isUAT is false',
        );

  /// isUAT
  /// This is used to specify whether the payment is to be made in UAT or PROD
  final bool isUAT;

  /// saltKey
  /// This is the salt key provided by the phonepe
  final String saltKey;

  /// saltIndex
  /// This is the salt index provided by the phonepe
  final String saltIndex;

  /// Prod URL
  /// This is the endpoint of the backend you deployed for calling the PhonePe pay api
  final String? prodUrl;

  /// Get UPI Apps
  /// This is used to get the list of UPI apps installed on the device
  /// [iOSUpiApps] is the list of UPI apps for iOS
  /// This is required only for iOS
  /// Pass the list of UPI apps for iOS so that it can be checked if it's installed or not
  static Future<List<UpiAppInfo>?> getUpiApps({
    List<UpiAppInfo> iOSUpiApps = const [],
  }) {
    return PhonePePgPlatform.instance.getUpiApps(iOSUpiApps: iOSUpiApps);
  }

  final PaymentRepository _paymentRepository = PaymentRepository();

  /// Pay
  /// This is used to make the payment
  /// [paymentRequest] is the payment request model
  /// [salt] is the salt key provided by the phonepe
  /// [saltIndex] is the salt index provided by the phonepe
  Future<PaymentResponseModel> pay({
    required PaymentRequest paymentRequest,
    required String salt,
    required String saltIndex,
  }) async {
    final response = await _paymentRepository.pay(
      paymentRequest: paymentRequest,
      salt: salt,
      saltIndex: saltIndex,
      isUAT: isUAT,
      prodUrl: prodUrl,
    );
    return response;
  }

  /// Start UPI Transaction
  /// This is used to start the UPI transaction
  /// [paymentRequest] is the payment request model
  /// This will generate the url and launch the UPI app
  Future<UpiTransactionResponse> startUpiTransaction({
    required PaymentRequest paymentRequest,
    String? intentUrl,
  }) async {
    late PaymentResponseModel response;
    if (intentUrl == null) {
      response = await pay(
        paymentRequest: paymentRequest,
        salt: saltKey,
        saltIndex: saltIndex,
      );
    }
    final transactionResponse =
        await PhonePePgPlatform.instance.startTransaction(
      uri: intentUrl ?? response.data!.instrumentResponse!.intentUrl!,
      package: (paymentRequest.paymentInstrument! as UpiIntentPaymentInstrument)
          .targetApp,
    );
    if (transactionResponse == null) {
      throw Exception('Transaction failed');
    } else {
      return UpiTransactionResponse.fromRawJson(transactionResponse);
    }
  }

  /// Check Status
  /// This is used to check the status of the payment
  Future<PaymentStatusReponse> checkStatus({
    required String merchantId,
    required String merchantTransactionId,
  }) async {
    final response = await _paymentRepository.checkStatus(
      merchantId: merchantId,
      merchantTransactionId: merchantTransactionId,
      salt: saltKey,
      saltIndex: saltIndex,
      isUAT: isUAT,
    );
    return response;
  }

  /// Start PayPage Transaction
  Widget startPayPageTransaction({
    required PaymentRequest paymentRequest,
    required Function(PaymentStatusReponse? paymentStatusReponse, dynamic error)
        onPaymentComplete,
    PreferredSizeWidget? appBar,
  }) {
    return PhonePeStandardCheckout(
      prodUrl: prodUrl,
      paymentRequest: paymentRequest,
      salt: saltKey,
      saltIndex: saltIndex,
      onPaymentComplete: onPaymentComplete,
      appBar: appBar,
      isUAT: isUAT,
    );
  }
}
