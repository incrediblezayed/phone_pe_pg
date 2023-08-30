import 'package:dio/dio.dart';
import 'package:phone_pe_pg/src/models/payment_request_model.dart';
import 'package:phone_pe_pg/src/models/payment_response_model.dart';
import 'package:phone_pe_pg/src/models/payment_status_response.dart';
import 'package:phone_pe_pg/src/utils/encoding_extensions.dart';

/// PaymentRepository
/// This is the repository class which is used to make the api calls
/// [pay] is used to make the payment
/// [checkStatus] is used to check the status of the payment
class PaymentRepository {
  final Dio _dio = Dio(
    BaseOptions(
      contentType: Headers.jsonContentType,
      headers: {
        Headers.acceptHeader: Headers.jsonContentType,
      },
    ),
  );

  final String _preProdUrl = 'https://api-preprod.phonepe.com/apis/pg-sandbox';

  final String _prodUrl = 'https://api.phonepe.com/apis/hermes';

  /// Pay
  /// This is used to make the payment
  /// [paymentRequest] is the payment request model
  /// [salt] is the salt key provided by the phonepe
  /// [saltIndex] is the salt index provided by the phonepe
  /// [isUAT] is used to specify whether the payment is to be made in UAT or PROD
  /// [prodUrl] is the endpoint of your backend which will call the pay page api
  Future<PaymentResponseModel> pay({
    required PaymentRequest paymentRequest,
    required String salt,
    required String saltIndex,
    required bool isUAT,
    String? prodUrl,
  }) async {
    try {
      Response response;
      dynamic input;
      const gateway = '/pg/v1/pay';
      Map<String, String>? headers;
      if (isUAT) {
        final payload = paymentRequest.toRawJson().toBase64;
        final forChecksum = '$payload$gateway$salt';
        final sha256Key = forChecksum.toSha256;
        final checksum = '$sha256Key###$saltIndex';
        headers = {
          'X-VERIFY': checksum,
        };
        input = {'request': payload};
      } else {
        input = paymentRequest.toJson();
      }
      final url = isUAT ? (_preProdUrl + gateway) : prodUrl!;
      response = await _dio.post(
        url,
        data: input,
        options: Options(
          headers: headers,
        ),
      );
      if (response.statusCode == 200 && response.data != null) {
        return PaymentResponseModel.fromJson(response.data);
      } else {
        throw Exception('${response.statusCode} ${response.statusMessage}');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// CheckStatus
  /// This is used to check the status of the payment
  /// [merchantId] is the merchant id provided by the phonepe
  /// [merchantTransactionId] is the merchant transaction id provided by the phonepe
  /// [salt] is the salt key provided by the phonepe
  /// [saltIndex] is the salt index provided by the phonepe
  /// [isUAT] is used to specify whether the payment is to be made in UAT or PROD
  Future<PaymentStatusReponse> checkStatus({
    required String merchantId,
    required String merchantTransactionId,
    required String salt,
    required String saltIndex,
    required bool isUAT,
  }) async {
    try {
      final gateway = '/pg/v1/status/$merchantId/$merchantTransactionId';
      final sha256 = '$gateway$salt'.toSha256;
      final xVerify = '$sha256###$saltIndex';
      final headers = {
        'X-VERIFY': xVerify,
        'X-MERCHANT-ID': merchantId,
      };
      final response = await _dio.get(
        (isUAT ? _preProdUrl : _prodUrl) + gateway,
        options: Options(
          headers: headers,
        ),
      );
      if (response.statusCode == 200 && response.data != null) {
        return PaymentStatusReponse.fromJson(response.data);
      } else {
        throw Exception('${response.statusCode} ${response.statusMessage}');
      }
    } catch (e) {
      rethrow;
    }
  }
}
