import 'package:dr_swift_diagnostics/features/session/domain/user_session_context.dart';

enum AccountScenario {
  guest,
  authenticatedUnverified,
  authenticatedVerified,
}

AccountScenario resolveAccountScenario(UserSessionContext session) {
  if (session.isGuest) return AccountScenario.guest;
  if (!session.accountPhoneVerified) return AccountScenario.authenticatedUnverified;
  return AccountScenario.authenticatedVerified;
}
