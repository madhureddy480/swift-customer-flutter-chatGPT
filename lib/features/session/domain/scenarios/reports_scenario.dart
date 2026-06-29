import 'package:dr_swift_diagnostics/features/session/domain/session_enums.dart';
import 'package:dr_swift_diagnostics/features/session/domain/user_session_context.dart';

enum ReportsScenario {
  guestFamilySample,
  empty,
  mixed,
  resultsSelf,
  resultsFamily,
}

ReportsScenario resolveReportsScenario(UserSessionContext session) {
  if (session.isGuest) return ReportsScenario.guestFamilySample;

  if (!session.hasFamily) {
    final self = session.accountHolder;
    if (self == null || self.labData == MemberLabDataState.none) {
      return ReportsScenario.empty;
    }
    if (self.labData == MemberLabDataState.pending) {
      return ReportsScenario.mixed;
    }
    return ReportsScenario.resultsSelf;
  }

  if (session.allMembersEmpty) return ReportsScenario.empty;
  if (session.anyMemberPending || session.hasMixedMemberStates) {
    return ReportsScenario.mixed;
  }
  return ReportsScenario.resultsFamily;
}
