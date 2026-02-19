enum AffirmationCategory { general, mindset, action, focus, mrr }

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
      case AffirmationCategory.mrr:
        return 'MRR';
    }
  }
}
