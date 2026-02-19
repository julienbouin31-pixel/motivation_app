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
  // Animation de sortie (swipe vers le haut)
  late final AnimationController _exitCtrl;
  // Animation d'entrée (nouvelle card)
  late final AnimationController _enterCtrl;

  double _dragY = 0;
  bool _isExiting = false;
  int? _exitingId;

  @override
  void initState() {
    super.initState();

    _exitCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );
    // Démarre à 1.0 → première card visible immédiatement
    _enterCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
      value: 1.0,
    );

    _exitCtrl.addStatusListener((status) {
      if (status == AnimationStatus.completed &&
          _exitingId != null &&
          mounted) {
        final id = _exitingId!;
        _exitingId = null;
        context.read<AffirmationCubit>().markCurrentAsViewed(id);
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
    if (d.delta.dy < 0) {
      setState(() => _dragY = (_dragY + d.delta.dy).clamp(-350.0, 0.0));
    }
  }

  void _onDragEnd(DragEndDetails d, int id) {
    if (_isExiting) return;
    final velocity = d.primaryVelocity ?? 0;
    if (_dragY < -60 || velocity < -500) {
      setState(() {
        _isExiting = true;
        _exitingId = id;
      });
      _exitCtrl.forward();
    } else {
      // Revenir en place
      setState(() => _dragY = 0);
    }
  }

  // Appelé quand une nouvelle affirmation arrive dans le BlocConsumer
  void _resetForNewCard() {
    setState(() {
      _dragY = 0;
      _isExiting = false;
    });
    _exitCtrl.reset();
    _enterCtrl.forward(from: 0);
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
              return prev.affirmation.id != next.affirmation.id;
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
                              // Glisse vers le haut + s'estompe
                              offset = Offset(
                                0,
                                _dragY - _exitCtrl.value * screenH,
                              );
                              opacity =
                                  (1.0 - _exitCtrl.value * 2)
                                      .clamp(0.0, 1.0);
                            } else {
                              // Arrive par le bas + s'illumine
                              offset = Offset(
                                0,
                                _dragY + (1 - _enterCtrl.value) * 40,
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
