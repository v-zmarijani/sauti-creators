import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // iOS system colours adapted for Sauti brand
  static const primary = Color(0xFF34C759);        // iOS green
  static const primaryDark = Color(0xFF248A3D);
  static const accent = Color(0xFFFF9F0A);          // iOS orange
  static const blue = Color(0xFF007AFF);            // iOS blue

  // Backgrounds — iOS grouped style
  static const background = Color(0xFFF2F2F7);      // iOS systemGroupedBackground
  static const surface = Color(0xFFFFFFFF);         // white cards
  static const surfaceVariant = Color(0xFFE5E5EA);  // iOS secondarySystemFill
  static const insetBackground = Color(0xFFEFEFF4); // iOS secondaryGroupedBackground

  // Text
  static const onBackground = Color(0xFF1C1C1E);    // iOS label
  static const onSurface = Color(0xFF1C1C1E);
  static const textSecondary = Color(0xFF8E8E93);   // iOS secondaryLabel
  static const textTertiary = Color(0xFFC7C7CC);    // iOS tertiaryLabel

  // Separator
  static const divider = Color(0xFFC6C6C8);         // iOS separator
  static const insetDivider = Color(0xFFD1D1D6);

  // Semantic
  static const error = Color(0xFFFF3B30);           // iOS red
  static const live = Color(0xFFFF3B30);
  static const tip = Color(0xFFFFCC00);             // iOS yellow
  static const verified = Color(0xFF007AFF);
}

class AppTheme {
  static TextTheme get _textTheme => GoogleFonts.dmSansTextTheme().copyWith(
        headlineLarge: GoogleFonts.dmSans(fontSize: 28, fontWeight: FontWeight.w700, color: AppColors.onBackground, letterSpacing: -0.5),
        headlineMedium: GoogleFonts.dmSans(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.onBackground, letterSpacing: -0.3),
        titleLarge: GoogleFonts.dmSans(fontSize: 17, fontWeight: FontWeight.w600, color: AppColors.onBackground),
        titleMedium: GoogleFonts.dmSans(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.onBackground),
        bodyLarge: GoogleFonts.dmSans(fontSize: 16, fontWeight: FontWeight.w400, color: AppColors.onSurface),
        bodyMedium: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.onSurface),
        bodySmall: GoogleFonts.dmSans(fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.textSecondary),
        labelLarge: GoogleFonts.dmSans(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.onBackground),
        labelMedium: GoogleFonts.dmSans(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textSecondary),
        labelSmall: GoogleFonts.dmSans(fontSize: 11, fontWeight: FontWeight.w500, color: AppColors.textSecondary, letterSpacing: 0.3),
      );

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: const ColorScheme.light(
          primary: AppColors.primary,
          secondary: AppColors.accent,
          surface: AppColors.surface,
          error: AppColors.error,
          onPrimary: Colors.white,
          onSurface: AppColors.onSurface,
        ),
        textTheme: _textTheme,
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.surface.withValues(alpha: 0.92),
          elevation: 0,
          scrolledUnderElevation: 0.5,
          shadowColor: AppColors.divider,
          centerTitle: true,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          titleTextStyle: GoogleFonts.dmSans(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: AppColors.onBackground,
          ),
          iconTheme: const IconThemeData(color: AppColors.primary, size: 22),
          actionsIconTheme: const IconThemeData(color: AppColors.primary, size: 22),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 52),
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            textStyle: GoogleFonts.dmSans(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            side: const BorderSide(color: AppColors.primary, width: 1.5),
            minimumSize: const Size(double.infinity, 52),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            textStyle: GoogleFonts.dmSans(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
            textStyle: GoogleFonts.dmSans(fontSize: 15, fontWeight: FontWeight.w500),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.surfaceVariant,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
          hintStyle: GoogleFonts.dmSans(color: AppColors.textSecondary, fontSize: 15),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        ),
        cardTheme: CardThemeData(
          color: AppColors.surface,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        dividerTheme: const DividerThemeData(color: AppColors.divider, thickness: 0.5, space: 0),
        listTileTheme: ListTileThemeData(
          tileColor: AppColors.surface,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
          titleTextStyle: GoogleFonts.dmSans(fontSize: 16, fontWeight: FontWeight.w400, color: AppColors.onBackground),
          subtitleTextStyle: GoogleFonts.dmSans(fontSize: 13, color: AppColors.textSecondary),
        ),
        switchTheme: SwitchThemeData(
          thumbColor: WidgetStateProperty.all(Colors.white),
          trackColor: WidgetStateProperty.resolveWith((states) => states.contains(WidgetState.selected) ? AppColors.primary : AppColors.surfaceVariant),
          trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
        ),
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
          elevation: 0,
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: AppColors.onBackground,
          contentTextStyle: GoogleFonts.dmSans(color: Colors.white, fontSize: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          behavior: SnackBarBehavior.floating,
        ),
        cupertinoOverrideTheme: const CupertinoThemeData(
          primaryColor: AppColors.primary,
        ),
      );
}
