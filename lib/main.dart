import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'providers/auth_provider.dart';
import 'providers/locale_provider.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';
import 'l10n/app_localizations.dart';
import 'supabase/supabase_client.dart';

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
      ],
      child: Consumer2<AuthProvider, LocaleProvider>(
        builder: (_, auth, localeProvider, __) {
          final router = createRouter(auth);
          return MaterialApp.router(
            title: 'Sauti',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            locale: localeProvider.locale,
            supportedLocales: const [Locale('en'), Locale('sw')],
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            routerConfig: router,
          );
        },
      ),
    );
  }
}
