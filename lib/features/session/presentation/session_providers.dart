import 'package:dr_swift_diagnostics/features/session/data/guest_sample_family.dart';
import 'package:dr_swift_diagnostics/features/session/domain/user_session_context.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Central session state — swap implementation when auth + APIs land.
final userSessionProvider = Provider<UserSessionContext>((ref) {
  return guestUserSession;
});
