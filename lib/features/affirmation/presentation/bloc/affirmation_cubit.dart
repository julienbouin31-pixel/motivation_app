import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:motivation_app/features/affirmation/domain/entities/affirmation.dart';
import 'package:motivation_app/features/affirmation/domain/entities/affirmation_category.dart';
import 'package:motivation_app/features/affirmation/domain/usecases/get_next_affirmation_usecase.dart';
import 'package:motivation_app/features/affirmation/domain/usecases/mark_as_viewed_usecase.dart';
import 'package:motivation_app/features/affirmation/domain/usecases/toggle_favorite_usecase.dart';
import 'package:motivation_app/features/affirmation/presentation/bloc/affirmation_state.dart';

const _kSelectedCategoriesKey = 'affirmation_selected_categories';

class AffirmationCubit extends Cubit<AffirmationState> {
  final GetNextAffirmationUseCase getNextAffirmation;
  final MarkAsViewedUseCase markAsViewed;
  final ToggleFavoriteUseCase toggleFavorite;
  final FlutterSecureStorage _storage;

  // [] = toutes les catégories (pas de filtre)
  List<AffirmationCategory> _selectedCategories = [];
  List<AffirmationCategory> get selectedCategories => _selectedCategories;
  bool _categoriesRestored = false;

  // Historique des cartes vues (swipe haut) → permet le retour arrière (swipe bas)
  final List<Affirmation> _history = [];
  bool get canGoBack => _history.isNotEmpty;

  // Pile avant : cartes qu'on a quittées via goBack(), pour pouvoir les retrouver
  final List<Affirmation> _forward = [];

  // Catégorie d'affichage pour le bouton (unique représentant de la sélection)
  // [] = pas de filtre → affiche "Général" comme label par défaut
  AffirmationCategory get displayCategory {
    if (_selectedCategories.length == 1) return _selectedCategories.first;
    return AffirmationCategory.general;
  }

  AffirmationCubit({
    required this.getNextAffirmation,
    required this.markAsViewed,
    required this.toggleFavorite,
    required FlutterSecureStorage storage,
  })  : _storage = storage,
        super(const AffirmationState.initial());

  Future<void> loadNext() async {
    if (!_categoriesRestored) {
      _categoriesRestored = true;
      try {
        final saved = await _storage.read(key: _kSelectedCategoriesKey);
        if (saved != null && saved.isNotEmpty) {
          _selectedCategories = saved
              .split(',')
              .map((s) => AffirmationCategory.values
                  .where((c) => c.name == s)
                  .firstOrNull)
              .whereType<AffirmationCategory>()
              .toList();
        }
      } catch (_) {}
    }
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

  /// Applique directement une liste de catégories (depuis la page catégories).
  Future<void> setCategories(List<AffirmationCategory> categories) async {
    _history.clear();
    _forward.clear();
    _selectedCategories = categories;
    try {
      await _storage.write(
        key: _kSelectedCategoriesKey,
        value: _selectedCategories.map((c) => c.name).join(','),
      );
    } catch (_) {}
    await loadNext();
  }

  /// Coche / décoche une catégorie.
  /// - [] = toutes les catégories (pas de filtre)
  /// - Décocher la dernière → revient à [] (toutes)
  Future<void> toggleCategory(AffirmationCategory category) async {
    _history.clear();
    _forward.clear();
    if (_selectedCategories.contains(category)) {
      _selectedCategories =
          _selectedCategories.where((c) => c != category).toList();
    } else {
      final next = [..._selectedCategories, category];
      // Toutes sélectionnées = équivalent à aucun filtre
      _selectedCategories = next.length == AffirmationCategory.values.length
          ? []
          : next;
    }
    try {
      await _storage.write(
        key: _kSelectedCategoriesKey,
        value: _selectedCategories.map((c) => c.name).join(','),
      );
    } catch (_) {}
    await loadNext();
  }
}
