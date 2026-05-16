import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class BottomNavShell extends StatelessWidget {
  final Widget child;
  const BottomNavShell({super.key, required this.child});

  int _locationToIndex(String location) {
    if (location.startsWith('/feed')) return 0;
    if (location.startsWith('/notifications')) return 1;
    if (location.startsWith('/earnings')) return 3;
    if (location.startsWith('/profile')) return 4;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final currentIndex = _locationToIndex(location);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: child,
      bottomNavigationBar: _IosTabBar(
        currentIndex: currentIndex,
        onTap: (i) {
          switch (i) {
            case 0: context.go('/feed');
            case 1: context.go('/notifications');
            case 2: context.push('/upload');
            case 3: context.go('/earnings');
            case 4: context.go('/profile/me');
          }
        },
      ),
    );
  }
}

class _IosTabBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  const _IosTabBar({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface.withValues(alpha: 0.85),
            border: const Border(top: BorderSide(color: AppColors.divider, width: 0.5)),
          ),
          child: SafeArea(
            top: false,
            child: SizedBox(
              height: 56,
              child: Row(
                children: [
                  _Tab(icon: CupertinoIcons.house, activeIcon: CupertinoIcons.house_fill, label: 'Home', index: 0, current: currentIndex, onTap: onTap),
                  _Tab(icon: CupertinoIcons.bell, activeIcon: CupertinoIcons.bell_fill, label: 'Activity', index: 1, current: currentIndex, onTap: onTap),
                  _CreateTab(onTap: () => onTap(2)),
                  _Tab(icon: CupertinoIcons.chart_bar, activeIcon: CupertinoIcons.chart_bar_fill, label: 'Earnings', index: 3, current: currentIndex, onTap: onTap),
                  _Tab(icon: CupertinoIcons.person, activeIcon: CupertinoIcons.person_fill, label: 'Profile', index: 4, current: currentIndex, onTap: onTap),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final int index;
  final int current;
  final ValueChanged<int> onTap;

  const _Tab({required this.icon, required this.activeIcon, required this.label, required this.index, required this.current, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final active = index == current;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(active ? activeIcon : icon, size: 24, color: active ? AppColors.primary : AppColors.textSecondary),
            const SizedBox(height: 3),
            Text(label, style: GoogleFonts.dmSans(fontSize: 10, fontWeight: active ? FontWeight.w600 : FontWeight.w400, color: active ? AppColors.primary : AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}

class _CreateTab extends StatelessWidget {
  final VoidCallback onTap;
  const _CreateTab({required this.onTap});

  @override
  Widget build(BuildContext context) => Expanded(
        child: GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: Center(
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [AppColors.primary, Color(0xFF30D158)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.35), blurRadius: 8, offset: const Offset(0, 3))],
              ),
              child: const Icon(CupertinoIcons.add, color: Colors.white, size: 22),
            ),
          ),
        ),
      );
}
