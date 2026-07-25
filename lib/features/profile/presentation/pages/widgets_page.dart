import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:motivation_app/config/themes/app_style.dart';

class WidgetsPage extends StatelessWidget {
  const WidgetsPage({super.key});

  static const _affirmationText = 'Chaque action me rapproche de mon objectif.';
  static const _category = 'focus';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.bg,
      body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ─── Header ──────────────────────────────────────────────────
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
                    Text('widgets', style: AppStyle.display(size: 30)),
                  ],
                ),
              ),

              // ─── Contenu ─────────────────────────────────────────────────
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
                  children: [
                    // ── Widget écran d'accueil ──────────────────────────────
                    const _SectionLabel('ÉCRAN D\'ACCUEIL'),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        SizedBox(
                          width: (MediaQuery.of(context).size.width - 40 - 24) / 2,
                          child: const _WidgetPreviewSquare(
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
                    const _InstructionsCard(
                      icon: Icons.home_rounded,
                      title: 'Ajouter sur l\'écran d\'accueil',
                      steps: [
                        'Appuie longuement sur l\'écran d\'accueil',
                        'Tape "+" en haut à gauche',
                        'Recherche "Motivation" dans la liste',
                        'Choisis le widget et appuie sur Ajouter',
                      ],
                    ),

                    const SizedBox(height: 32),

                    // ── Widget écran de verrouillage ────────────────────────
                    const _SectionLabel('ÉCRAN DE VERROUILLAGE'),
                    const SizedBox(height: 12),
                    const _WidgetPreviewLockScreen(
                      label: 'Affirmation  rectangulaire',
                      child: _AffirmationLockWidget(text: _affirmationText),
                    ),
                    const SizedBox(height: 10),
                    const _InstructionsCard(
                      icon: Icons.lock_outline_rounded,
                      title: 'Ajouter sur l\'écran de verrouillage',
                      steps: [
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
  const _SectionLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Text(label.toLowerCase(), style: AppStyle.overline);
  }
}

// ─── Instructions card ────────────────────────────────────────────────────────

class _InstructionsCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final List<String> steps;

  const _InstructionsCard({
    required this.icon,
    required this.title,
    required this.steps,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppStyle.hairline),
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
                  borderRadius: BorderRadius.circular(17),
                  border: Border.all(color: AppStyle.hairline),
                ),
                child: Icon(icon,
                    size: 16, color: AppStyle.ink.withValues(alpha: 0.7)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...steps.asMap().entries.map(
            (e) => _Step(number: '${e.key + 1}', text: e.value),
          ),
        ],
      ),
    );
  }
}

class _Step extends StatelessWidget {
  final String number;
  final String text;
  const _Step({required this.number, required this.text});

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
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Colors.white.withValues(alpha: 0.6),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13,
                color: Colors.white.withValues(alpha: 0.5),
                height: 1.4,
              ),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
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
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withValues(alpha: 0.4),
            fontWeight: FontWeight.w500,
          ),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
              const Text(
                '09:41',
                style: TextStyle(
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
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withValues(alpha: 0.4),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

// ─── Widget content views ─────────────────────────────────────────────────────

const _kBg = Color(0xFF121211);

class _AffirmationHomeWidget extends StatelessWidget {
  final String text;
  final String category;
  const _AffirmationHomeWidget({required this.text, required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _kBg,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Grand guillemet ocre en filigrane
          SizedBox(
            height: 24,
            child: ClipRect(
              child: OverflowBox(
                maxHeight: 60,
                alignment: Alignment.topLeft,
                child: Text(
                  '“',
                  style: GoogleFonts.urbanist(
                    fontSize: 52,
                    fontWeight: FontWeight.w600,
                    color: AppStyle.accent.withValues(alpha: 0.28),
                    height: 1,
                  ),
                ),
              ),
            ),
          ),
          const Spacer(),
          Text(
            text,
            style: AppStyle.display(size: 15).copyWith(height: 1.35),
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          Container(width: 34, height: 1, color: AppStyle.hairline),
          const SizedBox(height: 9),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 4,
                height: 4,
                decoration: const BoxDecoration(
                  color: AppStyle.accent,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  category.toUpperCase(),
                  style: AppStyle.overline.copyWith(
                    fontSize: 9,
                    letterSpacing: 2.4,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '“',
          style: GoogleFonts.urbanist(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white.withValues(alpha: 0.5),
            height: 1,
          ),
        ),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.urbanist(
              fontSize: 13,
              fontWeight: FontWeight.w300,
              color: Colors.white,
              height: 1.3,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
