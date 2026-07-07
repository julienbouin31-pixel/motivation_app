import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:motivation_app/features/affirmation/presentation/bloc/affirmation_cubit.dart';
import 'package:motivation_app/features/affirmation/presentation/pages/affirmation_page.dart';
import 'package:motivation_app/features/affirmation/presentation/pages/category_page.dart';
import 'package:motivation_app/features/affirmation/presentation/pages/custom_affirmations_page.dart';
import 'package:motivation_app/features/affirmation/presentation/pages/favorites_page.dart';
import 'package:motivation_app/features/onboarding/presentation/pages/onboarding_belief_page.dart';
import 'package:motivation_app/features/onboarding/presentation/pages/onboarding_goal_page.dart';
import 'package:motivation_app/features/onboarding/presentation/pages/onboarding_mood_page.dart';
import 'package:motivation_app/features/onboarding/presentation/pages/onboarding_mood_source_page.dart';
import 'package:motivation_app/features/onboarding/presentation/pages/onboarding_name_page.dart';
import 'package:motivation_app/features/onboarding/presentation/pages/onboarding_preview_page.dart';
import 'package:motivation_app/features/onboarding/presentation/pages/onboarding_ready_page.dart';
import 'package:motivation_app/features/onboarding/presentation/pages/onboarding_science_page.dart';
import 'package:motivation_app/features/onboarding/presentation/pages/onboarding_streak_page.dart';
import 'package:motivation_app/features/onboarding/presentation/pages/onboarding_struggle_page.dart';
import 'package:motivation_app/features/onboarding/presentation/pages/onboarding_theme_page.dart';
import 'package:motivation_app/features/onboarding/presentation/pages/onboarding_tone_page.dart';
import 'package:motivation_app/features/onboarding/presentation/pages/onboarding_transition_page.dart';
import 'package:motivation_app/features/onboarding/presentation/pages/onboarding_welcome_page.dart';
import 'package:motivation_app/features/profile/presentation/pages/appearance_page.dart';
import 'package:motivation_app/features/profile/presentation/pages/edit_profile_page.dart';
import 'package:motivation_app/features/profile/presentation/pages/profile_page.dart';
import 'package:motivation_app/features/onboarding/presentation/pages/onboarding_notification_page.dart';
import 'package:motivation_app/features/profile/presentation/pages/notification_page.dart';
import 'package:motivation_app/features/profile/presentation/pages/widgets_page.dart';
import 'package:motivation_app/injection_container.dart' as di;

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  static const String onboardingWelcome = '/onboarding/welcome';
  static const String onboardingMood = '/onboarding/mood';
  static const String onboardingMoodSource = '/onboarding/mood-source';
  static const String onboardingBelief = '/onboarding/belief';
  static const String onboardingScience = '/onboarding/science';
  static const String onboardingGoal = '/onboarding/goal';
  static const String onboardingStruggle = '/onboarding/struggle';
  static const String onboardingTone = '/onboarding/tone';
  static const String onboardingName = '/onboarding/name';
  static const String onboardingTransition = '/onboarding/transition';
  static const String onboardingPreview = '/onboarding/preview';
  static const String onboardingTheme = '/onboarding/theme';
  static const String onboardingStreak = '/onboarding/streak';
  static const String onboardingNotifications = '/onboarding/notifications';
  static const String onboardingReady = '/onboarding/ready';
  static const String affirmation = '/affirmation';
  static const String affirmationCategories = '/affirmation/categories';
  static const String affirmationFavorites = '/affirmation/favorites';
  static const String affirmationCustom = '/affirmation/custom';
  static const String profile = '/profile';
  static const String editProfile = '/profile/edit';
  static const String appearance = '/profile/appearance';
  static const String widgets = '/profile/widgets';
  static const String notifications = '/profile/notifications';
}

/// [initialLocation] est calculé dans main.dart selon le profil chargé.
GoRouter createAppRouter({required String initialLocation}) => GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: initialLocation,
  routes: [
    // ─── Onboarding — routes plates, OnboardingCubit est global ─────────────
    GoRoute(
      path: AppRouter.onboardingWelcome,
      pageBuilder: (context, state) => const MaterialPage(
        child: OnboardingWelcomePage(),
      ),
    ),
    GoRoute(
      path: AppRouter.onboardingMood,
      pageBuilder: (context, state) => const MaterialPage(
        child: OnboardingMoodPage(),
      ),
    ),
    GoRoute(
      path: AppRouter.onboardingGoal,
      pageBuilder: (context, state) => const MaterialPage(
        child: OnboardingGoalPage(),
      ),
    ),
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
      path: AppRouter.onboardingMoodSource,
      pageBuilder: (context, state) => const MaterialPage(
        child: OnboardingMoodSourcePage(),
      ),
    ),
    GoRoute(
      path: AppRouter.onboardingBelief,
      pageBuilder: (context, state) => const MaterialPage(
        child: OnboardingBeliefPage(),
      ),
    ),
    GoRoute(
      path: AppRouter.onboardingScience,
      pageBuilder: (context, state) => const MaterialPage(
        child: OnboardingSciencePage(),
      ),
    ),
    GoRoute(
      path: AppRouter.onboardingStruggle,
      pageBuilder: (context, state) => const MaterialPage(
        child: OnboardingStrugglePage(),
      ),
    ),
    GoRoute(
      path: AppRouter.onboardingTone,
      pageBuilder: (context, state) => const MaterialPage(
        child: OnboardingTonePage(),
      ),
    ),
    GoRoute(
      path: AppRouter.onboardingPreview,
      pageBuilder: (context, state) => const MaterialPage(
        child: OnboardingPreviewPage(),
      ),
    ),
    GoRoute(
      path: AppRouter.onboardingTheme,
      pageBuilder: (context, state) => const MaterialPage(
        child: OnboardingThemePage(),
      ),
    ),
    GoRoute(
      path: AppRouter.onboardingStreak,
      pageBuilder: (context, state) => const MaterialPage(
        child: OnboardingStreakPage(),
      ),
    ),
    GoRoute(
      path: AppRouter.onboardingNotifications,
      pageBuilder: (context, state) => const MaterialPage(
        child: OnboardingNotificationPage(),
      ),
    ),
    GoRoute(
      path: AppRouter.onboardingReady,
      pageBuilder: (context, state) => const MaterialPage(
        child: OnboardingReadyPage(),
      ),
    ),
    // ─── Profil / Paramètres ─────────────────────────────────────────────────
    GoRoute(
      path: AppRouter.profile,
      pageBuilder: (context, state) => const MaterialPage(
        child: ProfilePage(),
      ),
    ),
    GoRoute(
      path: AppRouter.editProfile,
      pageBuilder: (context, state) => const MaterialPage(
        child: EditProfilePage(),
      ),
    ),
    GoRoute(
      path: AppRouter.appearance,
      pageBuilder: (context, state) => const MaterialPage(
        child: AppearancePage(),
      ),
    ),
    GoRoute(
      path: AppRouter.widgets,
      pageBuilder: (context, state) => const MaterialPage(
        child: WidgetsPage(),
      ),
    ),
    GoRoute(
      path: AppRouter.notifications,
      pageBuilder: (context, state) => const MaterialPage(
        child: NotificationPage(),
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
      ],
    ),
    GoRoute(
      path: AppRouter.affirmationFavorites,
      pageBuilder: (context, state) => const MaterialPage(
        child: FavoritesPage(),
      ),
    ),
    GoRoute(
      path: AppRouter.affirmationCustom,
      pageBuilder: (context, state) => const MaterialPage(
        child: CustomAffirmationsPage(),
      ),
    ),
  ],
);
