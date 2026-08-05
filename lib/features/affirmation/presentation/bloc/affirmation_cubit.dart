import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:motivation_app/core/purchases/premium_content.dart';
import 'package:motivation_app/features/affirmation/domain/entities/affirmation.dart';
import 'package:motivation_app/features/affirmation/domain/entities/affirmation_category.dart';
import 'package:motivation_app/features/affirmation/domain/usecases/get_affirmation_by_id_usecase.dart';
import 'package:motivation_app/features/affirmation/domain/usecases/get_next_affirmation_usecase.dart';
import 'package:motivation_app/features/affirmation/domain/usecases/get_saved_categories_usecase.dart';
import 'package:motivation_app/features/affirmation/domain/usecases/mark_as_viewed_usecase.dart';
import 'package:motivation_app/features/affirmation/domain/usecases/save_categories_usecase.dart';
import 'package:motivation_app/features/affirmation/domain/usecases/toggle_favorite_usecase.dart';
import 'package:motivation_app/features/affirmation/presentation/bloc/affirmation_state.dart';

@injectable
class AffirmationCubit extends Cubit<AffirmationState> {
  final GetNextAffirmationUseCase getNextAffirmation;
  final GetAffirmationByIdUseCase getAffirmationById;
  final MarkAsViewedUseCase markAsViewed;
  final ToggleFavoriteUseCase toggleFavorite;
  final GetSavedCategoriesUseCase getSavedCategories;
  final SaveCategoriesUseCase saveCategories;

  // [] = toutes les catégories (pas de filtre)
  List<AffirmationCategory> _selectedCategories = [];
  List<AffirmationCategory> get selectedCategories => _selectedCategories;
  bool _categoriesRestored = false;

  // Statut premium : en gratuit, le tirage est borné aux catégories gratuites.
  bool _isPremium = false;
  void setPremium(bool value) => _isPremium = value;
  List<AffirmationCategory> get _effectiveCategories =>
      PremiumContent.effectiveCategories(_selectedCategories, _isPremium);

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
    required this.getAffirmationById,
    required this.markAsViewed,
    required this.toggleFavorite,
    required this.getSavedCategories,
    required this.saveCategories,
  }) : super(const AffirmationState.initial());

  // Point d'entrée depuis le ShellRoute : restaure les catégories puis charge la première carte
  Future<void> init() => loadNext();

  /// Ouvre une affirmation précise (ex: tap sur une notification), en
  /// contournant la file "prochaine non vue". Fallback sur loadNext() si
  /// l'affirmation n'existe plus (ex: supprimée entre-temps).
  Future<void> initById(int id) async {
    emit(const AffirmationState.loading());
    final result = await getAffirmationById(id);
    final fallback = result.isLeft();
    result.fold(
      (_) {},
      (affirmation) => emit(AffirmationState.loaded(
        affirmation: affirmation,
        selectedCategory: displayCategory,
      )),
    );
    if (fallback) await loadNext();
  }

  Future<void> loadNext() async {
    if (!_categoriesRestored) {
      _categoriesRestored = true;
      final result = await getSavedCategories();
      result.fold(
        (_) {},
        (categories) => _selectedCategories = categories,
      );
    }
    emit(const AffirmationState.loading());
    var result = await getNextAffirmation(categories: _effectiveCategories);
    if (result.isLeft()) {
      // DB possibly still populating — wait and retry once
      await Future.delayed(const Duration(seconds: 3));
      result = await getNextAffirmation(categories: _effectiveCategories);
    }
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
  Future<void> markCurrentAsViewed() async {
    final currentState = state;
    if (currentState is! AffirmationLoaded) return;

    _history.add(currentState.affirmation);
    if (_history.length > 20) _history.removeAt(0);

    if (_forward.isNotEmpty) {
      // L'utilisateur était revenu en arrière : on restitue la carte suivante
      final next = _forward.removeLast();
      emit(AffirmationState.loaded(
        affirmation: next,
        selectedCategory: displayCategory,
      ));
      return;
    }

    await markAsViewed(currentState.affirmation.id);
    final result = await getNextAffirmation(categories: _effectiveCategories);
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
    await saveCategories(categories);
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
    await saveCategories(_selectedCategories);
    await loadNext();
  }
}
