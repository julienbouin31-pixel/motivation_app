import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:motivation_app/features/affirmation/presentation/widgets/affirmation_share_sheet.dart';
import 'package:motivation_app/config/routes/app_router.dart';
import 'package:motivation_app/features/affirmation/domain/entities/affirmation_category.dart';
import 'package:motivation_app/features/affirmation/presentation/bloc/affirmation_cubit.dart';
import 'package:motivation_app/features/affirmation/presentation/bloc/affirmation_state.dart';
import 'package:motivation_app/features/affirmation/presentation/widgets/affirmation_card.dart';
import 'package:motivation_app/features/affirmation/presentation/widgets/affirmation_header.dart';
import 'package:motivation_app/features/affirmation/presentation/widgets/category_tabs.dart';
import 'package:motivation_app/features/affirmation/presentation/widgets/revenue_bar.dart';
import 'package:motivation_app/config/themes/app_theme.dart';
import 'package:motivation_app/core/theme/card_theme_cubit.dart';
import 'package:motivation_app/core/theme/card_visual_theme.dart';
import 'package:motivation_app/core/widgets/home_widget_service.dart';
import 'package:motivation_app/features/goal/presentation/bloc/goal_cubit.dart';
import 'package:motivation_app/features/goal/presentation/bloc/goal_state.dart';
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
  bool _goingBack = false;
  bool _enterFromTop = false;
  bool _pendingGoBack = false;

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
      value: 1.0,
    );

    _exitCtrl.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        if (_goingBack) {
          context.read<AffirmationCubit>().goBack();
        } else {
          context.read<AffirmationCubit>().markCurrentAsViewed();
        }
      }
    });

    // Fetch goal data on page init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchGoalData();
    });
  }

  void _fetchGoalData() {
    final onboardingState = context.read<OnboardingCubit>().state;
    final profile = switch (onboardingState) {
      OnboardingDataSaved(:final profile) => profile,
      OnboardingProfileLoaded(:final profile) => profile,
      _ => null,
    };
    context.read<GoalCubit>().fetchGoal(profile);
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
        _dragY = newY.clamp(-350.0, 0.0);
      } else if (newY > 0 && cubit.canGoBack) {
        _dragY = newY.clamp(0.0, 350.0);
      } else {
        _dragY = 0;
      }
    });
  }

  void _onDragEnd(DragEndDetails d) {
    final velocity = d.primaryVelocity ?? 0;
    if (_isExiting) {
      if (velocity > 400 && context.read<AffirmationCubit>().canGoBack) {
        _pendingGoBack = true;
      }
      return;
    }
    final cubit = context.read<AffirmationCubit>();

    if (_dragY < -60 || velocity < -500) {
      setState(() {
        _isExiting = true;
        _goingBack = false;
      });
      _exitCtrl.forward();
    } else if ((_dragY > 60 || velocity > 500) && cubit.canGoBack) {
      setState(() {
        _isExiting = true;
        _goingBack = true;
      });
      _exitCtrl.forward();
    } else {
      setState(() => _dragY = 0);
    }
  }

  void _resetForNewCard() {
    final goingBack = _goingBack;
    final pendingBack = _pendingGoBack;
    setState(() {
      _dragY = 0;
      _isExiting = false;
      _goingBack = false;
      _pendingGoBack = false;
      _enterFromTop = goingBack;
    });
    _exitCtrl.reset();

    if (pendingBack && context.read<AffirmationCubit>().canGoBack) {
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
    final profile = switch (onboardingState) {
      OnboardingDataSaved(:final profile) => profile,
      OnboardingProfileLoaded(:final profile) => profile,
      _ => null,
    };
    final userName = profile?.name ?? 'toi';
    final mrrTarget = profile?.mrrTarget ?? '10K€';

    final colors = Theme.of(context).extension<AppColors>()!;
    final cardTheme = context.watch<CardThemeCubit>().state;
    final themeData = cardTheme.data;

    final body = Scaffold(
      backgroundColor: themeData.isAdaptive ? colors.card : Colors.transparent,
      body: SafeArea(
        child: BlocConsumer<AffirmationCubit, AffirmationState>(
          listenWhen: (prev, next) {
            if (prev is AffirmationLoaded && next is AffirmationLoaded) {
              if (prev.affirmation.id != next.affirmation.id) return true;
              return prev.affirmation.isFavorite == next.affirmation.isFavorite;
            }
            return next is AffirmationLoaded;
          },
          listener: (context, state) {
            _resetForNewCard();
            if (state is AffirmationLoaded) {
              final resolvedText = state.affirmation.text
                  .replaceAll('{name}', userName)
                  .replaceAll('{target}', mrrTarget);
              HomeWidgetService.updateAffirmation(
                text: resolvedText,
                category: state.affirmation.category.label.toLowerCase(),
              );
              // Update goal widget with real data from GoalCubit
              final goalState = context.read<GoalCubit>().state;
              if (goalState is GoalLoaded) {
                final data = goalState.data;
                HomeWidgetService.updateGoal(
                  current: data.current,
                  target: data.target,
                  changePct: data.changePct,
                );
              }
            }
          },
          builder: (context, state) {
            final cubit = context.read<AffirmationCubit>();
            final selectedCategory = switch (state) {
              AffirmationLoaded(:final selectedCategory) => selectedCategory,
              _ => cubit.displayCategory,
            };

            final themed = !themeData.isAdaptive;
            final uiBg = themed ? themeData.uiOverlayBg : null;
            final uiFg = themed ? themeData.uiOverlayFg : null;

            return Column(
              children: [
                AffirmationHeader(
                  userName: userName,
                  avatarBg: uiBg,
                  avatarFg: uiFg,
                ),
                Expanded(
                  child: switch (state) {
                    AffirmationInitial() => const SizedBox.shrink(),
                    AffirmationLoading() => Center(
                        child: CircularProgressIndicator(color: colors.primary),
                      ),
                    AffirmationLoaded(:final affirmation) => GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onVerticalDragUpdate: _onDragUpdate,
                        onVerticalDragEnd: _onDragEnd,
                        child: AnimatedBuilder(
                          animation:
                              Listenable.merge([_exitCtrl, _enterCtrl]),
                          builder: (ctx, child) {
                            final screenH =
                                MediaQuery.of(ctx).size.height;
                            final Offset offset;
                            final double opacity;

                            if (_isExiting) {
                              final dir = _goingBack ? 1.0 : -1.0;
                              offset = Offset(
                                0,
                                _dragY + dir * _exitCtrl.value * screenH,
                              );
                              opacity = (1.0 - _exitCtrl.value * 2)
                                  .clamp(0.0, 1.0);
                            } else {
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
                            userName: userName,
                            mrrTarget: mrrTarget,
                            textColor: themed ? themeData.textColor : null,
                            buttonBg: themed ? themeData.buttonBg : null,
                            buttonIconColor: themed ? themeData.buttonIconColor : null,
                            onFavorite: () =>
                                cubit.toggleFavoriteAction(affirmation.id),
                            onShare: () {
                              final text = affirmation.text
                                  .replaceAll('{name}', userName)
                                  .replaceAll('{target}', mrrTarget);
                              showAffirmationShareSheet(
                                context,
                                text: text,
                                category: affirmation.category.label,
                              );
                            },
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
                        colorOverride: uiBg,
                        iconColorOverride: uiFg,
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () =>
                            context.push(AppRouter.affirmationFavorites),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: uiBg ?? colors.surface,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.favorite,
                            color: themed
                                ? themeData.textColor.withValues(alpha: 0.8)
                                : Colors.red,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const GoalProgressBar(),
              ],
            );
          },
        ),
      ),
    );

    if (themeData.isAdaptive) return body;

    if (themeData.imageUrl != null) {
      return Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            themeData.imageUrl!,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: themeData.gradientColors,
                  begin: themeData.begin,
                  end: themeData.end,
                ),
              ),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0x99000000), Color(0x44000000), Color(0x77000000)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.0, 0.45, 1.0],
              ),
            ),
          ),
          body,
        ],
      );
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: themeData.gradientColors,
          begin: themeData.begin,
          end: themeData.end,
        ),
      ),
      child: body,
    );
  }
}
