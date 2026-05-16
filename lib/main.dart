import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'providers/auth_provider.dart';
import 'providers/locale_provider.dart';
import 'providers/theme_provider.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';
import 'l10n/app_localizations.dart';
import 'supabase/supabase_client.dart';
import 'services/update_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);
  runApp(const SautiApp());
}

class SautiApp extends StatelessWidget {
  const SautiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer3<AuthProvider, LocaleProvider, ThemeProvider>(
        builder: (_, auth, localeProvider, themeProvider, __) {
          final router = createRouter(auth);
          return MaterialApp.router(
            title: 'Sauti',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: themeProvider.mode,
            locale: localeProvider.locale,
            supportedLocales: const [Locale('en'), Locale('sw')],
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            routerConfig: router,
            builder: (context, child) => _UpdateChecker(child: child!),
          );
        },
      ),
    );
  }
}

class _UpdateChecker extends StatefulWidget {
  final Widget child;
  const _UpdateChecker({required this.child});

  @override
  State<_UpdateChecker> createState() => _UpdateCheckerState();
}

class _UpdateCheckerState extends State<_UpdateChecker> {
  @override
  void initState() {
    super.initState();
    // Check after first frame so router is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      UpdateService.checkForUpdate(context);
    });
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
