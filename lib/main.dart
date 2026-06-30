import 'package:dr_swift_diagnostics/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // UI is designed for a light canvas — keep system chrome aligned on dark OS.
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  // Firebase.initializeApp() will be added when google-services are configured.
  runApp(
    const ProviderScope(
      child: DrSwiftApp(),
    ),
  );
}
