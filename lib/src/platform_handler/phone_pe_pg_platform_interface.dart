import 'package:phone_pe_pg/src/models/upi_app_info.dart';
import 'package:phone_pe_pg/src/platform_handler/phone_pe_pg_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

/// The interface that implementations of phone_pe_pg must implement.
abstract class PhonePePgPlatform extends PlatformInterface {
  /// Constructs a PhonePePgPlatform.
  PhonePePgPlatform() : super(token: _token);

  static final Object _token = Object();

  static PhonePePgPlatform _instance = MethodChannelPhonePePg();

  /// The default instance of [PhonePePgPlatform] to use.
  ///
  /// Defaults to [MethodChannelPhonePePg].
  static PhonePePgPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [PhonePePgPlatform] when
  /// they register themselves.
  static set instance(PhonePePgPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Returns the list of UPI apps installed on the device.
  Future<List<UpiAppInfo>?> getUpiApps({
    required List<UpiAppInfo> iOSUpiApps,
  }) {
    throw UnimplementedError('getUpiApps() has not been implemented.');
  }

  /// Starts the transaction with the given [uri] and [package].
  Future<String?> startTransaction({
    required String uri,
    required String package,
  }) {
    throw UnimplementedError('startTransaction() has not been implemented.');
  }
}
