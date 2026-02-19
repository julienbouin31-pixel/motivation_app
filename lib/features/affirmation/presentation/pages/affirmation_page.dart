import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:motivation_app/config/routes/app_router.dart';
import 'package:motivation_app/features/affirmation/presentation/bloc/affirmation_cubit.dart';
import 'package:motivation_app/features/affirmation/presentation/bloc/affirmation_state.dart';
import 'package:motivation_app/features/affirmation/presentation/widgets/affirmation_card.dart';
import 'package:motivation_app/features/affirmation/presentation/widgets/affirmation_header.dart';
import 'package:motivation_app/features/affirmation/presentation/widgets/category_tabs.dart';
import 'package:motivation_app/features/affirmation/presentation/widgets/revenue_bar.dart';
import 'package:motivation_app/features/onboarding/presentation/bloc/onboarding_cubit.dart';
import 'package:motivation_app/features/onboarding/presentation/bloc/onboarding_state.dart';

class AffirmationPage extends StatefulWidget {
  const AffirmationPage({super.key});

  @override
  State<AffirmationPage> createState() => _AffirmationPageState();
}

class _AffirmationPageState extends State<AffirmationPage>
    with TickerProviderStateMixin {
  late final AnimationController _exitCtrl;
  late final AnimationController _enterCtrl;

  double _dragY = 0;
  bool _isExiting = false;
  bool _goingBack = false;   // true = swipe bas (retour), false = swipe haut (suivant)
  bool _enterFromTop = false; // direction de l'animation d'entrée
  int? _exitingId;
  bool _pendingGoBack = false; // swipe bas reçu pendant l'animation de sortie

  @override
  void initState() {
    super.initState();

    _exitCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );
    _enterCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
      value: 1.0, // Première carte visible immédiatement
    );

    _exitCtrl.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        if (_goingBack) {
          // Swipe bas → revenir à l'affirmation précédente
          context.read<AffirmationCubit>().goBack();
        } else if (_exitingId != null) {
          // Swipe haut → marquer comme vue + charger la suivante
          final id = _exitingId!;
          _exitingId = null;
          context.read<AffirmationCubit>().markCurrentAsViewed(id);
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

  void _onDragUpdate(DragUpdateDetails d) {
    if (_isExiting) return;
    final cubit = context.read<AffirmationCubit>();
    setState(() {
      final newY = _dragY + d.delta.dy;
      if (newY < 0) {
        // Glisse vers le haut (suivant)
        _dragY = newY.clamp(-350.0, 0.0);
      } else if (newY > 0 && cubit.canGoBack) {
        // Glisse vers le bas (retour) — seulement s'il y a un historique
        _dragY = newY.clamp(0.0, 350.0);
      } else {
        _dragY = 0;
      }
    });
  }

  void _onDragEnd(DragEndDetails d, int id) {
    final velocity = d.primaryVelocity ?? 0;
    if (_isExiting) {
      // Swipe bas pendant l'animation de sortie → mémoriser l'intention de retour
      if (velocity > 400 && context.read<AffirmationCubit>().canGoBack) {
        _pendingGoBack = true;
      }
      return;
    }
    final cubit = context.read<AffirmationCubit>();

    if (_dragY < -60 || velocity < -500) {
      // Swipe haut : affirmation suivante
      setState(() {
        _isExiting = true;
        _exitingId = id;
        _goingBack = false;
      });
      _exitCtrl.forward();
    } else if ((_dragY > 60 || velocity > 500) && cubit.canGoBack) {
      // Swipe bas : affirmation précédente
      setState(() {
        _isExiting = true;
        _goingBack = true;
      });
      _exitCtrl.forward();
    } else {
      // Seuil non atteint → revenir en place
      setState(() => _dragY = 0);
    }
  }

  // Appelé par le BlocConsumer quand une nouvelle affirmation (id différent) arrive
  void _resetForNewCard() {
    final goingBack = _goingBack;
    final pendingBack = _pendingGoBack;
    setState(() {
      _dragY = 0;
      _isExiting = false;
      _goingBack = false;
      _pendingGoBack = false;
      _enterFromTop = goingBack; // Retour = entrée par le haut
    });
    _exitCtrl.reset();

    if (pendingBack && context.read<AffirmationCubit>().canGoBack) {
      // L'utilisateur a swipé bas pendant l'animation de sortie → exécuter le retour maintenant
      setState(() {
        _isExiting = true;
        _goingBack = true;
      });
      _exitCtrl.forward();
    } else {
      _enterCtrl.forward(from: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final onboardingState = context.watch<OnboardingCubit>().state;
    final userName = switch (onboardingState) {
      OnboardingDataSaved(:final profile) => profile.name ?? 'toi',
      OnboardingProfileLoaded(:final profile) => profile.name ?? 'toi',
      _ => 'toi',
    };

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocConsumer<AffirmationCubit, AffirmationState>(
          // Se déclenche uniquement quand c'est une nouvelle affirmation (id différent)
          // Pas sur un simple toggle de isFavorite
          listenWhen: (prev, next) {
            if (prev is AffirmationLoaded && next is AffirmationLoaded) {
              if (prev.affirmation.id != next.affirmation.id) return true;
              // Même id : déclencher sauf si c'est juste un toggle favori
              // (ex : cycle épuisé → resetViewed → RANDOM() retourne la même carte)
              return prev.affirmation.isFavorite == next.affirmation.isFavorite;
            }
            return next is AffirmationLoaded;
          },
          listener: (context, state) => _resetForNewCard(),
          builder: (context, state) {
            final cubit = context.read<AffirmationCubit>();
            final selectedCategory = switch (state) {
              AffirmationLoaded(:final selectedCategory) => selectedCategory,
              _ => cubit.displayCategory,
            };

            return Column(
              children: [
                AffirmationHeader(userName: userName),
                const SizedBox(height: 8),
                Expanded(
                  child: switch (state) {
                    AffirmationInitial() => const SizedBox.shrink(),
                    AffirmationLoading() => const Center(
                        child:
                            CircularProgressIndicator(color: Colors.black),
                      ),
                    AffirmationLoaded(:final affirmation) => GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onVerticalDragUpdate: _onDragUpdate,
                        onVerticalDragEnd: (d) =>
                            _onDragEnd(d, affirmation.id),
                        child: AnimatedBuilder(
                          animation:
                              Listenable.merge([_exitCtrl, _enterCtrl]),
                          builder: (ctx, child) {
                            final screenH =
                                MediaQuery.of(ctx).size.height;
                            final Offset offset;
                            final double opacity;

                            if (_isExiting) {
                              // Swipe haut → sort par le haut
                              // Swipe bas → sort par le bas
                              final dir = _goingBack ? 1.0 : -1.0;
                              offset = Offset(
                                0,
                                _dragY + dir * _exitCtrl.value * screenH,
                              );
                              opacity = (1.0 - _exitCtrl.value * 2)
                                  .clamp(0.0, 1.0);
                            } else {
                              // Entrée depuis le bas (swipe haut) ou depuis le haut (retour)
                              final enterDir = _enterFromTop ? -1.0 : 1.0;
                              offset = Offset(
                                0,
                                _dragY +
                                    enterDir * (1 - _enterCtrl.value) * 40,
                              );
                              opacity = _enterCtrl.value;
                            }

                            return Opacity(
                              opacity: opacity,
                              child: Transform.translate(
                                offset: offset,
                                child: child,
                              ),
                            );
                          },
                          child: AffirmationCard(
                            affirmation: affirmation,
                            onFavorite: () =>
                                cubit.toggleFavoriteAction(affirmation.id),
                            onShare: () {},
                          ),
                        ),
                      ),
                    AffirmationError(:final message) => Center(
                        child: Text(message,
                            style:
                                const TextStyle(color: Colors.red)),
                      ),
                  },
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Row(
                    children: [
                      CategoryButton(
                        category: selectedCategory,
                        isOpen: false,
                        onTap: () =>
                            context.push(AppRouter.affirmationCategories),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () =>
                            context.push(AppRouter.affirmationFavorites),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.favorite,
                            color: Colors.red,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                RevenueBar(
                  currentRevenue: 0,
                  targetRevenue: 1000,
                  onTap: () => context.push(AppRouter.revenue),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
