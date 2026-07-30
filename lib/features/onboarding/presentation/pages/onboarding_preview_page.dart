import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motivation_app/config/routes/app_router.dart';
import 'package:motivation_app/core/widgets/fade_slide_in.dart';
import 'package:motivation_app/features/onboarding/onboarding_flow.dart';
import 'package:motivation_app/features/onboarding/presentation/bloc/onboarding_cubit.dart';
import 'package:motivation_app/features/onboarding/presentation/bloc/onboarding_state.dart';
import 'package:motivation_app/features/onboarding/presentation/widgets/continue_button.dart';
import 'package:motivation_app/config/themes/app_style.dart';
import 'package:motivation_app/features/onboarding/presentation/widgets/progress_indicator_bar.dart';

const _mockTexts = [
  "Tu es capable d'accomplir tout ce que tu entreprends.",
  "Chaque matin est une nouvelle occasion de devenir une meilleure version de toi-même.",
  "Ta force intérieure est plus grande que n'importe quel obstacle.",
  "Tu mérites tout le bonheur que la vie a à t'offrir.",
  "Chaque pas en avant compte, même les plus petits.",
];

class OnboardingPreviewPage extends StatefulWidget {
  const OnboardingPreviewPage({super.key});

  @override
  State<OnboardingPreviewPage> createState() => _OnboardingPreviewPageState();
}

