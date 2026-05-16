import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

// ---------------------------------------------------------------------------
// Semantic colour tokens — use these everywhere, never raw hex
// ---------------------------------------------------------------------------
class SautiColors {
  final Color background;
  final Color surface;
  final Color surfaceVariant;
  final Color onBackground;
  final Color onSurface;
  final Color textSecondary;
  final Color textTertiary;
  final Color divider;
  final Color primary;
  final Color primaryDark;
  final Color accent;
  final Color blue;
  final Color error;
  final Color live;
  final Color tip;
  final Color verified;
  final Color cardShadow;
  final Brightness brightness;

  const SautiColors({
    required this.background,
    required this.surface,
    required this.surfaceVariant,
    required this.onBackground,
    required this.onSurface,
    required this.textSecondary,
    required this.textTertiary,
    required this.divider,
    required this.primary,
    required this.primaryDark,
    required this.accent,
    required this.blue,
    required this.error,
    required this.live,
    required this.tip,
    required this.verified,
    required this.cardShadow,
    required this.brightness,
  });

  bool get isDark => brightness == Brightness.dark;

  static const light = SautiColors(
    brightness: Brightness.light,
    background: Color(0xFFF2F2F7),
    surface: Color(0xFFFFFFFF),
    surfaceVariant: Color(0xFFE5E5EA),
    onBackground: Color(0xFF000000),
    onSurface: Color(0xFF000000),
    textSecondary: Color(0xFF8E8E93),
    textTertiary: Color(0xFFC7C7CC),
    divider: Color(0xFFC6C6C8),
    primary: Color(0xFF34C759),
    primaryDark: Color(0xFF248A3D),
    accent: Color(0xFFFF9F0A),
    blue: Color(0xFF007AFF),
    error: Color(0xFFFF3B30),
    live: Color(0xFFFF3B30),
    tip: Color(0xFFFFCC00),
    verified: Color(0xFF007AFF),
    cardShadow: Color(0x0D000000),
  );

  static const dark = SautiColors(
    brightness: Brightness.dark,
    background: Color(0xFF000000),
    surface: Color(0xFF1C1C1E),
    surfaceVariant: Color(0xFF2C2C2E),
    onBackground: Color(0xFFFFFFFF),
    onSurface: Color(0xFFEBEBF5),
    textSecondary: Color(0xFF8E8E93),
    textTertiary: Color(0xFF48484A),
    divider: Color(0xFF38383A),
    primary: Color(0xFF30D158),
    primaryDark: Color(0xFF34C759),
    accent: Color(0xFFFF9F0A),
    blue: Color(0xFF0A84FF),
    error: Color(0xFFFF453A),
    live: Color(0xFFFF453A),
    tip: Color(0xFFFFD60A),
    verified: Color(0xFF0A84FF),
    cardShadow: Color(0x00000000),
  );
}

// Extension so any widget can do: context.colors.primary
extension SautiColorsX on BuildContext {
  SautiColors get colors =>
      Theme.of(this).brightness == Brightness.dark ? SautiColors.dark : SautiColors.light;
}

// ---------------------------------------------------------------------------
// Keep a static alias for places that can't access context (e.g. const widgets)
// ---------------------------------------------------------------------------
class AppColors {
  static const primary = Color(0xFF34C759);
  static const primaryDark = Color(0xFF248A3D);
  static const accent = Color(0xFFFF9F0A);
  static const blue = Color(0xFF007AFF);
  static const background = Color(0xFFF2F2F7);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceVariant = Color(0xFFE5E5EA);
  static const onBackground = Color(0xFF000000);
  static const onSurface = Color(0xFF000000);
  static const textSecondary = Color(0xFF8E8E93);
  static const textTertiary = Color(0xFFC7C7CC);
  static const divider = Color(0xFFC6C6C8);
  static const error = Color(0xFFFF3B30);
  static const live = Color(0xFFFF3B30);
  static const tip = Color(0xFFFFCC00);
  static const verified = Color(0xFF007AFF);
}

