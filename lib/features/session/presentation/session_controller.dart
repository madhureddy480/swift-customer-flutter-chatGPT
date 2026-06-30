import 'package:dr_swift_diagnostics/features/session/data/guest_sample_family.dart';
import 'package:dr_swift_diagnostics/features/session/domain/family_member_session.dart';
import 'package:dr_swift_diagnostics/features/session/domain/session_enums.dart';
import 'package:dr_swift_diagnostics/features/session/domain/user_session_context.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userSessionControllerProvider =
    StateNotifierProvider<UserSessionController, UserSessionContext>((ref) {
  return UserSessionController();
});

/// Back-compat read surface used across tab screens.
final userSessionProvider = Provider<UserSessionContext>((ref) {
  return ref.watch(userSessionControllerProvider);
});

class UserSessionController extends StateNotifier<UserSessionContext> {
  UserSessionController() : super(guestUserSession);

  void setGuest() {
    state = guestUserSession;
  }

  void setAuthenticated({
    required String phoneE164,
    required String displayName,
  }) {
    state = UserSessionContext(
      auth: SessionAuth.authenticated,
      family: FamilyState.none,
      accountPhoneVerified: true,
      members: [
        FamilyMemberSession(
          id: 'auth-me',
          displayName: displayName,
          labData: MemberLabDataState.none,
          isAccountHolder: true,
        ),
      ],
    );
  }
}
