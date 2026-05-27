import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:motivation_app/config/themes/app_theme.dart';

class WidgetsPage extends StatelessWidget {
  const WidgetsPage({super.key});

  static const _affirmationText = 'Chaque action me rapproche de mon objectif.';
  static const _category = 'focus';

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Scaffold(
      backgroundColor: colors.scaffold,
      body: SafeArea(
        child: Column(
          children: [
            // ─── Header ──────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: colors.surface,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.arrow_back, size: 20, color: colors.primary),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Widgets',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: colors.primary,
                    ),
                  ),
                ],
              ),
            ),

            // ─── Contenu ─────────────────────────────────────────────────────
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
                children: [
                  // ── Widget écran d'accueil ─────────────────────────────────
                  _SectionLabel('ÉCRAN D\'ACCUEIL', colors),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      SizedBox(
                        width: (MediaQuery.of(context).size.width - 40 - 24) / 2,
                        child: _WidgetPreviewSquare(
                          label: 'Affirmation  2×2',
                          child: _AffirmationHomeWidget(
                            text: _affirmationText,
                            category: _category,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _InstructionsCard(
                    colors: colors,
                    icon: Icons.home_rounded,
                    title: 'Ajouter sur l\'écran d\'accueil',
                    steps: const [
                      'Appuie longuement sur l\'écran d\'accueil',
                      'Tape "+" en haut à gauche',
                      'Recherche "Motivation" dans la liste',
                      'Choisis le widget et appuie sur Ajouter',
                    ],
                  ),

                  const SizedBox(height: 32),

                  // ── Widget écran de verrouillage ───────────────────────────
                  _SectionLabel('ÉCRAN DE VERROUILLAGE', colors),
                  const SizedBox(height: 12),
                  _WidgetPreviewLockScreen(
                    label: 'Affirmation  rectangulaire',
                    child: _AffirmationLockWidget(text: _affirmationText),
                  ),
                  const SizedBox(height: 10),
                  _InstructionsCard(
                    colors: colors,
                    icon: Icons.lock_outline_rounded,
                    title: 'Ajouter sur l\'écran de verrouillage',
                    steps: const [
                      'Appuie longuement sur l\'écran de verrouillage',
                      'Tape "Personnaliser"',
                      'Sélectionne "Écran de verrouillage"',
                      'Tape la zone des widgets sous l\'heure',
                      'Recherche "Motivation" et ajoute le widget',
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Section label ────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String label;
  final AppColors colors;
  const _SectionLabel(this.label, this.colors);

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: colors.secondary,
        letterSpacing: 0.8,
      ),
    );
  }
}

// ─── Instructions card ────────────────────────────────────────────────────────

class _InstructionsCard extends StatelessWidget {
  final AppColors colors;
  final IconData icon;
  final String title;
  final List<String> steps;

  const _InstructionsCard({
    required this.colors,
    required this.icon,
    required this.title,
    required this.steps,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: colors.primary,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(icon, size: 18, color: colors.scaffold),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: colors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...steps.asMap().entries.map(
            (e) => _Step(number: '${e.key + 1}', text: e.value, colors: colors),
          ),
        ],
      ),
    );
  }
}

class _Step extends StatelessWidget {
  final String number;
  final String text;
  final AppColors colors;
  const _Step({required this.number, required this.text, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(color: colors.surface, shape: BoxShape.circle),
            child: Center(
              child: Text(
                number,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: colors.secondary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 13, color: colors.secondary, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Preview containers ───────────────────────────────────────────────────────

class _WidgetPreviewSquare extends StatelessWidget {
  final String label;
  final Widget child;
  const _WidgetPreviewSquare({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: colors.border),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(21),
              child: child,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: colors.secondary, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

class _WidgetPreviewLockScreen extends StatelessWidget {
  final String label;
  final Widget child;
  const _WidgetPreviewLockScreen({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Simule un écran de verrouillage iOS
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: const LinearGradient(
              colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Heure simulée
              Text(
                '09:41',
                style: const TextStyle(
                  fontSize: 56,
                  fontWeight: FontWeight.w200,
                  color: Colors.white,
                  letterSpacing: -2,
                ),
              ),
              Text(
                'Mercredi 21 mai',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white.withValues(alpha: 0.7),
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 20),
              // Zone widget
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.15),
                  ),
                ),
                child: child,
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: colors.secondary, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

// ─── Widget content views ─────────────────────────────────────────────────────

const _kBg = Color(0xFF161616);
const _kSecondary = Color(0x62FFFFFF);

class _AffirmationHomeWidget extends StatelessWidget {
  final String text;
  final String category;
  const _AffirmationHomeWidget({required this.text, required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _kBg,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '“',
            style: TextStyle(
              fontSize: 44,
              fontWeight: FontWeight.w900,
              color: Color(0x1EFFFFFF),
              height: 1,
            ),
          ),
          const Spacer(),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.white,
              height: 1.4,
            ),
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Text(
            '— $category',
            style: const TextStyle(fontSize: 10, color: _kSecondary),
          ),
        ],
      ),
    );
  }
}

class _AffirmationLockWidget extends StatelessWidget {
  final String text;
  const _AffirmationLockWidget({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: Colors.white,
        height: 1.4,
      ),
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }
}
