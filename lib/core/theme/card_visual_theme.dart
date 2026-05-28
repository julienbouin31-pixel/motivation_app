import 'package:flutter/material.dart';

enum ThemeCategory { tous, nature, sombre, clair }

enum CardVisualTheme {
  pur,
  minuit,
  flamme,
  prisme,
  aube,
  ocean,
  ardoise,
  craie,
}

class CardVisualThemeData {
  final String name;
  final List<Color> gradientColors;
  final Color textColor;
  final Color buttonBg;
  final Color buttonIconColor;
  final Color uiOverlayBg;
  final Color uiOverlayFg;
  final AlignmentGeometry begin;
  final AlignmentGeometry end;
  final bool isAdaptive;
  final String? assetImage;
  final ThemeCategory category;

  const CardVisualThemeData({
    required this.name,
    required this.gradientColors,
    required this.textColor,
    required this.buttonBg,
    required this.buttonIconColor,
    required this.uiOverlayBg,
    required this.uiOverlayFg,
    this.begin = Alignment.topCenter,
    this.end = Alignment.bottomCenter,
    this.isAdaptive = false,
    this.assetImage,
    this.category = ThemeCategory.tous,
  });
}

extension CardVisualThemeExt on CardVisualTheme {
  static const _glass = Color(0x38FFFFFF);
  static const _glassText = Colors.white;

  static const Map<CardVisualTheme, CardVisualThemeData> _data = {
    // ── Pur — suit le système ────────────────────────────────────────────────
    CardVisualTheme.pur: CardVisualThemeData(
      name: 'Pur',
      gradientColors: [Color(0xFFF8F6F1), Color(0xFFF0EDE7)],
      textColor: Color(0xFF1A1A1A),
      buttonBg: Color(0xFFEEEBE5),
      buttonIconColor: Color(0xFF888888),
      uiOverlayBg: Color(0xFF1A1A1A),
      uiOverlayFg: Colors.white,
      isAdaptive: true,
      category: ThemeCategory.clair,
    ),

    // ── Minuit — ciel étoilé ──────────────────────────────────────────────────
    CardVisualTheme.minuit: CardVisualThemeData(
      name: 'Minuit',
      gradientColors: [Color(0xFF080812), Color(0xFF0F1128), Color(0xFF080E1E)],
      textColor: Colors.white,
      buttonBg: _glass,
      buttonIconColor: _glassText,
      uiOverlayBg: _glass,
      uiOverlayFg: _glassText,
      assetImage: 'assets/images/themes/night.jpg',
      category: ThemeCategory.nature,
    ),

    // ── Flamme — énergie et action ────────────────────────────────────────────
    CardVisualTheme.flamme: CardVisualThemeData(
      name: 'Flamme',
      gradientColors: [Color(0xFF1A0400), Color(0xFF7A1A08), Color(0xFFB84020)],
      textColor: Colors.white,
      buttonBg: _glass,
      buttonIconColor: _glassText,
      uiOverlayBg: _glass,
      uiOverlayFg: _glassText,
      category: ThemeCategory.sombre,
    ),

    // ── Prisme — vision et ambition ───────────────────────────────────────────
    CardVisualTheme.prisme: CardVisualThemeData(
      name: 'Prisme',
      gradientColors: [Color(0xFF0E0620), Color(0xFF261255), Color(0xFF3D1A7A)],
      textColor: Colors.white,
      buttonBg: _glass,
      buttonIconColor: _glassText,
      uiOverlayBg: _glass,
      uiOverlayFg: _glassText,
      category: ThemeCategory.sombre,
    ),

    // ── Aube — coucher de soleil ──────────────────────────────────────────────
    CardVisualTheme.aube: CardVisualThemeData(
      name: 'Aube',
      gradientColors: [Color(0xFF1C0A00), Color(0xFF7A3010), Color(0xFFD4821A)],
      textColor: Colors.white,
      buttonBg: _glass,
      buttonIconColor: _glassText,
      uiOverlayBg: _glass,
      uiOverlayFg: _glassText,
      assetImage: 'assets/images/themes/sunset.jpg',
      category: ThemeCategory.nature,
    ),

    // ── Océan — vagues ────────────────────────────────────────────────────────
    CardVisualTheme.ocean: CardVisualThemeData(
      name: 'Océan',
      gradientColors: [Color(0xFF020C18), Color(0xFF062540), Color(0xFF083060)],
      textColor: Colors.white,
      buttonBg: _glass,
      buttonIconColor: _glassText,
      uiOverlayBg: _glass,
      uiOverlayFg: _glassText,
      assetImage: 'assets/images/themes/ocean.jpg',
      category: ThemeCategory.nature,
    ),

    // ── Forêt ─────────────────────────────────────────────────────────────────
    CardVisualTheme.ardoise: CardVisualThemeData(
      name: 'Forêt',
      gradientColors: [Color(0xFF0A1A0E), Color(0xFF1A3A21), Color(0xFF0F2B16)],
      textColor: Colors.white,
      buttonBg: _glass,
      buttonIconColor: _glassText,
      uiOverlayBg: _glass,
      uiOverlayFg: _glassText,
      assetImage: 'assets/images/themes/forest.jpg',
      category: ThemeCategory.nature,
    ),

    // ── Craie — éditorial et épuré ────────────────────────────────────────────
    CardVisualTheme.craie: CardVisualThemeData(
      name: 'Craie',
      gradientColors: [Color(0xFFF7F4EE), Color(0xFFEDE8DF), Color(0xFFE4DDD2)],
      textColor: Color(0xFF1A1A1A),
      buttonBg: Color(0xFFDDD8CF),
      buttonIconColor: Color(0xFF555555),
      uiOverlayBg: Color(0xFF1A1A1A),
      uiOverlayFg: Colors.white,
      category: ThemeCategory.clair,
    ),
  };

  CardVisualThemeData get data => _data[this]!;
}
