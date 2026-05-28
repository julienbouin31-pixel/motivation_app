enum AffirmationCategory { general, mindset, action, focus, resilience, confidence, vision, custom }

extension AffirmationCategoryX on AffirmationCategory {
  String get label {
    switch (this) {
      case AffirmationCategory.general:
        return 'Général';
      case AffirmationCategory.mindset:
        return 'Mindset';
      case AffirmationCategory.action:
        return 'Action';
      case AffirmationCategory.focus:
        return 'Focus';
      case AffirmationCategory.resilience:
        return 'Résilience';
      case AffirmationCategory.confidence:
        return 'Confiance';
      case AffirmationCategory.vision:
        return 'Vision';
      case AffirmationCategory.custom:
        return 'Mes affirmations';
    }
  }
}
