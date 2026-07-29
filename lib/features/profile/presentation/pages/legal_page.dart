import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:motivation_app/config/themes/app_style.dart';

enum LegalDoc { privacy, terms }

/// Écran affichant la politique de confidentialité ou les conditions
/// d'utilisation. Textes intégrés à l'app (aucun réseau requis).
///
/// ⚠️ Base honnête rédigée d'après ce que l'app collecte réellement, mais
/// PAS un document validé juridiquement. Les [placeholders] sont à compléter
/// (éditeur, email de contact, date), et une relecture par un pro est
/// recommandée avant publication.
class LegalPage extends StatelessWidget {
  final LegalDoc doc;
  const LegalPage({super.key, required this.doc});

  @override
  Widget build(BuildContext context) {
    final sections = doc == LegalDoc.privacy ? _privacy : _terms;
    final title = doc == LegalDoc.privacy ? 'confidentialité' : 'conditions';

    return Scaffold(
      backgroundColor: AppStyle.bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 12, 28, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    behavior: HitTestBehavior.opaque,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Icon(
                        Icons.arrow_back,
                        size: 22,
                        color: AppStyle.ink.withValues(alpha: 0.65),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(title, style: AppStyle.display(size: 30)),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(28, 8, 28, 40),
                children: [
                  Text(
                    'Dernière mise à jour : [JJ/MM/AAAA]',
                    style: const TextStyle(fontSize: 12, color: AppStyle.dim),
                  ),
                  const SizedBox(height: 24),
                  for (final s in sections) ...[
                    Text(s.$1.toUpperCase(), style: AppStyle.overline),
                    const SizedBox(height: 8),
                    Text(
                      s.$2,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.6,
                        color: AppStyle.ink.withValues(alpha: 0.75),
                      ),
                    ),
                    const SizedBox(height: 28),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Politique de confidentialité ───────────────────────────────────────────

const List<(String, String)> _privacy = [
  (
    'En bref',
    'Curves est une application de motivation personnelle. Nous limitons les '
        'données collectées à ce qui fait fonctionner l\'app, nous ne vendons '
        'rien à personne et nous n\'affichons aucune publicité. Cette page '
        'explique ce que nous collectons et pourquoi.',
  ),
  (
    'Éditeur',
    'L\'application Curves est éditée par [NOM DE L\'ÉDITEUR]. Pour toute '
        'question relative à tes données, tu peux nous écrire à [EMAIL DE '
        'CONTACT].',
  ),
  (
    'Données que nous collectons',
    'Les informations que tu fournis pendant l\'introduction : ton prénom, '
        'ton humeur et ton objectif. Le contenu que tu crées : tes '
        'affirmations personnelles et tes favoris. Ta progression : ta série '
        'de jours et tes jours actifs. Des données d\'usage minimales '
        '(ouverture de l\'app, affirmation consultée) pour faire fonctionner '
        'la synchronisation et la progression.\n\nNous n\'associons aucune de '
        'ces données à ton identité réelle : ton compte est anonyme, nous ne '
        'demandons ni email, ni numéro de téléphone, ni nom de famille.',
  ),
  (
    'Où sont stockées tes données',
    'Tes données sont d\'abord stockées localement sur ton appareil. Elles '
        'sont aussi synchronisées de façon chiffrée via Supabase, notre '
        'hébergeur de données, afin de te permettre de les retrouver. Un '
        'identifiant anonyme relie ton appareil à tes données.',
  ),
  (
    'Rapports de plantage',
    'Si l\'app rencontre une erreur, un rapport technique anonyme peut être '
        'envoyé à Sentry (notre outil de suivi des plantages) pour nous aider '
        'à corriger le problème. Ce rapport ne contient pas le contenu de tes '
        'affirmations.',
  ),
  (
    'Notifications',
    'Si tu les actives, l\'app programme des rappels localement sur ton '
        'appareil. Tu peux les désactiver à tout moment dans les réglages de '
        'l\'app ou de ton téléphone.',
  ),
  (
    'Conservation et suppression',
    'Tes données sont conservées tant que tu utilises l\'app. Tu peux les '
        'effacer à tout moment : la réinitialisation de l\'application efface '
        'les données locales, et tu peux nous contacter à [EMAIL DE CONTACT] '
        'pour demander la suppression complète de tes données synchronisées.',
  ),
  (
    'Tes droits',
    'Conformément au RGPD, tu disposes d\'un droit d\'accès, de rectification '
        'et de suppression de tes données, ainsi que d\'un droit d\'opposition '
        'et à la portabilité. Pour exercer ces droits, écris-nous à [EMAIL DE '
        'CONTACT].',
  ),
  (
    'Enfants',
    'Curves n\'est pas destinée aux personnes de moins de [ÂGE MINIMUM] ans. '
        'Nous ne collectons pas sciemment de données concernant des enfants.',
  ),
  (
    'Modifications',
    'Nous pouvons mettre à jour cette politique. En cas de changement '
        'important, nous t\'en informerons dans l\'application.',
  ),
];

// ─── Conditions d'utilisation ────────────────────────────────────────────────

const List<(String, String)> _terms = [
  (
    'Acceptation',
    'En utilisant Curves, tu acceptes les présentes conditions. Si tu ne les '
        'acceptes pas, n\'utilise pas l\'application.',
  ),
  (
    'Le service',
    'Curves te propose des affirmations de motivation, des rappels et un suivi '
        'de ta progression personnelle. Le service est fourni « en l\'état » '
        'et peut évoluer.',
  ),
  (
    'Bien-être, pas un avis médical',
    'Curves est un outil de motivation et de bien-être. Ce n\'est ni un '
        'service médical, ni un accompagnement psychologique ou thérapeutique. '
        'Le contenu ne remplace pas l\'avis d\'un professionnel de santé. Si tu '
        'traverses une période difficile, adresse-toi à un professionnel ou à '
        'un service d\'aide adapté.',
  ),
  (
    'Ton contenu',
    'Les affirmations personnelles que tu crées t\'appartiennent. Tu es '
        'responsable de ce que tu écris et t\'engages à ne pas y inclure de '
        'contenu illégal ou portant atteinte aux droits d\'autrui.',
  ),
  (
    'Utilisation acceptable',
    'Tu t\'engages à utiliser l\'app dans le respect de la loi et à ne pas '
        'tenter d\'en perturber le fonctionnement ni d\'accéder aux données '
        'd\'autres utilisateurs.',
  ),
  (
    'Propriété intellectuelle',
    'Hors ton contenu personnel, l\'application, son design et ses textes sont '
        'la propriété de [NOM DE L\'ÉDITEUR] et ne peuvent être réutilisés sans '
        'autorisation.',
  ),
  (
    'Responsabilité',
    'Dans les limites permises par la loi, [NOM DE L\'ÉDITEUR] ne saurait être '
        'tenu responsable des dommages indirects liés à l\'utilisation de '
        'l\'application.',
  ),
  (
    'Résiliation',
    'Tu peux cesser d\'utiliser l\'app et supprimer tes données à tout moment. '
        'Nous pouvons suspendre l\'accès en cas d\'usage abusif.',
  ),
  (
    'Droit applicable',
    'Les présentes conditions sont régies par le droit français. Pour toute '
        'question, écris-nous à [EMAIL DE CONTACT].',
  ),
];
