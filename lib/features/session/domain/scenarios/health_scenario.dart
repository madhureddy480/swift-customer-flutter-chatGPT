import 'package:dr_swift_diagnostics/features/session/domain/session_enums.dart';
import 'package:dr_swift_diagnostics/features/session/domain/user_session_context.dart';

enum HealthScenario {
  guestFamilySample,
  empty,
  mixed,
  resultsSelf,
  resultsFamily,
}

HealthScenario resolveHealthScenario(UserSessionContext session) {
  if (session.isGuest) return HealthScenario.guestFamilySample;

  if (!session.hasFamily) {
    final self = session.accountHolder;
    if (self == null || self.labData == MemberLabDataState.none) {
      return HealthScenario.empty;
    }
    if (self.labData == MemberLabDataState.pending) {
      return HealthScenario.mixed;
    }
    return HealthScenario.resultsSelf;
  }

  if (session.allMembersEmpty) return HealthScenario.empty;
  if (session.anyMemberPending || session.hasMixedMemberStates) {
    return HealthScenario.mixed;
  }
  return HealthScenario.resultsFamily;
}
