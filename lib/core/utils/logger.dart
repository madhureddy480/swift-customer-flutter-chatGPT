import 'package:flutter/foundation.dart';

void appLog(String message, {Object? error, StackTrace? stackTrace}) {
  if (kDebugMode) {
    debugPrint('[DrSwift] $message');
    if (error != null) {
      debugPrint('[DrSwift] $error');
    }
    if (stackTrace != null) {
      debugPrint(stackTrace.toString());
    }
  }
}
