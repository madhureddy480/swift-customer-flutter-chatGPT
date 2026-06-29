import 'package:dr_swift_diagnostics/features/session/domain/family_member_session.dart';
import 'package:dr_swift_diagnostics/features/session/domain/session_enums.dart';

/// Resolved account session — drives all tab variant routing.
class UserSessionContext {
  const UserSessionContext({
    required this.auth,
    required this.family,
    required this.accountPhoneVerified,
    required this.members,
  });

  final SessionAuth auth;
  final FamilyState family;
  final bool accountPhoneVerified;
  final List<FamilyMemberSession> members;

  bool get isGuest => auth == SessionAuth.guest;
  bool get isAuthenticated => auth == SessionAuth.authenticated;
  bool get canCheckout => isAuthenticated && accountPhoneVerified;
  bool get hasFamily => family == FamilyState.members;

  FamilyMemberSession? get accountHolder {
    for (final member in members) {
      if (member.isAccountHolder) return member;
    }
    return members.isNotEmpty ? members.first : null;
  }

  bool get anyMemberPending =>
      members.any((m) => m.labData == MemberLabDataState.pending);

  bool get anyMemberHasResults =>
      members.any((m) => m.labData == MemberLabDataState.available);

  bool get allMembersEmpty =>
      members.isNotEmpty &&
      members.every((m) => m.labData == MemberLabDataState.none);

  bool get hasMixedMemberStates {
    if (members.length < 2) return false;
    final states = members.map((m) => m.labData).toSet();
    return states.length > 1;
  }
}
