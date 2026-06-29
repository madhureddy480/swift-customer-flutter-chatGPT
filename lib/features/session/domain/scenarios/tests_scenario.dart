import 'package:dr_swift_diagnostics/features/session/domain/user_session_context.dart';

enum TestsScenario {
  guestBrowse,
  authenticatedBrowse,
}

TestsScenario resolveTestsScenario(UserSessionContext session) {
  if (session.isGuest) return TestsScenario.guestBrowse;
  return TestsScenario.authenticatedBrowse;
}