class _OnboardingPreviewPageState extends State<OnboardingPreviewPage>
    with TickerProviderStateMixin {
  int _likedCount = 0;
  int _currentIndex = 0;
  bool _isCardLiked = false;
  bool _isExiting = false;
  double _dragY = 0;
  double _exitStartY = 0;

  late final AnimationController _exitCtrl;
  late final AnimationController _enterCtrl;

  @override
  void initState() {
    super.initState();
    _exitCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _enterCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
      value: 1.0,
    );
    _exitCtrl.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        setState(() {
          _currentIndex = (_currentIndex + 1) % _mockTexts.length;
          _isCardLiked = false;
          _isExiting = false;
          _dragY = 0;
          _exitStartY = 0;
        });
        _exitCtrl.reset();
        if (_likedCount < 3) {
          _enterCtrl.forward(from: 0);
        }
      }
    });
  }

  @override
  void dispose() {
    _exitCtrl.dispose();
    _enterCtrl.dispose();
    super.dispose();
  }

  void _onLike() {
    if (_isCardLiked || _isExiting) return;
    HapticFeedback.mediumImpact();
    setState(() {
      _isCardLiked = true;
      _likedCount++;
      _dragY = 0;
    });
    Future.delayed(const Duration(milliseconds: 480), _triggerExit);
  }

  void _onDragUpdate(DragUpdateDetails d) {
    if (_isExiting || _isCardLiked) return;
    setState(() {
      _dragY = (_dragY + d.delta.dy).clamp(-350.0, 0.0);
    });
  }

  void _onDragEnd(DragEndDetails d) {
    if (_isExiting || _isCardLiked) return;
    final velocity = d.primaryVelocity ?? 0;
    if (_dragY < -60 || velocity < -500) {
      HapticFeedback.selectionClick();
      _triggerExit();
    } else {
      setState(() => _dragY = 0);
    }
  }

  void _triggerExit() {
    if (!mounted || _isExiting) return;
    setState(() {
      _exitStartY = _dragY;
      _isExiting = true;
    });
    _exitCtrl.forward();
  }

  @override
  Widget build(BuildContext context) {
    final progress = OnboardingFlow.progress(AppRouter.onboardingPreview);
    final onboardingState = context.watch<OnboardingCubit>().state;
    final profile = switch (onboardingState) {
      OnboardingDataSaved(:final profile) => profile,
      OnboardingProfileLoaded(:final profile) => profile,
      _ => null,
    };
    final name = profile?.name?.isNotEmpty == true ? profile!.name! : 'toi';
    final isUnlocked = _likedCount >= 3;
    final screenH = MediaQuery.of(context).size.height;
    final currentText = _mockTexts[_currentIndex].replaceAll('toi', name);

    return Scaffold(
      backgroundColor: AppStyle.bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 20, 28, 0),
              child: FadeSlideIn(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProgressIndicatorBar(
                      currentStep: progress.step,
                      totalSteps: progress.total,
                    ),
                    const SizedBox(height: 32),
                    Text(
                      isUnlocked ? 'c\'est exactement ça.' : 'à toi d\'essayer.',
                      style: AppStyle.display(size: 30),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      isUnlocked
                          ? 'Tu viens de garder tes trois premières affirmations.'
                          : 'Balaie vers le haut pour passer.\nAppuie sur le cœur pour en garder trois.',
                      style: AppStyle.body.copyWith(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ── Compteur ─────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Row(
                children: [
                  for (int i = 0; i < 3; i++)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: AnimatedScale(
                        scale: i < _likedCount ? 1.15 : 1.0,
                        duration: const Duration(milliseconds: 350),
                        curve: Curves.elasticOut,
                        child: Icon(
                          i < _likedCount
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: i < _likedCount
                              ? Colors.red.shade400
                              : AppStyle.ink.withValues(alpha: 0.18),
                          size: 20,
                        ),
                      ),
                    ),
                  const SizedBox(width: 6),
                  Text('$_likedCount sur 3', style: AppStyle.overline),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── Carte / état final ───────────────────────────────────────
            Expanded(
              child: isUnlocked
                  ? FadeSlideIn(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Text(
                            'voilà. c\'est aussi simple\nque ça, chaque matin.',
                            textAlign: TextAlign.center,
                            style: AppStyle.displayItalic(size: 26)
                                .copyWith(color: AppStyle.ink.withValues(alpha: 0.8)),
                          ),
                        ),
                      ),
                    )
                  : GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onVerticalDragUpdate: _onDragUpdate,
                      onVerticalDragEnd: _onDragEnd,
                      child: AnimatedBuilder(
                        animation: Listenable.merge([_exitCtrl, _enterCtrl]),
                        builder: (ctx, _) {
                          double translateY;
                          double opacity;

                          if (_isExiting) {
                            translateY =
                                _exitStartY - _exitCtrl.value * screenH * 0.6;
                            opacity =
                                (1.0 - _exitCtrl.value * 1.8).clamp(0.0, 1.0);
                          } else {
                            translateY =
                                _dragY + (1.0 - _enterCtrl.value) * 35;
                            opacity = _enterCtrl.value;
                          }

                          return Opacity(
                            opacity: opacity,
                            child: Transform.translate(
                              offset: Offset(0, translateY),
                              child: _MockCard(
                                text: currentText,
                                isLiked: _isCardLiked,
                                onLike: _onLike,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ),

            // ── CTA ──────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 0, 28, 32),
              child: ContinueButton(
                label: 'continuer',
                enabled: isUnlocked,
                onPressed: isUnlocked
                    ? () => OnboardingFlow.next(
                        context, AppRouter.onboardingPreview)
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Carte d'affirmation (copie de l'app) ────────────────────────────────────

class _MockCard extends StatelessWidget {
  final String text;
  final bool isLiked;
  final VoidCallback onLike;

  const _MockCard({
    required this.text,
    required this.isLiked,
    required this.onLike,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 36),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: AppStyle.display(size: 24).copyWith(height: 1.45),
          ),
        ),
        const SizedBox(height: 36),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _HeartButton(isLiked: isLiked, onTap: onLike),
            const SizedBox(width: 16),
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppStyle.hairline),
              ),
              child: Icon(
                Icons.share_outlined,
                color: AppStyle.ink.withValues(alpha: 0.4),
                size: 20,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ─── Bouton cœur avec rebond ─────────────────────────────────────────────────

class _HeartButton extends StatefulWidget {
  final bool isLiked;
  final VoidCallback onTap;

  const _HeartButton({required this.isLiked, required this.onTap});

  @override
  State<_HeartButton> createState() => _HeartButtonState();
}

class _HeartButtonState extends State<_HeartButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _scale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 1.45)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.45, end: 0.88)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.88, end: 1.0)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 30,
      ),
    ]).animate(_ctrl);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _handleTap() {
    _ctrl.forward(from: 0);
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.isLiked
                ? Colors.red.shade400.withValues(alpha: 0.12)
                : Colors.transparent,
            border: Border.all(
              color: widget.isLiked
                  ? Colors.red.shade400.withValues(alpha: 0.5)
                  : AppStyle.hairline,
            ),
          ),
          child: Icon(
            widget.isLiked ? Icons.favorite : Icons.favorite_border,
            color: widget.isLiked
                ? Colors.red.shade400
                : AppStyle.ink.withValues(alpha: 0.65),
            size: 22,
          ),
        ),
      ),
    );
  }
}
