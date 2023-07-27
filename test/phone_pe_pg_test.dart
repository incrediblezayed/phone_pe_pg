import 'package:flutter_test/flutter_test.dart';
import 'package:phone_pe_pg/phone_pe_pg.dart';
import 'package:phone_pe_pg/src/platform_handler/phone_pe_pg_method_channel.dart';
import 'package:phone_pe_pg/src/platform_handler/phone_pe_pg_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockPhonePePgPlatform
    with MockPlatformInterfaceMixin
    implements PhonePePgPlatform {
  @override
  Future<List<UpiAppInfo>?> getUpiApps({required List<UpiAppInfo> iOSUpiApps}) {
    throw UnimplementedError();
  }

  @override
  Future<String?> startTransaction({
    required String uri,
    required String package,
  }) {
    throw UnimplementedError();
  }
}

void main() {
  final initialPlatform = PhonePePgPlatform.instance;

  test('$MethodChannelPhonePePg is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelPhonePePg>());
  });
}
