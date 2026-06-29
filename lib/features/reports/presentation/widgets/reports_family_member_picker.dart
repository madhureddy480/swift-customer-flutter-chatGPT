import 'dart:ui';

import 'package:dr_swift_diagnostics/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

const _ink = Color(0xFF1A1C1E);
const _muted = Color(0xFF667085);

/// Top-right frosted-glass avatar that opens an iOS-style member menu.
class ReportsFamilyMemberPicker extends StatefulWidget {
  const ReportsFamilyMemberPicker({
    required this.members,
    required this.selectedMember,
    required this.onSelected,
    super.key,
  });

  final List<String> members;
  final String selectedMember;
  final ValueChanged<String> onSelected;

  @override
  State<ReportsFamilyMemberPicker> createState() =>
      _ReportsFamilyMemberPickerState();
}

class _ReportsFamilyMemberPickerState extends State<ReportsFamilyMemberPicker> {
  final _anchorKey = GlobalKey();

  Future<void> _openMenu() async {
    final box = _anchorKey.currentContext?.findRenderObject() as RenderBox?;
    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox?;
    if (box == null || overlay == null) return;

    final bottomRight =
        box.localToGlobal(box.size.bottomRight(Offset.zero), ancestor: overlay);

    final selected = await showGeneralDialog<String>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Close member menu',
      barrierColor: Colors.black.withValues(alpha: 0.06),
      transitionDuration: const Duration(milliseconds: 220),
      pageBuilder: (context, animation, secondaryAnimation) {
        const menuWidth = 196.0;
        final left = (bottomRight.dx - menuWidth).clamp(8.0, overlay.size.width - menuWidth - 8);
        final top = bottomRight.dy + 8;

        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );

        return Stack(
          children: [
            Positioned(
              left: left,
              top: top,
              width: menuWidth,
              child: FadeTransition(
                opacity: curved,
                child: ScaleTransition(
                  scale: Tween<double>(begin: 0.94, end: 1).animate(curved),
                  alignment: Alignment.topRight,
                  child: _GlassMemberMenu(
                    members: widget.members,
                    selectedMember: widget.selectedMember,
                    onSelected: (name) => Navigator.of(context).pop(name),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );

    if (selected != null && selected != widget.selectedMember) {
      widget.onSelected(selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    final accent = _memberAccent(widget.selectedMember);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        key: _anchorKey,
        onTap: _openMenu,
        customBorder: const CircleBorder(),
        child: _GlassCircle(
          size: 34,
          accent: accent,
          child: _memberAvatarContent(widget.selectedMember, size: 12),
        ),
      ),
    );
  }
}

class _GlassCircle extends StatelessWidget {
  const _GlassCircle({
    required this.size,
    required this.accent,
    required this.child,
  });

  final double size;
  final _MemberAccent accent;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: accent.ring.withValues(alpha: 0.18),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipOval(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withValues(alpha: 0.88),
                  accent.background.withValues(alpha: 0.62),
                ],
              ),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.92),
                width: 1.5,
              ),
            ),
            alignment: Alignment.center,
            child: child,
          ),
        ),
      ),
    );
  }
}

class _GlassMemberMenu extends StatelessWidget {
  const _GlassMemberMenu({
    required this.members,
    required this.selectedMember,
    required this.onSelected,
  });

  final List<String> members;
  final String selectedMember;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 28, sigmaY: 28),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: const Color(0xFFF5F6F8).withValues(alpha: 0.78),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.92),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 28,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var i = 0; i < members.length; i++) ...[
                _GlassMemberMenuItem(
                  name: members[i],
                  isSelected: members[i] == selectedMember,
                  onTap: () => onSelected(members[i]),
                ),
                if (i < members.length - 1)
                  Divider(
                    height: 1,
                    thickness: 0.6,
                    color: Colors.white.withValues(alpha: 0.55),
                    indent: 12,
                    endIndent: 12,
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _GlassMemberMenuItem extends StatelessWidget {
  const _GlassMemberMenuItem({
    required this.name,
    required this.isSelected,
    required this.onTap,
  });

  final String name;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final accent = _memberAccent(name);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            color: isSelected
                ? Colors.white.withValues(alpha: 0.42)
                : Colors.transparent,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                _GlassCircle(
                  size: 30,
                  accent: accent,
                  child: _memberAvatarContent(name, size: 10),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isSelected ? _ink : _muted,
                      fontSize: 13,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                      letterSpacing: -0.1,
                    ),
                  ),
                ),
                if (isSelected)
                  Icon(
                    Icons.check_circle_rounded,
                    size: 18,
                    color: AppColors.primaryVibrant.withValues(alpha: 0.9),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MemberAccent {
  const _MemberAccent({
    required this.background,
    required this.foreground,
    required this.ring,
  });

  final Color background;
  final Color foreground;
  final Color ring;
}

_MemberAccent _memberAccent(String name) => switch (name) {
      'My Health' => const _MemberAccent(
          background: Color(0xFFF0EBFA),
          foreground: AppColors.primaryVibrant,
          ring: AppColors.primaryVibrant,
        ),
      'Mom' => const _MemberAccent(
          background: Color(0xFFFDECF4),
          foreground: Color(0xFFC2185B),
          ring: Color(0xFFE91E8C),
        ),
      'Dad' => const _MemberAccent(
          background: Color(0xFFE8F2FC),
          foreground: Color(0xFF1565C0),
          ring: Color(0xFF42A5F5),
        ),
      _ => const _MemberAccent(
          background: Color(0xFFF3F0F8),
          foreground: AppColors.primary,
          ring: AppColors.primary,
        ),
    };

String _memberInitial(String name) => switch (name) {
      'Mom' => 'M',
      'Dad' => 'D',
      _ => name.isNotEmpty ? name[0].toUpperCase() : '?',
    };

Widget _memberAvatarContent(String name, {required double size}) {
  final accent = _memberAccent(name);
  if (name == 'My Health') {
    return Icon(
      Icons.person_rounded,
      size: size + 4,
      color: accent.foreground,
    );
  }
  return Text(
    _memberInitial(name),
    style: TextStyle(
      color: accent.foreground,
      fontSize: size,
      fontWeight: FontWeight.w800,
      height: 1,
    ),
  );
}
