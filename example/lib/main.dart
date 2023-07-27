import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:phone_pe_pg/phone_pe_pg.dart';
import 'package:phone_pe_pg_example/keys.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  PhonePePg pePg = PhonePePg(
    isUAT: true,
    saltKey: Secrets.saltKey,
    saltIndex: Secrets.saltKey,
  );

  PaymentRequest _paymentRequest({String? merchantCallBackScheme}) {
    String generateRandomString(int len) {
      const chars =
          'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
      Random rnd = Random();
      var s = String.fromCharCodes(Iterable.generate(
          len, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
      return s;
    }

    PaymentRequest paymentRequest = PaymentRequest(
      amount: 100,
      callbackUrl: Secrets.callbackUrl,
      deviceContext: DeviceContext.getDefaultDeviceContext(
          merchantCallBackScheme: merchantCallBackScheme),
      merchantId: Secrets.merchantId,
      merchantTransactionId: generateRandomString(10).toUpperCase(),
      merchantUserId: generateRandomString(8).toUpperCase(),
      mobileNumber: Secrets.userMobileNumber,
    );
    return paymentRequest;
  }

  PaymentRequest upipaymentRequest(UpiAppInfo e,
          {String? merchantCallBackScheme}) =>
      _paymentRequest(merchantCallBackScheme: merchantCallBackScheme).copyWith(
          paymentInstrument: UpiIntentPaymentInstrument(
        targetApp: Platform.isAndroid ? e.packageName! : e.iOSAppName!,
      ));

  PaymentRequest paypageRequestModel({String? merchantCallBackScheme}) =>
      _paymentRequest(merchantCallBackScheme: merchantCallBackScheme).copyWith(
          redirectUrl: Secrets.redirectUrl,
          redirectMode: 'GET',
          paymentInstrument: PayPagePaymentInstrument());

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Plugin example app'),
          ),
          body: FutureBuilder<List<UpiAppInfo>?>(
            future: PhonePePg.getUpiApps(iOSUpiApps: [
              UpiAppInfo(
                appName: "PhonePe",
                packageName: "ppe",
                appIcon: Uint8List(0),
                iOSAppName: "PHONEPE",
                iOSAppScheme: 'ppe',
              ),
              UpiAppInfo(
                appName: "Google Pay",
                packageName: "gpay",
                appIcon: Uint8List(0),
                iOSAppName: "GPAY",
                iOSAppScheme: 'gpay',
              ),
              UpiAppInfo(
                appName: "Paytm",
                packageName: "paytmmp",
                appIcon: Uint8List(0),
                iOSAppName: "PAYTM",
                iOSAppScheme: 'paytmmp',
              ),
              UpiAppInfo(
                  appName: "PhonePe Simulator",
                  packageName: "ppemerchantsdkv1",
                  appIcon: Uint8List(0),
                  iOSAppScheme: 'ppemerchantsdkv1',
                  iOSAppName: "PHONEPE"),
              UpiAppInfo(
                appName: "PhonePe Simulator",
                packageName: "ppemerchantsdkv2",
                appIcon: Uint8List(0),
                iOSAppScheme: 'ppemerchantsdkv2',
                iOSAppName: "PHONEPE",
              ),
              UpiAppInfo(
                appName: "PhonePe Simulator",
                packageName: "ppemerchantsdkv3",
                iOSAppScheme: 'ppemerchantsdkv3',
                appIcon: Uint8List(0),
                iOSAppName: "PHONEPE",
              ),
            ]),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                return ListView(children: [
                  ...snapshot.data!
                      .map(
                        (e) => ListTile(
                          onTap: () async {
                            pePg
                                .startUpiTransaction(
                                    paymentRequest: upipaymentRequest(e))
                                .then((response) {
                              if (response.status == UpiPaymentStatus.success) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text("Transaction Successful")));
                              } else if (response.status ==
                                  UpiPaymentStatus.pending) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text("Transaction Pending")));
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text("Transaction Failed")));
                              }
                            }).catchError((e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("Transaction Failed")));
                            });
                          },
                          leading: Image.memory(
                            e.appIcon,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.error);
                            },
                          ),
                          title: Text(e.appName),
                          subtitle: Text(e.packageName ?? e.iOSAppName!),
                        ),
                      )
                      .toList(),
                  ListTile(
                    title: const Text("Card/Net Banking"),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => pePg.startPayPageTransaction(
                                    onPaymentComplete:
                                        (paymentResponse, paymentError) {
                                      Navigator.pop(context);
                                      if (paymentResponse != null &&
                                          paymentResponse.code ==
                                              PaymentStatus.success) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content: Text(
                                                    "Transaction Successful")));
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content: Text(
                                                    "Transaction Failed")));
                                      }
                                    },
                                    paymentRequest: paypageRequestModel(),
                                  )));
                    },
                  )
                ]);
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          )),
    );
  }
}
