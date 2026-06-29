import 'package:dr_swift_diagnostics/features/session/domain/family_member_session.dart';
import 'package:dr_swift_diagnostics/features/session/domain/session_enums.dart';
import 'package:dr_swift_diagnostics/features/session/domain/user_session_context.dart';

/// Marketing sample family for guest Health / Reports tabs (multi-user).
const guestSampleFamilyMembers = [
  FamilyMemberSession(
    id: 'guest-me',
    displayName: 'My Health',
    labData: MemberLabDataState.available,
    isAccountHolder: true,
  ),
  FamilyMemberSession(
    id: 'guest-mom',
    displayName: 'Mom',
    labData: MemberLabDataState.available,
  ),
  FamilyMemberSession(
    id: 'guest-dad',
    displayName: 'Dad',
    labData: MemberLabDataState.available,
  ),
];

/// Default session until auth + APIs are wired — guest with whole-family sample.
const guestUserSession = UserSessionContext(
  auth: SessionAuth.guest,
  family: FamilyState.members,
  accountPhoneVerified: false,
  members: guestSampleFamilyMembers,
);
