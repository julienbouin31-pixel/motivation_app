import 'package:motivation_app/core/theme/card_visual_theme.dart';
import 'package:motivation_app/features/affirmation/domain/entities/affirmation_category.dart';

/// Périmètre de la version gratuite. Tout ce qui n'est pas listé ici est
/// réservé au premium. Un seul endroit à modifier pour ajuster le découpage.
class PremiumContent {
  PremiumContent._();

  /// Catégories d'affirmations accessibles gratuitement.
  static const Set<AffirmationCategory> freeCategories = {
    AffirmationCategory.general,
    AffirmationCategory.mindset,
    AffirmationCategory.focus,
    AffirmationCategory.custom, // créations perso : toujours accessibles
  };

  /// Thèmes de carte accessibles gratuitement (dont le défaut `pur`).
  static const Set<CardVisualTheme> freeThemes = {
    CardVisualTheme.pur,
    CardVisualTheme.charbon,
    CardVisualTheme.ocean,
  };

  static bool categoryLocked(AffirmationCategory c, bool isPremium) =>
      !isPremium && !freeCategories.contains(c);

  static bool themeLocked(CardVisualTheme t, bool isPremium) =>
      !isPremium && !freeThemes.contains(t);

  /// Catégories réellement servies au tirage selon le statut premium.
  /// En gratuit, on borne toujours au sous-ensemble gratuit (y compris le mode
  /// « toutes catégories », qui sinon exposerait le contenu premium).
  static List<AffirmationCategory> effectiveCategories(
    List<AffirmationCategory> selected,
    bool isPremium,
  ) {
    if (isPremium) return selected;
    if (selected.isEmpty) return freeCategories.toList();
    final filtered = selected.where(freeCategories.contains).toList();
    // Si la sélection ne pointait que vers du premium (ex: objectif mappé sur
    // une catégorie premium), on retombe sur le gratuit — jamais sur "tout".
    return filtered.isEmpty ? freeCategories.toList() : filtered;
  }
}
