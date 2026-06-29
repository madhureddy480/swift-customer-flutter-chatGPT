import 'package:dr_swift_diagnostics/features/session/domain/session_enums.dart';

/// One family member's session slice (lab state + optional contact phone).
class FamilyMemberSession {
  const FamilyMemberSession({
    required this.id,
    required this.displayName,
    required this.labData,
    this.phoneNumber,
    this.isAccountHolder = false,
  });

  final String id;
  final String displayName;
  final MemberLabDataState labData;
  final String? phoneNumber;
  final bool isAccountHolder;

  FamilyMemberSession copyWith({
    String? id,
    String? displayName,
    MemberLabDataState? labData,
    String? phoneNumber,
    bool? isAccountHolder,
  }) {
    return FamilyMemberSession(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      labData: labData ?? this.labData,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isAccountHolder: isAccountHolder ?? this.isAccountHolder,
    );
  }
}
