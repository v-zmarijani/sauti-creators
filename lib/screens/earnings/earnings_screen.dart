import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../l10n/app_localizations.dart';

class EarningsScreen extends StatelessWidget {
  const EarningsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(title: Text(l10n.earnings)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [AppColors.primary, AppColors.primary], begin: Alignment.topLeft, end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.totalEarnings, style: const TextStyle(color: Colors.white70, fontSize: 14)),
                  const SizedBox(height: 8),
                  const Text('Tsh 1,240,500', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _EarningChip(label: l10n.thisMonth, value: 'Tsh 340,000'),
                      const SizedBox(width: 12),
                      _EarningChip(label: l10n.tips, value: 'Tsh 89,000'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {},
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent, foregroundColor: Colors.black),
              icon: const Icon(Icons.account_balance_wallet_outlined),
              label: Text(l10n.withdraw),
            ),
            const SizedBox(height: 24),
            Text(l10n.tips, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            ..._mockTransactions.map((t) => _TransactionTile(transaction: t)),
          ],
        ),
      ),
    );
  }

  static final _mockTransactions = [
    _Transaction(name: 'Amina K.', amount: 'Tsh 5,000', time: '2 hrs ago', icon: Icons.monetization_on),
    _Transaction(name: 'John M.', amount: 'Tsh 10,000', time: '5 hrs ago', icon: Icons.monetization_on),
    _Transaction(name: 'Subscription', amount: 'Tsh 29,000', time: 'Yesterday', icon: Icons.subscriptions_outlined),
    _Transaction(name: 'Fatuma S.', amount: 'Tsh 2,000', time: '2 days ago', icon: Icons.monetization_on),
  ];
}

class _EarningChip extends StatelessWidget {
  final String label;
  final String value;
  const _EarningChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(10)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: const TextStyle(color: Colors.white60, fontSize: 11)),
          Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13)),
        ]),
      );
}

class _Transaction {
  final String name;
  final String amount;
  final String time;
  final IconData icon;
  const _Transaction({required this.name, required this.amount, required this.time, required this.icon});
}

class _TransactionTile extends StatelessWidget {
  final _Transaction transaction;
  const _TransactionTile({required this.transaction});

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12)),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(color: AppColors.tip.withValues(alpha: 0.15), shape: BoxShape.circle),
              child: Icon(transaction.icon, color: AppColors.tip, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(transaction.name, style: TextStyle(fontWeight: FontWeight.w600, color: context.colors.onBackground)),
              Text(transaction.time, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
            ])),
            Text(transaction.amount, style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.primary)),
          ],
        ),
      );
}
