import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/locale_provider.dart';
import '../../theme/app_theme.dart';
import '../../l10n/app_localizations.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final localeProvider = context.watch<LocaleProvider>();
    final isSwahili = localeProvider.locale.languageCode == 'sw';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text(l10n.settings)),
      body: ListView(
        children: [
          _SectionHeader(title: l10n.language),
          SwitchListTile(
            value: isSwahili,
            onChanged: (v) => context.read<LocaleProvider>().setLocale(Locale(v ? 'sw' : 'en')),
            title: Text(isSwahili ? l10n.swahili : l10n.english, style: const TextStyle(color: Colors.white)),
            subtitle: Text(isSwahili ? 'Bonyeza kubadilisha lugha' : 'Tap to switch language', style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
            secondary: const Icon(Icons.language, color: AppColors.primary),
            activeThumbColor: AppColors.primary,
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
        child: Text(title.toUpperCase(), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textSecondary, letterSpacing: 1.2)),
      );
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color color;
  const _SettingsTile({required this.icon, required this.title, required this.onTap, this.color = Colors.white});

  @override
  Widget build(BuildContext context) => ListTile(
        leading: Icon(icon, color: color, size: 22),
        title: Text(title, style: TextStyle(color: color, fontSize: 15)),
        trailing: Icon(Icons.chevron_right, color: AppColors.textSecondary, size: 20),
        onTap: onTap,
      );
}
