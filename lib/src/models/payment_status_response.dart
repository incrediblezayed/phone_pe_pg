// To parse this JSON data, do
//
//     final paymentStatusReponse = paymentStatusReponseFromJson(jsonString);

/// Payment Type from the status check api
enum ResponsePaymentType {
  /// If the payment was made using UPI
  upi(value: 'UPI'),

  /// If the payment was made using net banking
  netbanking(value: 'NETBANKING'),

  /// If the payment was made using card
  card(value: 'CARD');

  const ResponsePaymentType({required this.value});

  /// Value
  final String value;
}

/// PaymentStatus in [PaymentStatusReponse] returned from the check status api
enum PaymentStatus {
  /// PaymentSuccess
  success(code: 'PAYMENT_SUCCESS', description: 'Invalid request'),

  /// BadRequest
  badRequest(code: 'BAD_REQUEST', description: 'X-VERIFY header is incorrect'),

  /// AuthorizationFailed
  /// Occurs when the X-VERIFY header is incorrect
  authorizationFailed(
    code: 'AUTHORIZATION_FAILED',
    description:
        'Something went wrong. It does not indicate failed payment. The merchant needs to call Check Status API to verify the transaction status',
  ),

  /// InternalServerError
  internalServerError(
    code: 'INTERNAL_SERVER_ERROR',
    description: 'Payment is successful',
  ),

  /// TransactionNotFound
  transactionNotFound(
    code: 'TRANSACTION_NOT_FOUND',
    description: 'Payment failed',
  ),

  /// PaymentError
  paymentError(
    code: 'PAYMENT_ERROR',
    description: 'The transaction id is incorrect',
  ),

  /// PaymentPending
  paymentPending(
    code: 'PAYMENT_PENDING',
    description:
        'Payment is pending. It does not indicate success/failed payment. The merchant needs to call Check Status API to verify the transaction status.',
  ),

  /// PaymentDeclined
  paymentDeclined(
    code: 'PAYMENT_DECLINED',
    description: 'Payment declined by user',
  ),

  /// Payment Timedout
  timeout(
    code: 'TIMED_OUT',
    description: 'The payment failed due to the timeout.',
  );

  /// PaymentStatus
  const PaymentStatus({required this.code, required this.description});

  /// Status code
  final String code;

  /// Status description
  final String description;
}

/// PaymentStatusReponse
class PaymentStatusReponse {
  /// PaymentStatusReponse
  /// This class is used to parse the response from the check status api
  /// this is the response generated from check status api
  PaymentStatusReponse({
    this.success,
    this.code,
    this.message,
    this.data,
  });

  /// Parses the JSON response from the check status api
  factory PaymentStatusReponse.fromJson(Map<String, dynamic> json) =>
      PaymentStatusReponse(
        success: json['success'] as bool?,
        code: json['code'] == null
            ? null
            : PaymentStatus.values.firstWhere(
                (element) => element.code == json['code'],
                orElse: () => PaymentStatus.badRequest,
              ),
        message: json['message'] as String?,
        data: json['data'] == null
            ? null
            : Data.fromJson(json['data'] as Map<String, dynamic>),
      );

  /// Success
  final bool? success;

  /// Code
  final PaymentStatus? code;

  /// Message
  final String? message;

  /// Data
  final Data? data;
}

/// Data
class Data {
  /// Data
  /// This class is used to parse the response from the check status api
  Data({
    this.merchantId,
    this.merchantTransactionId,
    this.transactionId,
    this.amount,
    this.state,
    this.responseCode,
    this.responseCodeDescription,
    this.paymentInstrument,
  });

  /// Parses the JSON response from the check status api
  /// This is the response generated from check status api
  factory Data.fromJson(Map<String, dynamic> json) => Data(
        merchantId: json['merchantId'],
        merchantTransactionId: json['merchantTransactionId'],
        transactionId: json['transactionId'],
        amount: json['amount'],
        state: json['state'],
        responseCode: json['responseCode'],
        responseCodeDescription: json['responseCodeDescription'],
        paymentInstrument: json['paymentInstrument'] == null
            ? null
            : PaymentInstrument.fromJson(json['paymentInstrument']),
      );

  /// MerchantId
  final String? merchantId;

  /// MerchantTransactionId
  final String? merchantTransactionId;

  /// TransactionId
  final String? transactionId;

  /// Amount
  final int? amount;

  /// State of the transaction
  /// Can be COMPLETED or FAILED or PENDING
  final String? state;

  /// ResponseCode
  final String? responseCode;

  /// Description of the response code
  final String? responseCodeDescription;

  /// PaymentInstrument
  final PaymentInstrument? paymentInstrument;
}

/// PaymentInstrument
class PaymentInstrument {
  /// PaymentInstrument
  /// This class is used to parse the response from the check status api
  /// This is the response generated from check status api
  PaymentInstrument({
    this.type,
    this.utr,
    this.cardType,
    this.pgTransactionId,
    this.bankTransactionId,
    this.pgAuthorizationCode,
    this.arn,
    this.bankId,
    this.brn,
    this.pgServiceTransactionId,
  });

  /// Parses the JSON response from the check status api
  factory PaymentInstrument.fromJson(Map<String, dynamic> json) =>
      PaymentInstrument(
        type: json['type'] == null
            ? null
            : ResponsePaymentType.values.firstWhere(
                (element) => element.value == json['type'],
                orElse: () => ResponsePaymentType.upi,
              ),
        utr: json['utr'],
        cardType: json['cardType'],
        pgTransactionId: json['pgTransactionId'],
        bankTransactionId: json['bankTransactionId'],
        pgAuthorizationCode: json['pgAuthorizationCode'],
        arn: json['arn'],
        bankId: json['bankId'],
        brn: json['brn'],
        pgServiceTransactionId: json['pgServiceTransactionId'],
      );

  /// Type
  /// This is the type of the payment instrument
  final ResponsePaymentType? type;

  /// Utr
  /// This is only available for UPI Payments
  final String? utr;

  /// CardType
  /// This is only available for card payments
  final String? cardType;

  /// PgTransactionId
  /// This is the pg transaction id
  /// This is only available for net banking payments and card payments
  final String? pgTransactionId;

  /// BankTransactionId
  /// This is the bank transaction id
  /// This is only available for net banking payments and card payments
  final String? bankTransactionId;

  /// PgAuthorizationCode
  /// This is the pg authorization code
  /// This is only available for card payments
  final String? pgAuthorizationCode;

  /// Arn
  /// This is the arn
  /// This is only available for card payments
  final String? arn;

  /// BankId
  /// This is the bank id
  /// This is only available for net banking payments and card payments
  final String? bankId;

  /// Brn
  /// This is the brn
  /// This is only available for card payments
  final String? brn;

  /// PgServiceTransactionId
  /// This is the pg service transaction id
  /// This is only available for net banking payments
  final String? pgServiceTransactionId;
}
