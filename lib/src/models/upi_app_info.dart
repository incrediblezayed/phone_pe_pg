// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

@immutable
class UpiAppInfo {
  final String appName;
  final String? packageName;
  final Uint8List appIcon;
  final String? iOSAppName;
  final String? iOSAppScheme;
  const UpiAppInfo({
    required this.appName,
    required this.appIcon,
    this.packageName,
    this.iOSAppName,
    this.iOSAppScheme,
  });

  UpiAppInfo copyWith({
    String? appName,
    String? packageName,
    Uint8List? appIcon,
    String? iOSAppName,
    String? iOSAppScheme,
  }) {
    return UpiAppInfo(
      appName: appName ?? this.appName,
      packageName: packageName ?? this.packageName,
      appIcon: appIcon ?? this.appIcon,
      iOSAppName: iOSAppName ?? this.iOSAppName,
      iOSAppScheme: iOSAppScheme ?? this.iOSAppScheme,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'appName': appName,
      if (packageName != null) 'packageName': packageName,
      'appIcon': appIcon,
      if (iOSAppName != null) 'iOSAppName': iOSAppName,
      if (iOSAppScheme != null) 'iOSAppScheme': iOSAppScheme,
    };
  }

  factory UpiAppInfo.fromMap(Map<String, dynamic> map) {
    return UpiAppInfo(
      appName: map['appName'] as String,
      packageName: map['packageName'] as String,
      appIcon: map['appIcon'],
      iOSAppName: map['iOSAppName'] as String?,
    );
  }

  String toJson() => json.encode(toMap());

  factory UpiAppInfo.fromJson(String source) =>
      UpiAppInfo.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'UpiAppInfo(appName: $appName, packageName: $packageName, appIcon: $appIcon iOSAppName: $iOSAppName, iOSAppScheme: $iOSAppScheme)';

  @override
  bool operator ==(covariant UpiAppInfo other) {
    if (identical(this, other)) return true;

    return other.appName == appName &&
        other.packageName == packageName &&
        other.appIcon == appIcon &&
        other.iOSAppName == iOSAppName &&
        other.iOSAppScheme == iOSAppScheme;
  }

  @override
  int get hashCode =>
      appName.hashCode ^
      packageName.hashCode ^
      appIcon.hashCode ^
      iOSAppName.hashCode ^
      iOSAppScheme.hashCode;
}
