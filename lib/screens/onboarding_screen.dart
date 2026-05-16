import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/locale_provider.dart';
import '../theme/app_theme.dart';
import '../l10n/app_localizations.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  int _currentPage = 0;
  bool _languagePicked = false;

  final _pages = const [
    _OnboardingPage(icon: Icons.video_camera_back_outlined, gradient: [Color(0xFF1B5E20), Color(0xFF4CAF50)], titleKey: 'onboardingTitle1', descKey: 'onboardingDesc1'),
    _OnboardingPage(icon: Icons.live_tv_outlined, gradient: [Color(0xFF4A148C), Color(0xFFAB47BC)], titleKey: 'onboardingTitle2', descKey: 'onboardingDesc2'),
    _OnboardingPage(icon: Icons.trending_up_outlined, gradient: [Color(0xFFE65100), Color(0xFFFF9800)], titleKey: 'onboardingTitle3', descKey: 'onboardingDesc3'),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _next(AppLocalizations l10n) {
    if (!_languagePicked) {
      setState(() => _languagePicked = true);
      return;
    }
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(duration: const Duration(milliseconds: 350), curve: Curves.easeInOut);
    } else {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final localeProvider = context.watch<LocaleProvider>();

    if (!_languagePicked) {
      return _LanguagePicker(
        selectedLocale: localeProvider.locale,
        onSelect: (locale) => context.read<LocaleProvider>().setLocale(locale),
        onContinue: () => setState(() => _languagePicked = true),
        l10n: l10n,
      );
    }

    return Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () => context.go('/login'),
                child: Text(l10n.skip, style: const TextStyle(color: AppColors.textSecondary)),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemCount: _pages.length,
                itemBuilder: (_, i) => _pages[i].build(context, l10n),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                      (i) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: i == _currentPage ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: i == _currentPage ? AppColors.primary : AppColors.divider,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => _next(l10n),
                    child: Text(_currentPage == _pages.length - 1 ? l10n.getStarted : l10n.next),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPage {
  final IconData icon;
  final List<Color> gradient;
  final String titleKey;
  final String descKey;

  const _OnboardingPage({required this.icon, required this.gradient, required this.titleKey, required this.descKey});

  Widget build(BuildContext context, AppLocalizations l10n) {
    final title = titleKey == 'onboardingTitle1' ? l10n.onboardingTitle1 : titleKey == 'onboardingTitle2' ? l10n.onboardingTitle2 : l10n.onboardingTitle3;
    final desc = descKey == 'onboardingDesc1' ? l10n.onboardingDesc1 : descKey == 'onboardingDesc2' ? l10n.onboardingDesc2 : l10n.onboardingDesc3;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: gradient, begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(40),
            ),
            child: Icon(icon, size: 72, color: Colors.white),
          ),
          const SizedBox(height: 40),
          Text(title, style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          Text(desc, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _LanguagePicker extends StatelessWidget {
  final Locale selectedLocale;
  final ValueChanged<Locale> onSelect;
  final VoidCallback onContinue;
  final AppLocalizations l10n;

  const _LanguagePicker({required this.selectedLocale, required this.onSelect, required this.onContinue, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.language, size: 64, color: AppColors.primary),
              const SizedBox(height: 24),
              Text(l10n.selectLanguage, style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center),
              const SizedBox(height: 40),
              _LangOption(label: 'English', subtitle: 'Continue in English', locale: const Locale('en'), selected: selectedLocale.languageCode == 'en', onTap: onSelect),
              const SizedBox(height: 16),
              _LangOption(label: 'Kiswahili', subtitle: 'Endelea kwa Kiswahili', locale: const Locale('sw'), selected: selectedLocale.languageCode == 'sw', onTap: onSelect),
              const SizedBox(height: 40),
              ElevatedButton(onPressed: onContinue, child: Text(l10n.next)),
            ],
          ),
        ),
      ),
    );
  }
}

class _LangOption extends StatelessWidget {
  final String label;
  final String subtitle;
  final Locale locale;
  final bool selected;
  final ValueChanged<Locale> onTap;

  const _LangOption({required this.label, required this.subtitle, required this.locale, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(locale),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary.withValues(alpha: 0.2) : AppColors.surface,
          border: Border.all(color: selected ? AppColors.primary : AppColors.divider, width: selected ? 2 : 1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Text(locale.languageCode == 'en' ? '🇬🇧' : '🇹🇿', style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 16),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
              Text(subtitle, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
            ]),
            const Spacer(),
            if (selected) const Icon(Icons.check_circle, color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}
