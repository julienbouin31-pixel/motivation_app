import 'package:motivation_app/features/affirmation/domain/entities/affirmation.dart';
import 'package:motivation_app/features/affirmation/domain/entities/affirmation_category.dart';

class AffirmationModel {
  final int? id;
  final String text;
  final String category;
  final DateTime? lastViewedAt;
  final bool isFavorite;

  const AffirmationModel({
    this.id,
    required this.text,
    required this.category,
    this.lastViewedAt,
    this.isFavorite = false,
  });

  factory AffirmationModel.fromMap(Map<String, dynamic> map) {
    return AffirmationModel(
      text: map['text'] as String,
      category: map['category'] as String,
    );
  }

  Affirmation toEntity() => Affirmation(
        id: id ?? 0,
        text: text,
        category: AffirmationCategory.values.byName(category),
        lastViewedAt: lastViewedAt,
        isFavorite: isFavorite,
      );
}
