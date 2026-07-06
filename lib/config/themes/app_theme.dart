import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ─── Palette de couleurs nommées (accessible via Theme.of(ctx).extension<AppColors>()!) ──
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.scaffold,
    required this.card,
    required this.primary,
    required this.secondary,
    required this.surface,
    required this.border,
  });

  final Color scaffold;   // fond de page
  final Color card;       // fond des cartes / containers
  final Color primary;    // texte et icônes principaux
  final Color secondary;  // texte secondaire, hints
  final Color surface;    // fond subtil (icône bg, boutons action)
  final Color border;     // séparateurs et bordures

  static const light = AppColors(
    scaffold: Color(0xFFF0EDE7),
    card: Color(0xFFF8F6F1),
    primary: Color(0xFF111111),
    secondary: Color(0xFFAAAAAA),
    surface: Color(0xFFE8E5DF),
    border: Color(0xFFDEDBD5),
  );

  // Aligné sur la DA "curves" : noir profond, encre neutre douce, filets fins
  static const dark = AppColors(
    scaffold: Color(0xFF0A0A0A),
    card: Color(0xFF141413),
    primary: Color(0xFFF4F4F1),
    secondary: Color(0xFF8B8B87),
    surface: Color(0xFF1C1C1B),
    border: Color(0x26F4F4F1),
  );

  @override
  AppColors copyWith({
    Color? scaffold,
    Color? card,
    Color? primary,
    Color? secondary,
    Color? surface,
    Color? border,
  }) {
    return AppColors(
      scaffold: scaffold ?? this.scaffold,
      card: card ?? this.card,
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      surface: surface ?? this.surface,
      border: border ?? this.border,
    );
  }

  @override
  AppColors lerp(AppColors? other, double t) {
    if (other == null) return this;
    return AppColors(
      scaffold: Color.lerp(scaffold, other.scaffold, t)!,
      card: Color.lerp(card, other.card, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      border: Color.lerp(border, other.border, t)!,
    );
  }
}

// ─── Thèmes Material ──────────────────────────────────────────────────────────

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.light.scaffold,
        extensions: const [AppColors.light],
        textTheme: GoogleFonts.urbanistTextTheme(ThemeData.light().textTheme),
        appBarTheme: AppBarTheme(
          centerTitle: true,
          elevation: 0,
          titleTextStyle: GoogleFonts.urbanist(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: AppColors.light.primary,
          ),
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: AppColors.light.primary,
          contentTextStyle: GoogleFonts.urbanist(
            color: AppColors.light.scaffold,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );

  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.dark.scaffold,
        extensions: const [AppColors.dark],
        textTheme: GoogleFonts.urbanistTextTheme(ThemeData.dark().textTheme),
        appBarTheme: AppBarTheme(
          centerTitle: true,
          elevation: 0,
          titleTextStyle: GoogleFonts.urbanist(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: AppColors.dark.primary,
          ),
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: AppColors.dark.card,
          contentTextStyle: GoogleFonts.urbanist(
            color: AppColors.dark.primary,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
}
