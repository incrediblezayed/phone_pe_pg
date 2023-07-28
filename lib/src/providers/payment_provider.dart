import 'package:flutter/foundation.dart';
import 'package:phone_pe_pg/phone_pe_pg.dart';
import 'package:phone_pe_pg/src/models/payment_response_model.dart';
import 'package:phone_pe_pg/src/repository/payment_repository.dart';

/// PaymentProvider
/// This class is used to make payments
class PaymentProvider extends ChangeNotifier {
  /// isUAT
  /// This is used to specify whether the payment is to be made in UAT or PROD
  late bool isUAT;

  /// PaymentResponseModel
  /// This is the response generated from pay api
  PaymentResponseModel? paymentResponseModel;

  bool _loading = false;

  /// Loading
  bool get loading => _loading;
  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  bool _error = false;

  /// Error
  bool get error => _error;
  set error(bool value) {
    _error = value;
    notifyListeners();
  }

  /// LoadingMessage
  /// This is used to specify the loading message
  String loadingMessage = 'Initializing Payment';

  final PaymentRepository _paymentRepository = PaymentRepository();

  /// Initializes the payment
  /// This method is used to initialize the payment
  /// And calls the pay api
  /// [paymentRequest] is the payment request model
  /// And the url from the response is used to start the transaction
  /// and loaded in the webview
  Future<void> init({
    required PaymentRequest paymentRequest,
    required String salt,
    required String saltIndex,
    required bool isUAT,
  }) async {
    this.isUAT = isUAT;
    loading = true;
    try {
      paymentResponseModel = await _paymentRepository.pay(
        paymentRequest: paymentRequest,
        salt: salt,
        saltIndex: saltIndex,
        isUAT: isUAT,
      );
    } catch (e) {
      _error = true;
    }
    loading = false;
  }

  /// Checks the payment status
  Future<PaymentStatusReponse?> checkPaymentStatus({
    required String salt,
    required String saltIndex,
  }) async {
    loadingMessage = 'Checking Payment Status';
    loading = true;
    try {
      final response = await _paymentRepository.checkStatus(
        merchantId: paymentResponseModel!.data!.merchantId!,
        merchantTransactionId:
            paymentResponseModel!.data!.merchantTransactionId!,
        salt: salt,
        saltIndex: saltIndex,
        isUAT: isUAT,
      );
      return response;
    } catch (e) {
      error = true;
      rethrow;
    }
  }
}