// ---------------------------------------------------------------------------
// Theme builder
// ---------------------------------------------------------------------------
class AppTheme {
  static TextTheme _textTheme(Color onBackground) =>
      GoogleFonts.dmSansTextTheme().copyWith(
        headlineLarge: GoogleFonts.dmSans(fontSize: 28, fontWeight: FontWeight.w700, color: onBackground, letterSpacing: -0.5),
        headlineMedium: GoogleFonts.dmSans(fontSize: 22, fontWeight: FontWeight.w700, color: onBackground, letterSpacing: -0.3),
        titleLarge: GoogleFonts.dmSans(fontSize: 17, fontWeight: FontWeight.w600, color: onBackground),
        titleMedium: GoogleFonts.dmSans(fontSize: 15, fontWeight: FontWeight.w600, color: onBackground),
        bodyLarge: GoogleFonts.dmSans(fontSize: 16, fontWeight: FontWeight.w400, color: onBackground),
        bodyMedium: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w400, color: onBackground),
        bodySmall: GoogleFonts.dmSans(fontSize: 12, fontWeight: FontWeight.w400, color: const Color(0xFF8E8E93)),
        labelLarge: GoogleFonts.dmSans(fontSize: 15, fontWeight: FontWeight.w600, color: onBackground),
        labelMedium: GoogleFonts.dmSans(fontSize: 13, fontWeight: FontWeight.w500, color: const Color(0xFF8E8E93)),
        labelSmall: GoogleFonts.dmSans(fontSize: 11, fontWeight: FontWeight.w500, color: const Color(0xFF8E8E93), letterSpacing: 0.3),
      );

  static ThemeData get light => _build(SautiColors.light);
  static ThemeData get dark => _build(SautiColors.dark);

  static ThemeData _build(SautiColors c) => ThemeData(
        useMaterial3: true,
        brightness: c.brightness,
        scaffoldBackgroundColor: c.background,
        colorScheme: ColorScheme(
          brightness: c.brightness,
          primary: c.primary,
          onPrimary: Colors.white,
          secondary: c.accent,
          onSecondary: Colors.white,
          error: c.error,
          onError: Colors.white,
          surface: c.surface,
          onSurface: c.onSurface,
        ),
        textTheme: _textTheme(c.onBackground),
        appBarTheme: AppBarTheme(
          backgroundColor: c.surface.withValues(alpha: 0.92),
          elevation: 0,
          scrolledUnderElevation: 0.5,
          shadowColor: c.divider,
          centerTitle: true,
          systemOverlayStyle: c.isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
          titleTextStyle: GoogleFonts.dmSans(fontSize: 17, fontWeight: FontWeight.w600, color: c.onBackground),
          iconTheme: IconThemeData(color: c.primary, size: 22),
          actionsIconTheme: IconThemeData(color: c.primary, size: 22),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: c.primary,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 52),
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            textStyle: GoogleFonts.dmSans(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: c.primary,
            side: BorderSide(color: c.primary, width: 1.5),
            minimumSize: const Size(double.infinity, 52),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            textStyle: GoogleFonts.dmSans(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: c.primary,
            textStyle: GoogleFonts.dmSans(fontSize: 15, fontWeight: FontWeight.w500),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: c.surfaceVariant,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: c.primary, width: 1.5)),
          hintStyle: GoogleFonts.dmSans(color: c.textSecondary, fontSize: 15),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        ),
        cardTheme: CardThemeData(
          color: c.surface,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        dividerTheme: DividerThemeData(color: c.divider, thickness: 0.5, space: 0),
        listTileTheme: ListTileThemeData(
          tileColor: c.surface,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
          titleTextStyle: GoogleFonts.dmSans(fontSize: 16, fontWeight: FontWeight.w400, color: c.onBackground),
          subtitleTextStyle: GoogleFonts.dmSans(fontSize: 13, color: c.textSecondary),
        ),
        switchTheme: SwitchThemeData(
          thumbColor: WidgetStateProperty.all(Colors.white),
          trackColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? c.primary : c.surfaceVariant),
          trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
        ),
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: c.surface,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
          elevation: 0,
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: c.isDark ? c.surface : c.onBackground,
          contentTextStyle: GoogleFonts.dmSans(color: c.isDark ? c.onBackground : Colors.white, fontSize: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          behavior: SnackBarBehavior.floating,
        ),
        cupertinoOverrideTheme: CupertinoThemeData(primaryColor: c.primary),
      );
}
