import 'package:dr_swift_diagnostics/features/session/domain/family_member_session.dart';
import 'package:dr_swift_diagnostics/features/session/domain/scenarios/health_scenario.dart';
import 'package:dr_swift_diagnostics/features/session/domain/session_enums.dart';
import 'package:dr_swift_diagnostics/features/session/domain/user_session_context.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('resolveHealthScenario', () {
    test('guest always returns guestFamilySample', () {
      const session = UserSessionContext(
        auth: SessionAuth.guest,
        family: FamilyState.members,
        accountPhoneVerified: false,
        members: [],
      );
      expect(resolveHealthScenario(session), HealthScenario.guestFamilySample);
    });

    test('authenticated self with no data returns empty', () {
      const session = UserSessionContext(
        auth: SessionAuth.authenticated,
        family: FamilyState.none,
        accountPhoneVerified: true,
        members: [
          FamilyMemberSession(
            id: 'me',
            displayName: 'Me',
            labData: MemberLabDataState.none,
            isAccountHolder: true,
          ),
        ],
      );
      expect(resolveHealthScenario(session), HealthScenario.empty);
    });

    test('authenticated family with mixed member states returns mixed', () {
      const session = UserSessionContext(
        auth: SessionAuth.authenticated,
        family: FamilyState.members,
        accountPhoneVerified: true,
        members: [
          FamilyMemberSession(
            id: 'me',
            displayName: 'Me',
            labData: MemberLabDataState.available,
            isAccountHolder: true,
          ),
          FamilyMemberSession(
            id: 'mom',
            displayName: 'Mom',
            labData: MemberLabDataState.pending,
          ),
        ],
      );
      expect(resolveHealthScenario(session), HealthScenario.mixed);
    });
  });
}
