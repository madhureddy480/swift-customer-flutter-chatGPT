import 'package:dr_swift_diagnostics/features/authentication/presentation/providers/auth_state_provider.dart';
import 'package:dr_swift_diagnostics/features/session/domain/session_enums.dart';
import 'package:dr_swift_diagnostics/features/session/presentation/session_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Bridges legacy auth check to [userSessionProvider].
final isAuthenticatedProvider = Provider<bool>((ref) {
  final session = ref.watch(userSessionProvider);
  return session.auth == SessionAuth.authenticated;
});
