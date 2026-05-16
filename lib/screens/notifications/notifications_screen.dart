import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../l10n/app_localizations.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  static final _items = [
    _Notif(icon: Icons.favorite, color: Colors.red, title: 'Amina Kibao liked your post', time: '2m ago'),
    _Notif(icon: Icons.person_add_outlined, color: AppColors.primary, title: 'John Mwita started following you', time: '15m ago'),
    _Notif(icon: Icons.monetization_on, color: AppColors.tip, title: 'You received a Tsh 5,000 tip from Fatuma', time: '1h ago'),
    _Notif(icon: Icons.chat_bubble_outline, color: AppColors.accent, title: 'Peter commented on your video', time: '3h ago'),
    _Notif(icon: Icons.live_tv, color: AppColors.live, title: '3 people are waiting for your live session', time: '5h ago'),
    _Notif(icon: Icons.subscriptions_outlined, color: AppColors.primary, title: 'Mariam subscribed to your channel', time: '1d ago'),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text(l10n.notifications)),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _items.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (_, i) => _NotifTile(notif: _items[i]),
      ),
    );
  }
}

class _Notif {
  final IconData icon;
  final Color color;
  final String title;
  final String time;
  const _Notif({required this.icon, required this.color, required this.title, required this.time});
}

class _NotifTile extends StatelessWidget {
  final _Notif notif;
  const _NotifTile({required this.notif});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(color: notif.color.withValues(alpha: 0.15), shape: BoxShape.circle),
              child: Icon(notif.icon, color: notif.color, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(notif.title, style: const TextStyle(color: Colors.white, fontSize: 13)),
              const SizedBox(height: 2),
              Text(notif.time, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
            ])),
          ],
        ),
      );
}
