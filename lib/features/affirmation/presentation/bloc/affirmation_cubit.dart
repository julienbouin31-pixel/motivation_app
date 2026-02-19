import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motivation_app/features/affirmation/domain/entities/affirmation_category.dart';
import 'package:motivation_app/features/affirmation/domain/usecases/get_next_affirmation_usecase.dart';
import 'package:motivation_app/features/affirmation/domain/usecases/mark_as_viewed_usecase.dart';
import 'package:motivation_app/features/affirmation/domain/usecases/toggle_favorite_usecase.dart';
import 'package:motivation_app/features/affirmation/presentation/bloc/affirmation_state.dart';

class AffirmationCubit extends Cubit<AffirmationState> {
  final GetNextAffirmationUseCase getNextAffirmation;
  final MarkAsViewedUseCase markAsViewed;
  final ToggleFavoriteUseCase toggleFavorite;

  // Multi-sélection : [general] par défaut = toutes les catégories
  List<AffirmationCategory> _selectedCategories = [AffirmationCategory.general];
  List<AffirmationCategory> get selectedCategories => _selectedCategories;

  // Catégorie d'affichage pour le bouton (unique représentant de la sélection)
  AffirmationCategory get displayCategory {
    if (_selectedCategories.length == 1) return _selectedCategories.first;
    return AffirmationCategory.general;
  }

  AffirmationCubit({
    required this.getNextAffirmation,
    required this.markAsViewed,
    required this.toggleFavorite,
  }) : super(const AffirmationState.initial());

  Future<void> loadNext() async {
    emit(const AffirmationState.loading());
    final result = await getNextAffirmation(categories: _selectedCategories);
    result.fold(
      (_) => emit(
          const AffirmationState.error('Impossible de charger une affirmation')),
      (affirmation) => emit(AffirmationState.loaded(
        affirmation: affirmation,
        selectedCategory: displayCategory,
      )),
    );
  }

  Future<void> markCurrentAsViewed(int id) async {
    await markAsViewed(id);
    final result = await getNextAffirmation(categories: _selectedCategories);
    result.fold(
      (_) => emit(
          const AffirmationState.error('Impossible de charger une affirmation')),
      (affirmation) => emit(AffirmationState.loaded(
        affirmation: affirmation,
        selectedCategory: displayCategory,
      )),
    );
  }

  Future<void> toggleFavoriteAction(int id) async {
    final currentState = state;
    if (currentState is! AffirmationLoaded) return;
    await toggleFavorite(id);
    emit(AffirmationState.loaded(
      affirmation: currentState.affirmation.copyWith(
        isFavorite: !currentState.affirmation.isFavorite,
      ),
      selectedCategory: displayCategory,
    ));
  }

  /// Coche / décoche une catégorie.
  /// - Sélectionner "général" → efface tout le reste
  /// - Sélectionner une catégorie spécifique → retire "général"
  /// - Décocher la dernière → revient à "général"
  Future<void> toggleCategory(AffirmationCategory category) async {
    if (category == AffirmationCategory.general) {
      _selectedCategories = [AffirmationCategory.general];
    } else if (_selectedCategories.contains(category)) {
      final next = _selectedCategories.where((c) => c != category).toList();
      _selectedCategories =
          next.isEmpty ? [AffirmationCategory.general] : next;
    } else {
      _selectedCategories = [
        ..._selectedCategories.where((c) => c != AffirmationCategory.general),
        category,
      ];
    }
    await loadNext();
  }
}
