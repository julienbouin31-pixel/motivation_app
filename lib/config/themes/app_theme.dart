import 'package:flutter/material.dart';

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
    scaffold: Color(0xFFF5F5F5),
    card: Colors.white,
    primary: Colors.black,
    secondary: Color(0xFFBDBDBD),
    surface: Color(0xFFF0F0F0),
    border: Color(0xFFEEEEEE),
  );

  static const dark = AppColors(
    scaffold: Color(0xFF111111),
    card: Color(0xFF1C1C1C),
    primary: Colors.white,
    secondary: Color(0xFF757575),
    surface: Color(0xFF2A2A2A),
    border: Color(0xFF2A2A2A),
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
        appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
      );

  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.dark.scaffold,
        extensions: const [AppColors.dark],
        appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
      );
}
