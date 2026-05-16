import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../screens/splash_screen.dart';
import '../screens/onboarding_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/feed/feed_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/upload/upload_screen.dart';
import '../screens/live/live_screen.dart';
import '../screens/earnings/earnings_screen.dart';
import '../screens/notifications/notifications_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../widgets/bottom_nav.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

GoRouter createRouter(AuthProvider authProvider) => GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: '/splash',
      redirect: (context, state) {
        final auth = context.read<AuthProvider>();
        final isAuth = auth.isAuthenticated;
        final isUnknown = auth.status == AuthStatus.unknown;
        final location = state.uri.path;

        if (isUnknown) return '/splash';
        if (!isAuth && location != '/login' && location != '/signup' && location != '/onboarding' && location != '/splash') {
          return '/onboarding';
        }
        if (isAuth && (location == '/login' || location == '/signup' || location == '/onboarding')) {
          return '/feed';
        }
        return null;
      },
      routes: [
        GoRoute(path: '/splash', builder: (_, __) => const SplashScreen()),
        GoRoute(path: '/onboarding', builder: (_, __) => const OnboardingScreen()),
        GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
        GoRoute(path: '/signup', builder: (_, __) => const SignupScreen()),
        GoRoute(path: '/live/:channelId', builder: (_, state) => LiveScreen(channelId: state.pathParameters['channelId']!)),
        ShellRoute(
          navigatorKey: _shellNavigatorKey,
          builder: (_, __, child) => BottomNavShell(child: child),
          routes: [
            GoRoute(path: '/feed', builder: (_, __) => const FeedScreen()),
            GoRoute(path: '/profile/:userId', builder: (_, state) => ProfileScreen(userId: state.pathParameters['userId']!)),
            GoRoute(path: '/upload', builder: (_, __) => const UploadScreen()),
            GoRoute(path: '/earnings', builder: (_, __) => const EarningsScreen()),
            GoRoute(path: '/notifications', builder: (_, __) => const NotificationsScreen()),
            GoRoute(path: '/settings', builder: (_, __) => const SettingsScreen()),
          ],
        ),
      ],
    );
