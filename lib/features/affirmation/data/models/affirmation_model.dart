import 'package:motivation_app/features/affirmation/domain/entities/affirmation.dart';
import 'package:motivation_app/features/affirmation/domain/entities/affirmation_category.dart';

class AffirmationModel {
  final int? id;
  final String text;
  final String category;
  final DateTime? lastViewedAt;
  final DateTime? createdAt;
  final bool isFavorite;

  // Personnalisation
  final String tone; // direct | doux | poetique | percutant
  final List<String> themes; // domaines de vie (vide = universel)

  const AffirmationModel({
    this.id,
    required this.text,
    required this.category,
    this.lastViewedAt,
    this.createdAt,
    this.isFavorite = false,
    this.tone = 'doux',
    this.themes = const [],
  });

  factory AffirmationModel.fromMap(Map<String, dynamic> map) {
    final rawThemes = map['themes'];
    return AffirmationModel(
      text: map['text'] as String,
      category: map['category'] as String,
      tone: (map['tone'] as String?) ?? 'doux',
      themes: rawThemes is List
          ? rawThemes.map((e) => e.toString()).toList()
          : const [],
    );
  }

  Affirmation toEntity() => Affirmation(
        id: id ?? 0,
        text: text,
        category: AffirmationCategory.values.byName(category),
        lastViewedAt: lastViewedAt,
        createdAt: createdAt,
        isFavorite: isFavorite,
      );
}
