import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motivation_app/config/routes/app_router.dart';
import 'package:motivation_app/core/widgets/fade_slide_in.dart';
import 'package:motivation_app/features/onboarding/onboarding_flow.dart';
import 'package:motivation_app/features/onboarding/presentation/bloc/onboarding_cubit.dart';
import 'package:motivation_app/features/onboarding/presentation/bloc/onboarding_state.dart';
import 'package:motivation_app/features/onboarding/presentation/widgets/continue_button.dart';
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
      backgroundColor: Colors.black,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1A1A1A), Colors.black, Colors.black],
            stops: [0.0, 0.3, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ──────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FadeSlideIn(
                      child: ProgressIndicatorBar(
                        currentStep: progress.step,
                        totalSteps: progress.total,
                      ),
                    ),
                    const SizedBox(height: 28),
                    FadeSlideIn(
                      delay: const Duration(milliseconds: 80),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 350),
                        transitionBuilder: (child, anim) => FadeTransition(
                          opacity: anim,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0, 0.15),
                              end: Offset.zero,
                            ).animate(anim),
                            child: child,
                          ),
                        ),
                        child: Align(
                          key: ValueKey(isUnlocked),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            isUnlocked ? 'Tu as tout compris !' : "Essaie l'application",
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              height: 1.15,
                              letterSpacing: -1.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    FadeSlideIn(
                      delay: const Duration(milliseconds: 130),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: Align(
                          key: ValueKey(isUnlocked),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            isUnlocked
                                ? 'Tu es prêt à commencer ton parcours.'
                                : 'Swipe pour passer · ❤️ pour aimer (3 nécessaires)',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withValues(alpha: 0.35),
                              letterSpacing: -0.1,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // ── Hearts progress ──────────────────────────────────────────
              FadeSlideIn(
                delay: const Duration(milliseconds: 160),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: List.generate(3, (i) {
                      final filled = i < _likedCount;
                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: AnimatedScale(
                          scale: filled ? 1.2 : 1.0,
                          duration: const Duration(milliseconds: 350),
                          curve: Curves.elasticOut,
                          child: Icon(
                            filled ? Icons.favorite : Icons.favorite_border,
                            color: filled
                                ? Colors.red.shade400
                                : Colors.white.withValues(alpha: 0.2),
                            size: 26,
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // ── Card / Success area ──────────────────────────────────────
              Expanded(
                child: isUnlocked
                    ? FadeSlideIn(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 76,
                                height: 76,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF4CAF50).withValues(alpha: 0.12),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: const Color(0xFF4CAF50).withValues(alpha: 0.25),
                                  ),
                                ),
                                child: const Icon(
                                  Icons.check_rounded,
                                  color: Color(0xFF4CAF50),
                                  size: 38,
                                ),
                              ),
                              const SizedBox(height: 24),
                              const Text(
                                '3 / 3',
                                style: TextStyle(
                                  fontSize: 52,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  height: 1,
                                  letterSpacing: -2.5,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'affirmations aimées',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white.withValues(alpha: 0.4),
                                  letterSpacing: -0.2,
                                ),
                              ),
                            ],
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
                              translateY = _exitStartY - _exitCtrl.value * screenH * 0.6;
                              opacity = (1.0 - _exitCtrl.value * 1.8).clamp(0.0, 1.0);
                            } else {
                              translateY = _dragY + (1.0 - _enterCtrl.value) * 35;
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
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                child: FadeSlideIn(
                  delay: const Duration(milliseconds: 220),
                  child: ContinueButton(
                    label: isUnlocked ? 'Activer mes rappels' : 'Continuer',
                    enabled: isUnlocked,
                    onPressed: isUnlocked
                        ? () => OnboardingFlow.next(context, AppRouter.onboardingPreview)
                        : null,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Mock affirmation card ────────────────────────────────────────────────────

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
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Text(
            '"$text"',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
              height: 1.4,
              letterSpacing: -0.5,
              color: Colors.white,
            ),
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
                color: Colors.white.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.share_outlined,
                color: Colors.white.withValues(alpha: 0.45),
                size: 22,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ─── Heart button with bounce animation ──────────────────────────────────────

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
            color: widget.isLiked
                ? Colors.red.shade400.withValues(alpha: 0.15)
                : Colors.white.withValues(alpha: 0.08),
            shape: BoxShape.circle,
          ),
          child: Icon(
            widget.isLiked ? Icons.favorite : Icons.favorite_border,
            color: widget.isLiked
                ? Colors.red.shade400
                : Colors.white.withValues(alpha: 0.7),
            size: 22,
          ),
        ),
      ),
    );
  }
}
