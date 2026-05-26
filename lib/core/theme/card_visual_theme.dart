import 'package:flutter/material.dart';

enum CardVisualTheme {
  minimal,
  noir,
  rose,
  ciel,
  foret,
  sunset,
}

class CardVisualThemeData {
  final String name;
  final String emoji;
  final List<Color> gradientColors;
  final Color textColor;
  final Color buttonBg;
  final Color buttonIconColor;
  final AlignmentGeometry begin;
  final AlignmentGeometry end;

  const CardVisualThemeData({
    required this.name,
    required this.emoji,
    required this.gradientColors,
    required this.textColor,
    required this.buttonBg,
    required this.buttonIconColor,
    this.begin = Alignment.topCenter,
    this.end = Alignment.bottomCenter,
  });
}

extension CardVisualThemeExt on CardVisualTheme {
  static const Map<CardVisualTheme, CardVisualThemeData> _data = {
    CardVisualTheme.minimal: CardVisualThemeData(
      name: 'Minimal',
      emoji: '◻️',
      // gradientColors used for preview only; actual bg uses AppColors.card
      gradientColors: [Color(0xFFF8F6F1), Color(0xFFF0EDE7)],
      textColor: Color(0xFF1A1A1A),
      buttonBg: Color(0xFFEEEBE5),
      buttonIconColor: Color(0xFF888888),
    ),
    CardVisualTheme.noir: CardVisualThemeData(
      name: 'Noir',
      emoji: '⬛',
      gradientColors: [Color(0xFF0D0D0D), Color(0xFF1C1C1E)],
      textColor: Colors.white,
      buttonBg: Color(0xFF2A2A2A),
      buttonIconColor: Color(0xFFAAAAAA),
    ),
    CardVisualTheme.rose: CardVisualThemeData(
      name: 'Rose',
      emoji: '🌸',
      gradientColors: [Color(0xFFFF8FA3), Color(0xFFFF6B8A)],
      textColor: Colors.white,
      buttonBg: Color(0x33FFFFFF),
      buttonIconColor: Colors.white,
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    CardVisualTheme.ciel: CardVisualThemeData(
      name: 'Ciel',
      emoji: '☁️',
      gradientColors: [Color(0xFF74C0FC), Color(0xFF4DABF7)],
      textColor: Colors.white,
      buttonBg: Color(0x33FFFFFF),
      buttonIconColor: Colors.white,
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
    CardVisualTheme.foret: CardVisualThemeData(
      name: 'Forêt',
      emoji: '🌿',
      gradientColors: [Color(0xFF51CF66), Color(0xFF2F9E44)],
      textColor: Colors.white,
      buttonBg: Color(0x33FFFFFF),
      buttonIconColor: Colors.white,
    ),
    CardVisualTheme.sunset: CardVisualThemeData(
      name: 'Sunset',
      emoji: '🌅',
      gradientColors: [Color(0xFFFF922B), Color(0xFFE8590C)],
      textColor: Colors.white,
      buttonBg: Color(0x33FFFFFF),
      buttonIconColor: Colors.white,
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  };

  CardVisualThemeData get data => _data[this]!;

  bool get isAdaptive => this == CardVisualTheme.minimal;
}
