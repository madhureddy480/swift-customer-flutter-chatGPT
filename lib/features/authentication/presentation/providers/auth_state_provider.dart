import 'package:dr_swift_diagnostics/features/session/presentation/session_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Bridges legacy auth check to [userSessionProvider].
final isAuthenticatedProvider = Provider<bool>((ref) {
  final session = ref.watch(userSessionProvider);
  return session.isAuthenticated;
});

final canCheckoutProvider = Provider<bool>((ref) {
  final session = ref.watch(userSessionProvider);
  return session.canCheckout;
});
