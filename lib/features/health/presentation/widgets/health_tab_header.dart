import 'package:flutter/material.dart';

const _ink = Color(0xFF1A1C1E);
const _muted = Color(0xFF667085);

class HealthTabHeader extends StatelessWidget {
  const HealthTabHeader({
    this.title = 'Health Dashboard (Sample)',
    super.key,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 6, 8, 10),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: _ink,
              fontSize: 16,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.2,
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.calendar_today_outlined,
                size: 20,
                color: _muted,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
