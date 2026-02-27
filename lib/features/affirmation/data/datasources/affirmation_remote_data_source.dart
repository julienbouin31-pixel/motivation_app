import 'package:injectable/injectable.dart';
import 'package:motivation_app/features/affirmation/data/models/affirmation_model.dart';

abstract class AffirmationRemoteDataSource {
  /// Retourne les nouvelles affirmations de la semaine.
  /// À remplacer par un vrai appel API — ne doit retourner que du contenu
  /// non encore présent en DB (la déduplication est faite côté repository).
  Future<List<AffirmationModel>> fetchAffirmations({
    required String objectiveType,
    String? mrrTarget,
    String? name,
    String? category,
  });
}

/// Mock — retourne 30 nouvelles affirmations fictives pour tester le refresh.
@LazySingleton(as: AffirmationRemoteDataSource)
class AffirmationRemoteDataSourceImpl implements AffirmationRemoteDataSource {
  @override
  Future<List<AffirmationModel>> fetchAffirmations({
    required String objectiveType,
    String? mrrTarget,
    String? name,
    String? category,
  }) async {
    // Les placeholders {name} et {target} sont stockés tels quels en DB.
    // La substitution se fait uniquement à l'affichage (AffirmationCard).
    final raw = [
      // Mindset — nouvelles
      {'text': '{name}, chaque matin est une nouvelle chance de progresser.', 'category': 'mindset'},
      {'text': 'Le doute est normal. L\'action est ce qui te distingue.', 'category': 'mindset'},
      {'text': 'Tu n\'as pas besoin d\'être parfait pour avancer.', 'category': 'mindset'},
      {'text': 'Les grands bâtisseurs ont tous connu des jours difficiles.', 'category': 'mindset'},
      {'text': 'Ton potentiel est illimité — c\'est ta croyance qui te limite.', 'category': 'mindset'},
      {'text': 'Compare-toi uniquement à qui tu étais hier.', 'category': 'mindset'},
      {'text': 'La résilience se forge dans l\'adversité.', 'category': 'mindset'},
      {'text': 'Tes pensées d\'aujourd\'hui façonnent ta réalité de demain.', 'category': 'mindset'},

      // Action — nouvelles
      {'text': 'Shipping beats perfection every time.', 'category': 'action'},
      {'text': 'Une heure de travail profond vaut quatre heures de procrastination.', 'category': 'action'},
      {'text': 'Pose une brique aujourd\'hui. Encore une demain. C\'est tout.', 'category': 'action'},
      {'text': 'Le momentum se crée en agissant, pas en attendant d\'être prêt.', 'category': 'action'},
      {'text': 'Envoie cet email. Publie ce post. Lance cette feature.', 'category': 'action'},
      {'text': 'Fait imparfait > non fait parfait.', 'category': 'action'},
      {'text': 'Chaque petite victoire d\'aujourd\'hui construit la grande de demain.', 'category': 'action'},
      {'text': '{name}, le meilleur moment pour agir c\'est maintenant.', 'category': 'action'},

      // Focus — nouvelles
      {'text': 'Une seule priorité par jour suffit pour avancer vite.', 'category': 'focus'},
      {'text': 'Les notifications sont les ennemies de ta concentration.', 'category': 'focus'},
      {'text': 'Travaille dans des blocs de temps protégés.', 'category': 'focus'},
      {'text': 'Le deep work est ton arme secrète.', 'category': 'focus'},
      {'text': 'Ferme les onglets. Ferme Slack. Ouvre juste l\'essentiel.', 'category': 'focus'},
      {'text': 'Qui contrôle son attention contrôle sa vie.', 'category': 'focus'},
      {'text': 'Identifie la tâche à fort levier et fais-la en premier.', 'category': 'focus'},

      // MRR — nouvelles
      {'text': 'Chaque client satisfait est un ambassadeur potentiel.', 'category': 'mrr'},
      {'text': '{name}, le MRR est la preuve que tu crées de la valeur réelle.', 'category': 'mrr'},
      {'text': 'Parle à tes clients aujourd\'hui — ils te diront où creuser.', 'category': 'mrr'},
      {'text': 'Réduis le churn et le MRR monte mécaniquement.', 'category': 'mrr'},
      {'text': '{target} est une étape, pas un plafond.', 'category': 'mrr'},
      {'text': 'Un abonnement signé aujourd\'hui génère des revenus pendant des mois.', 'category': 'mrr'},
      {'text': 'La régularité de ton effort crée la régularité de ton revenu.', 'category': 'mrr'},
    ];

    return raw.map((map) => AffirmationModel.fromMap(map)).toList();
  }
}
