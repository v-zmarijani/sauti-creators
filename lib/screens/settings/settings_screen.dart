import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/locale_provider.dart';
import '../../providers/theme_provider.dart';
import '../../theme/app_theme.dart';
import '../../l10n/app_localizations.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.colors;
    final localeProvider = context.watch<LocaleProvider>();
    final themeProvider = context.watch<ThemeProvider>();
    final isSwahili = localeProvider.locale.languageCode == 'sw';

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(title: Text(l10n.settings)),
      body: ListView(
        children: [
          _SectionHeader(title: 'Appearance'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SegmentedButton<ThemeMode>(
              segments: const [
                ButtonSegment(value: ThemeMode.light, label: Text('Light'), icon: Icon(Icons.light_mode_outlined)),
                ButtonSegment(value: ThemeMode.system, label: Text('System'), icon: Icon(Icons.brightness_auto_outlined)),
                ButtonSegment(value: ThemeMode.dark, label: Text('Dark'), icon: Icon(Icons.dark_mode_outlined)),
              ],
              selected: {themeProvider.mode},
              onSelectionChanged: (s) => context.read<ThemeProvider>().setMode(s.first),
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) return colors.primary.withValues(alpha: 0.15);
                  return colors.surface;
                }),
                foregroundColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) return colors.primary;
                  return colors.textSecondary;
                }),
              ),
            ),
          ),
          const Divider(),
          _SectionHeader(title: l10n.language),
          SwitchListTile(
            value: isSwahili,
            onChanged: (v) => context.read<LocaleProvider>().setLocale(Locale(v ? 'sw' : 'en')),
            title: Text(isSwahili ? l10n.swahili : l10n.english, style: TextStyle(color: colors.onBackground)),
            subtitle: Text(
              isSwahili ? 'Bonyeza kubadilisha lugha' : 'Tap to switch language',
              style: TextStyle(color: colors.textSecondary, fontSize: 12),
            ),
            secondary: Icon(Icons.language, color: colors.primary),
            activeThumbColor: colors.primary,
          ),
          const Divider(),
          _SectionHeader(title: 'Account'),
          _SettingsTile(icon: Icons.person_outline, title: l10n.editProfile, onTap: () {}),
          _SettingsTile(icon: Icons.lock_outline, title: l10n.password, onTap: () {}),
          _SettingsTile(icon: Icons.notifications_outlined, title: l10n.notifications, onTap: () {}),
          const Divider(),
          _SectionHeader(title: 'Support'),
          _SettingsTile(icon: Icons.privacy_tip_outlined, title: l10n.privacyPolicy, onTap: () {}),
          _SettingsTile(icon: Icons.description_outlined, title: l10n.termsOfService, onTap: () {}),
          const Divider(),
          _SettingsTile(
            icon: Icons.logout,
            title: l10n.logout,
            color: AppColors.error,
            onTap: () async {
              await context.read<AuthProvider>().signOut();
              if (context.mounted) context.go('/onboarding');
            },
          ),
          _SettingsTile(icon: Icons.delete_outline, title: l10n.deleteAccount, color: AppColors.error, onTap: () {}),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
        child: Text(
          title.toUpperCase(),
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textSecondary, letterSpacing: 1.2),
        ),
      );
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? color;
  const _SettingsTile({required this.icon, required this.title, required this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? context.colors.onBackground;
    return ListTile(
      leading: Icon(icon, color: effectiveColor, size: 22),
      title: Text(title, style: TextStyle(color: effectiveColor, fontSize: 15)),
      trailing: Icon(Icons.chevron_right, color: AppColors.textSecondary, size: 20),
      onTap: onTap,
    );
  }
}
