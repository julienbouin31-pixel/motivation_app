import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:motivation_app/features/affirmation/presentation/bloc/affirmation_cubit.dart';
import 'package:motivation_app/features/home/presentation/pages/home_page.dart';
import 'package:motivation_app/features/onboarding/presentation/pages/onboarding_name_page.dart';
import 'package:motivation_app/features/onboarding/presentation/pages/onboarding_age_page.dart';
import 'package:motivation_app/features/onboarding/presentation/pages/onboarding_transition_page.dart';
import 'package:motivation_app/features/onboarding/presentation/pages/onboarding_objective_page.dart';
import 'package:motivation_app/features/onboarding/presentation/pages/onboarding_stripe_page.dart';
import 'package:motivation_app/features/onboarding/presentation/pages/onboarding_stripe_connected_page.dart';
import 'package:motivation_app/features/onboarding/presentation/pages/onboarding_mrr_target_page.dart';
import 'package:motivation_app/features/affirmation/presentation/pages/affirmation_page.dart';
import 'package:motivation_app/features/affirmation/presentation/pages/category_page.dart';
import 'package:motivation_app/features/affirmation/presentation/pages/favorites_page.dart';
import 'package:motivation_app/injection_container.dart' as di;

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  static const String home = '/';
  static const String onboardingName = '/onboarding/name';
  static const String onboardingTransition = '/onboarding/transition';
  static const String onboardingAge = '/onboarding/age';
  static const String onboardingObjective = '/onboarding/objective';
  static const String onboardingStripe = '/onboarding/stripe';
  static const String onboardingStripeConnected = '/onboarding/stripe-connected';
  static const String onboardingMrrTarget = '/onboarding/mrr-target';
  static const String affirmation = '/affirmation';
  static const String affirmationCategories = '/affirmation/categories';
  static const String affirmationFavorites = '/affirmation/favorites';
  static const String revenue = '/revenue';
}

GoRouter createAppRouter({required bool onboardingDone}) => GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: onboardingDone ? AppRouter.affirmation : AppRouter.home,
  routes: [
    GoRoute(
      path: AppRouter.home,
      pageBuilder: (context, state) => const NoTransitionPage(
        child: HomePage(),
      ),
    ),
    // ─── Onboarding — routes plates, OnboardingCubit est global ─────────────
    GoRoute(
      path: AppRouter.onboardingName,
      pageBuilder: (context, state) => const MaterialPage(
        child: OnboardingNamePage(),
      ),
    ),
    GoRoute(
      path: AppRouter.onboardingTransition,
      pageBuilder: (context, state) => const MaterialPage(
        child: OnboardingTransitionPage(),
      ),
    ),
    GoRoute(
      path: AppRouter.onboardingAge,
      pageBuilder: (context, state) => const MaterialPage(
        child: OnboardingAgePage(),
      ),
    ),
    GoRoute(
      path: AppRouter.onboardingObjective,
      pageBuilder: (context, state) => const MaterialPage(
        child: OnboardingObjectivePage(),
      ),
    ),
    GoRoute(
      path: AppRouter.onboardingStripe,
      pageBuilder: (context, state) => const MaterialPage(
        child: OnboardingStripePage(),
      ),
    ),
    GoRoute(
      path: AppRouter.onboardingStripeConnected,
      pageBuilder: (context, state) => const MaterialPage(
        child: OnboardingStripeConnectedPage(),
      ),
    ),
    GoRoute(
      path: AppRouter.onboardingMrrTarget,
      pageBuilder: (context, state) => const MaterialPage(
        child: OnboardingMrrTargetPage(),
      ),
    ),
    // ─── Affirmation — ShellRoute scopant AffirmationCubit ──────────────────
    ShellRoute(
      builder: (context, state, child) => BlocProvider(
        create: (_) => di.sl<AffirmationCubit>()..init(),
        child: child,
      ),
      routes: [
        GoRoute(
          path: AppRouter.affirmation,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: AffirmationPage(),
          ),
        ),
        GoRoute(
          path: AppRouter.affirmationCategories,
          pageBuilder: (context, state) => const MaterialPage(
            child: CategoryPage(),
          ),
        ),
        GoRoute(
          path: AppRouter.affirmationFavorites,
          pageBuilder: (context, state) => const MaterialPage(
            child: FavoritesPage(),
          ),
        ),
      ],
    ),
  ],
);
