import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:motivation_app/features/affirmation/presentation/bloc/affirmation_cubit.dart';
import 'package:motivation_app/features/affirmation/presentation/pages/affirmation_page.dart';
import 'package:motivation_app/features/affirmation/presentation/pages/category_page.dart';
import 'package:motivation_app/features/affirmation/presentation/pages/custom_affirmations_page.dart';
import 'package:motivation_app/features/affirmation/presentation/pages/favorites_page.dart';
import 'package:motivation_app/features/onboarding/presentation/pages/onboarding_goal_page.dart';
import 'package:motivation_app/features/onboarding/presentation/pages/onboarding_mood_page.dart';
import 'package:motivation_app/features/onboarding/presentation/pages/onboarding_name_page.dart';
import 'package:motivation_app/features/onboarding/presentation/pages/onboarding_preview_page.dart';
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
  static const String onboardingGoal = '/onboarding/goal';
  static const String onboardingName = '/onboarding/name';
  static const String onboardingTransition = '/onboarding/transition';
  static const String onboardingPreview = '/onboarding/preview';
  static const String onboardingNotifications = '/onboarding/notifications';
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
      path: AppRouter.onboardingPreview,
      pageBuilder: (context, state) => const MaterialPage(
        child: OnboardingPreviewPage(),
      ),
    ),
    GoRoute(
      path: AppRouter.onboardingNotifications,
      pageBuilder: (context, state) => const MaterialPage(
        child: OnboardingNotificationPage(),
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
