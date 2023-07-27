import 'package:flutter/foundation.dart';

/// AccountConstraint
/// This class is used to specify the accounts for upi payments
/// This is used in other payment instruments like UPI Intent
@immutable
class AccountConstraint {
  /// AccountConstraint
  /// This class is used to specify the accounts for upi payments
  /// This is used in other payment instruments like UPI Intent
  const AccountConstraint({
    required this.accountNumber,
    required this.ifsc,
  });

  /// AccountNumber
  final String accountNumber;

  /// ifsc
  final String ifsc;

  /// Converts the [AccountConstraint] to a JSON object.
  Map<String, dynamic> toJson() => {
        'accountNumber': accountNumber,
        'ifsc': ifsc,
      };
}
