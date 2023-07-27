import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:phone_pe_pg/src/models/upi_app_info.dart';
import 'package:phone_pe_pg/src/platform_handler/phone_pe_pg_platform_interface.dart';

/// An implementation of [PhonePePgPlatform] that uses method channels.
class MethodChannelPhonePePg extends PhonePePgPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('phone_pe_pg');

  final String _getUpiApps = 'getUpiApps';
  final String _startTransaction = 'startTransaction';

  @override
  Future<List<UpiAppInfo>?> getUpiApps({
    required List<UpiAppInfo> iOSUpiApps,
  }) async {
    final apps = await methodChannel.invokeListMethod<dynamic>(_getUpiApps, {
      'iOSUpiApps': iOSUpiApps.map((e) => e.iOSAppScheme).toList(),
    });
    if (apps == null) return null;
    if (Platform.isIOS) {
      return iOSUpiApps
          .where((element) => apps.contains(element.packageName))
          .toList();
    } else {
      return apps.map((dynamic app) {
        final appMap = app as Map<dynamic, dynamic>;
        return UpiAppInfo.fromMap(appMap.cast<String, dynamic>());
      }).toList();
    }
  }

  @override
  Future<String?> startTransaction({
    required String uri,
    required String package,
  }) {
    return methodChannel.invokeMethod<String>(_startTransaction, {
      'upi_uri': uri,
      'package': package,
    });
  }
}
