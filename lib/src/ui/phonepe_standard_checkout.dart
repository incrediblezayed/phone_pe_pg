import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:phone_pe_pg/phone_pe_pg.dart';
import 'package:phone_pe_pg/src/providers/payment_provider.dart';
import 'package:provider/provider.dart';

/// PhonePeStandardCheckout
class PhonePeStandardCheckout extends StatelessWidget {
  /// PhonePeStandardCheckout
  /// The [PaymentInstrument] should be [PayPagePaymentInstrument]
  /// This will generate the url and load it in the webview
  /// [paymentRequest] is the payment request model
  /// [salt] is the salt key provided by the phonepe
  /// [saltIndex] is the salt index provided by the phonepe
  /// [onPaymentComplete] is the callback function which is called when the payment is completed
  /// [isUAT] is used to specify whether the payment is to be made in UAT or PROD
  /// [appBar] is the appbar for the screen
  ///
  const PhonePeStandardCheckout({
    required this.paymentRequest,
    required this.salt,
    required this.saltIndex,
    required this.onPaymentComplete,
    super.key,
    this.isUAT = false,
    this.appBar,
    this.prodUrl,
    this.onStatusCheck,
  }) : assert(
          onStatusCheck != null || (salt != null && saltIndex != null),
          'salt and saltIndex must be provided if onStatusCheck is not provided',
        );

  /// Appbar for the screen
  final PreferredSizeWidget? appBar;

  /// paymentRequest
  final PaymentRequest paymentRequest;

  /// Salt Key provided by the phonepe
  final String? salt;

  /// Salt Index provided by the phonepe
  final String? saltIndex;

  /// Is UAT
  /// This is used to specify whether the payment is to be made in UAT or PROD
  final bool isUAT;

  /// ProdURl
  /// The endpoint of your backend which calls the pay api
  final String? prodUrl;

  final Future<PaymentStatusReponse> Function(String merchantTransactionID)?
      onStatusCheck;

  /// Callback function which is called when the payment is completed
  final void Function(
    PaymentStatusReponse? paymentResponse,
    dynamic paymentError,
  ) onPaymentComplete;

  @override
  Widget build(BuildContext context) {
    var canGoBack = false;
    final inAppWebViewKey = GlobalKey();
    InAppWebViewController? inAppWebViewController;
    return ChangeNotifierProvider(
      create: (_) => PaymentProvider()
        ..init(
          paymentRequest: paymentRequest,
          salt: salt,
          saltIndex: saltIndex,
          isUAT: isUAT,
          prodUrl: prodUrl,
        ),
      builder: (context, child) {
        return PopScope(
          canPop: canGoBack,
          onPopInvoked: (invoked) async {
            if (canGoBack) {
              if (inAppWebViewController == null) {
              } else {
                await inAppWebViewController!.loadUrl(
                  urlRequest:
                      URLRequest(url: WebUri(paymentRequest.redirectUrl!)),
                );
              }
            } else {
              canGoBack = true;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Press back again to cancel payment'),
                ),
              );
            }
          },
          child: Consumer<PaymentProvider>(
            builder: (context, value, child) {
              var isError = false;
              var urlString = '';
              if (!value.loading) {
                if (value.paymentResponseModel == null) {
                  isError = true;
                } else {
                  urlString = value.paymentResponseModel!.data!
                      .instrumentResponse!.redirectInfo!.url!;
                }
              }
              return Scaffold(
                appBar: appBar ??
                    AppBar(
                      title: const Text('Payment'),
                      backgroundColor: const Color(0xff673ab7),
                    ),
                body: value.loading
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              color: Color(0xff673ab7),
                            ),
                            Text('Initiating Payment'),
                          ],
                        ),
                      )
                    : isError
                        ? const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.error),
                                Text(
                                  'Something went wrong while initiating payment',
                                ),
                              ],
                            ),
                          )
                        : InAppWebView(
                            key: inAppWebViewKey,
                            initialUrlRequest: URLRequest(
                              url: WebUri(urlString),
                            ),
                            onWebViewCreated: (controller) {
                              inAppWebViewController = controller;
                            },
                            onLoadStart: (controller, url) {
                              final currentUrl = url!.toString().contains('www')
                                  ? url.toString().replaceAll('www.', '')
                                  : url.toString();

                              final redirectUrl =
                                  paymentRequest.redirectUrl!.contains('www')
                                      ? paymentRequest.redirectUrl!
                                          .replaceAll('www.', '')
                                      : paymentRequest.redirectUrl;

                              if (redirectUrl == currentUrl) {
                                controller.stopLoading();
                                if (onStatusCheck != null) {
                                  onStatusCheck!(
                                    paymentRequest.merchantTransactionId!,
                                  ).then((value) {
                                    onPaymentComplete(value, null);
                                  }).catchError((e) {
                                    onPaymentComplete(null, e);
                                  });
                                } else {
                                  value
                                      .checkPaymentStatus(
                                    salt: salt!,
                                    saltIndex: saltIndex!,
                                  )
                                      .then((value) {
                                    onPaymentComplete(value, null);
                                  }).catchError((e) {
                                    onPaymentComplete(null, e);
                                  });
                                }
                              }
                            },
                          ),
              );
            },
          ),
        );
      },
    );
  }
}
