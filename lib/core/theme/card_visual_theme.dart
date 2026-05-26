import 'package:flutter/material.dart';

enum CardVisualTheme {
  pur,
  aurore,
  cosmos,
  jungle,
  braise,
  abysses,
  sakura,
  mineral,
}

class CardVisualThemeData {
  final String name;
  final List<Color> gradientColors;
  final Color textColor;
  final Color buttonBg;
  final Color buttonIconColor;
  // Couleur des éléments UI flottants (avatar header, boutons bas de page)
  final Color uiOverlayBg;
  final Color uiOverlayFg;
  final AlignmentGeometry begin;
  final AlignmentGeometry end;
  final bool isAdaptive;
  final String? imageUrl;

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
    this.imageUrl,
  });
}

extension CardVisualThemeExt on CardVisualTheme {
  static const _glass = Color(0x38FFFFFF);
  static const _glassText = Colors.white;

  static const Map<CardVisualTheme, CardVisualThemeData> _data = {
    // ── Pur ─────────────────────────────────────────────────────────────────
    CardVisualTheme.pur: CardVisualThemeData(
      name: 'Pur',
      gradientColors: [Color(0xFFF8F6F1), Color(0xFFF0EDE7)],
      textColor: Color(0xFF1A1A1A),
      buttonBg: Color(0xFFEEEBE5),
      buttonIconColor: Color(0xFF888888),
      uiOverlayBg: Color(0xFF1A1A1A),
      uiOverlayFg: Colors.white,
      isAdaptive: true,
    ),

    // ── Aurore — lever de soleil en montagne ─────────────────────────────
    CardVisualTheme.aurore: CardVisualThemeData(
      name: 'Aurore',
      gradientColors: [Color(0xFFFF7043), Color(0xFFFF8A65), Color(0xFFFFCC02)],
      textColor: Colors.white,
      buttonBg: _glass,
      buttonIconColor: _glassText,
      uiOverlayBg: _glass,
      uiOverlayFg: _glassText,
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      imageUrl: 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800&fit=crop&q=80',
    ),

    // ── Cosmos — voie lactée ──────────────────────────────────────────────
    CardVisualTheme.cosmos: CardVisualThemeData(
      name: 'Cosmos',
      gradientColors: [Color(0xFF0F0C29), Color(0xFF302B63), Color(0xFF24243E)],
      textColor: Colors.white,
      buttonBg: _glass,
      buttonIconColor: _glassText,
      uiOverlayBg: _glass,
      uiOverlayFg: _glassText,
      imageUrl: 'https://images.unsplash.com/photo-1462331940025-496dfbfc7564?w=800&fit=crop&q=80',
    ),

    // ── Jungle — forêt tropicale ──────────────────────────────────────────
    CardVisualTheme.jungle: CardVisualThemeData(
      name: 'Jungle',
      gradientColors: [Color(0xFF0B3D2E), Color(0xFF1C5E3F), Color(0xFF0F4C34)],
      textColor: Colors.white,
      buttonBg: _glass,
      buttonIconColor: _glassText,
      uiOverlayBg: _glass,
      uiOverlayFg: _glassText,
      imageUrl: 'https://images.unsplash.com/photo-1448375240586-882707db888b?w=800&fit=crop&q=80',
    ),

    // ── Braise — feu et braises ───────────────────────────────────────────
    CardVisualTheme.braise: CardVisualThemeData(
      name: 'Braise',
      gradientColors: [Color(0xFF4A0000), Color(0xFF8B0000), Color(0xFFC0392B)],
      textColor: Colors.white,
      buttonBg: _glass,
      buttonIconColor: _glassText,
      uiOverlayBg: _glass,
      uiOverlayFg: _glassText,
      imageUrl: 'https://images.unsplash.com/photo-1475087542963-13ab5e611954?w=800&fit=crop&q=80',
    ),

    // ── Abysses — fond sous-marin ─────────────────────────────────────────
    CardVisualTheme.abysses: CardVisualThemeData(
      name: 'Abysses',
      gradientColors: [Color(0xFF0A1628), Color(0xFF1A3A5C), Color(0xFF0D2B4A)],
      textColor: Colors.white,
      buttonBg: _glass,
      buttonIconColor: _glassText,
      uiOverlayBg: _glass,
      uiOverlayFg: _glassText,
      imageUrl: 'https://images.unsplash.com/photo-1518020382113-a7e8fc38eac9?w=800&fit=crop&q=80',
    ),

    // ── Sakura — fleurs de cerisier ───────────────────────────────────────
    CardVisualTheme.sakura: CardVisualThemeData(
      name: 'Sakura',
      gradientColors: [Color(0xFFFFC0CB), Color(0xFFFFB7C5), Color(0xFFF8A5C2)],
      textColor: Colors.white,
      buttonBg: _glass,
      buttonIconColor: _glassText,
      uiOverlayBg: _glass,
      uiOverlayFg: _glassText,
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      imageUrl: 'https://images.unsplash.com/photo-1522383225653-ed111181a951?w=800&fit=crop&q=80',
    ),

    // ── Minéral — roche et pierre ─────────────────────────────────────────
    CardVisualTheme.mineral: CardVisualThemeData(
      name: 'Minéral',
      gradientColors: [Color(0xFF232526), Color(0xFF414345), Color(0xFF2C2C2C)],
      textColor: Colors.white,
      buttonBg: _glass,
      buttonIconColor: _glassText,
      uiOverlayBg: _glass,
      uiOverlayFg: _glassText,
      imageUrl: 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=800&fit=crop&q=80',
    ),
  };

  CardVisualThemeData get data => _data[this]!;
}
