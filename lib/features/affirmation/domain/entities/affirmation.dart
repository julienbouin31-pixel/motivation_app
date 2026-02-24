import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:motivation_app/features/affirmation/domain/entities/affirmation_category.dart';

part 'affirmation.freezed.dart';

@freezed
abstract class Affirmation with _$Affirmation {
  const factory Affirmation({
    required int id,
    required String text,
    required AffirmationCategory category,
    DateTime? lastViewedAt,
    @Default(false) bool isFavorite,
  }) = _Affirmation;
}
