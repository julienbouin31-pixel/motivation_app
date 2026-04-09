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
    scaffold: Color(0xFFF7F7F5),
    card: Colors.white,
    primary: Color(0xFF111111),
    secondary: Color(0xFFAAAAAA),
    surface: Color(0xFFEEEEEC),
    border: Color(0xFFE6E6E4),
  );

  // Aligné sur la palette des widgets iOS : #161616 fond, 38% white secondary
  static const dark = AppColors(
    scaffold: Color(0xFF161616),
    card: Color(0xFF1E1E1E),
    primary: Colors.white,
    secondary: Color(0x99FFFFFF),
    surface: Color(0xFF252525),
    border: Color(0xFF2C2C2C),
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
        textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme),
        appBarTheme: AppBarTheme(
          centerTitle: true,
          elevation: 0,
          titleTextStyle: GoogleFonts.inter(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: AppColors.light.primary,
          ),
        ),
      );

  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.dark.scaffold,
        extensions: const [AppColors.dark],
        textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
        appBarTheme: AppBarTheme(
          centerTitle: true,
          elevation: 0,
          titleTextStyle: GoogleFonts.inter(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: AppColors.dark.primary,
          ),
        ),
      );
}
