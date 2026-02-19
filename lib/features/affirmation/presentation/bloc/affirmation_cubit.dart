import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motivation_app/features/affirmation/domain/entities/affirmation.dart';
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

  // Historique des cartes vues (swipe haut) → permet le retour arrière (swipe bas)
  final List<Affirmation> _history = [];
  bool get canGoBack => _history.isNotEmpty;

  // Pile avant : cartes qu'on a quittées via goBack(), pour pouvoir les retrouver
  final List<Affirmation> _forward = [];

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

  /// Swipe haut : pousse dans l'historique, restaure depuis _forward si possible,
  /// sinon marque comme vue et charge la suivante.
  Future<void> markCurrentAsViewed(int id) async {
    final currentState = state;
    if (currentState is AffirmationLoaded) {
      _history.add(currentState.affirmation);
      if (_history.length > 20) _history.removeAt(0);
    }

    if (_forward.isNotEmpty) {
      // L'utilisateur était revenu en arrière : on restitue la carte suivante
      final next = _forward.removeLast();
      emit(AffirmationState.loaded(
        affirmation: next,
        selectedCategory: displayCategory,
      ));
      return;
    }

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

  /// Swipe bas : revient à l'affirmation précédente depuis l'historique.
  void goBack() {
    if (_history.isEmpty) return;
    final currentState = state;
    if (currentState is AffirmationLoaded) {
      _forward.add(currentState.affirmation);
    }
    final prev = _history.removeLast();
    emit(AffirmationState.loaded(
      affirmation: prev,
      selectedCategory: displayCategory,
    ));
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
    _history.clear();
    _forward.clear(); // L'historique ne fait plus sens si on change de catégorie
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
