import 'package:dr_swift_diagnostics/core/config/app_config.dart';
import 'package:dr_swift_diagnostics/core/theme/app_theme.dart';
import 'package:dr_swift_diagnostics/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DrSwiftApp extends ConsumerWidget {
  const DrSwiftApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final config = AppConfig.fromEnvironment();

    return MaterialApp.router(
      title: config.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.light,
      routerConfig: router,
    );
  }
}
