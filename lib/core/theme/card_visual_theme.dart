import 'package:flutter/material.dart';

enum ThemeCategory { tous, nature, sombre, clair }

enum CardVisualTheme {
  // Clair
  pur, craie, sable, lavande, rosee, ivoire,
  // Sombre
  flamme, prisme, charbon, indigo, emeraude, bordeaux,
  // Nature
  minuit, aube, ocean, ardoise, desert, brume, aurore, tempete,
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
  static const _glass    = Color(0x38FFFFFF);
  static const _glassText = Colors.white;
  static const _darkText  = Color(0xFF1A1A1A);

  static const Map<CardVisualTheme, CardVisualThemeData> _data = {

    // ════════════════════════════════════════════════════════════════
    // CLAIR
    // ════════════════════════════════════════════════════════════════

    CardVisualTheme.pur: CardVisualThemeData(
      name: 'Pur',
      gradientColors: [Color(0xFFF8F6F1), Color(0xFFF0EDE7)],
      textColor: _darkText,
      buttonBg: Color(0xFFEEEBE5),
      buttonIconColor: Color(0xFF888888),
      uiOverlayBg: _darkText,
      uiOverlayFg: Colors.white,
      isAdaptive: true,
      category: ThemeCategory.clair,
    ),

    CardVisualTheme.craie: CardVisualThemeData(
      name: 'Craie',
      gradientColors: [Color(0xFFF7F4EE), Color(0xFFEDE8DF), Color(0xFFE4DDD2)],
      textColor: _darkText,
      buttonBg: Color(0xFFDDD8CF),
      buttonIconColor: Color(0xFF555555),
      uiOverlayBg: _darkText,
      uiOverlayFg: Colors.white,
      category: ThemeCategory.clair,
    ),

    CardVisualTheme.sable: CardVisualThemeData(
      name: 'Sable',
      gradientColors: [Color(0xFFF5EDD8), Color(0xFFEDE0C4), Color(0xFFE5D5B0)],
      textColor: Color(0xFF2A1F0A),
      buttonBg: Color(0xFFD8C9A8),
      buttonIconColor: Color(0xFF5A4A30),
      uiOverlayBg: Color(0xFF2A1F0A),
      uiOverlayFg: Colors.white,
      category: ThemeCategory.clair,
    ),

    CardVisualTheme.lavande: CardVisualThemeData(
      name: 'Lavande',
      gradientColors: [Color(0xFFEDE5F5), Color(0xFFDFD2EE), Color(0xFFD2C4E8)],
      textColor: Color(0xFF1E1030),
      buttonBg: Color(0xFFC8B8DF),
      buttonIconColor: Color(0xFF3A2A55),
      uiOverlayBg: Color(0xFF1E1030),
      uiOverlayFg: Colors.white,
      category: ThemeCategory.clair,
    ),

    CardVisualTheme.rosee: CardVisualThemeData(
      name: 'Rosée',
      gradientColors: [Color(0xFFF5E8EC), Color(0xFFEDD8DE), Color(0xFFE5CDD5)],
      textColor: Color(0xFF2A0E18),
      buttonBg: Color(0xFFD8B8C4),
      buttonIconColor: Color(0xFF5A2840),
      uiOverlayBg: Color(0xFF2A0E18),
      uiOverlayFg: Colors.white,
      category: ThemeCategory.clair,
    ),

    CardVisualTheme.ivoire: CardVisualThemeData(
      name: 'Ivoire',
      gradientColors: [Color(0xFFF8F2E0), Color(0xFFF0E8CC), Color(0xFFE8DCB8)],
      textColor: Color(0xFF221A00),
      buttonBg: Color(0xFFDDD0A0),
      buttonIconColor: Color(0xFF554A20),
      uiOverlayBg: Color(0xFF221A00),
      uiOverlayFg: Colors.white,
      category: ThemeCategory.clair,
    ),

    // ════════════════════════════════════════════════════════════════
    // SOMBRE
    // ════════════════════════════════════════════════════════════════

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

    CardVisualTheme.charbon: CardVisualThemeData(
      name: 'Charbon',
      gradientColors: [Color(0xFF0A0A0A), Color(0xFF181818), Color(0xFF111114)],
      textColor: Colors.white,
      buttonBg: _glass,
      buttonIconColor: _glassText,
      uiOverlayBg: _glass,
      uiOverlayFg: _glassText,
      category: ThemeCategory.sombre,
    ),

    CardVisualTheme.indigo: CardVisualThemeData(
      name: 'Indigo',
      gradientColors: [Color(0xFF04091E), Color(0xFF0D1840), Color(0xFF141F55)],
      textColor: Colors.white,
      buttonBg: _glass,
      buttonIconColor: _glassText,
      uiOverlayBg: _glass,
      uiOverlayFg: _glassText,
      category: ThemeCategory.sombre,
    ),

    CardVisualTheme.emeraude: CardVisualThemeData(
      name: 'Émeraude',
      gradientColors: [Color(0xFF011A0C), Color(0xFF063322), Color(0xFF094430)],
      textColor: Colors.white,
      buttonBg: _glass,
      buttonIconColor: _glassText,
      uiOverlayBg: _glass,
      uiOverlayFg: _glassText,
      category: ThemeCategory.sombre,
    ),

    CardVisualTheme.bordeaux: CardVisualThemeData(
      name: 'Bordeaux',
      gradientColors: [Color(0xFF160004), Color(0xFF500012), Color(0xFF7A001E)],
      textColor: Colors.white,
      buttonBg: _glass,
      buttonIconColor: _glassText,
      uiOverlayBg: _glass,
      uiOverlayFg: _glassText,
      category: ThemeCategory.sombre,
    ),

    // ════════════════════════════════════════════════════════════════
    // NATURE
    // ════════════════════════════════════════════════════════════════

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

    CardVisualTheme.desert: CardVisualThemeData(
      name: 'Désert',
      gradientColors: [Color(0xFF2A1500), Color(0xFF8B4A0A), Color(0xFFD4820A)],
      textColor: Colors.white,
      buttonBg: _glass,
      buttonIconColor: _glassText,
      uiOverlayBg: _glass,
      uiOverlayFg: _glassText,
      assetImage: 'assets/images/themes/desert.jpg',
      category: ThemeCategory.nature,
    ),

    CardVisualTheme.brume: CardVisualThemeData(
      name: 'Brume',
      gradientColors: [Color(0xFF0E1520), Color(0xFF1E2E40), Color(0xFF162535)],
      textColor: Colors.white,
      buttonBg: _glass,
      buttonIconColor: _glassText,
      uiOverlayBg: _glass,
      uiOverlayFg: _glassText,
      assetImage: 'assets/images/themes/brume.jpg',
      category: ThemeCategory.nature,
    ),

    CardVisualTheme.aurore: CardVisualThemeData(
      name: 'Aurore',
      gradientColors: [Color(0xFF001A0A), Color(0xFF003A1A), Color(0xFF004A22)],
      textColor: Colors.white,
      buttonBg: _glass,
      buttonIconColor: _glassText,
      uiOverlayBg: _glass,
      uiOverlayFg: _glassText,
      assetImage: 'assets/images/themes/aurore.jpg',
      category: ThemeCategory.nature,
    ),

    CardVisualTheme.tempete: CardVisualThemeData(
      name: 'Tempête',
      gradientColors: [Color(0xFF0A0E14), Color(0xFF1A2030), Color(0xFF121820)],
      textColor: Colors.white,
      buttonBg: _glass,
      buttonIconColor: _glassText,
      uiOverlayBg: _glass,
      uiOverlayFg: _glassText,
      assetImage: 'assets/images/themes/tempete.jpg',
      category: ThemeCategory.nature,
    ),
  };

  CardVisualThemeData get data => _data[this]!;
}
