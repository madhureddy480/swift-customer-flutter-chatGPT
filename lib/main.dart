import 'package:dr_swift_diagnostics/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase.initializeApp() will be added when google-services are configured.
  runApp(
    const ProviderScope(
      child: DrSwiftApp(),
    ),
  );
}
