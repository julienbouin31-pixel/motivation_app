import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:motivation_app/config/routes/app_router.dart';
import 'package:motivation_app/config/themes/app_theme.dart';
import 'package:motivation_app/core/database/app_database.dart';
import 'package:motivation_app/features/affirmation/data/datasources/affirmation_local_data_source.dart';
import 'package:motivation_app/features/affirmation/data/datasources/affirmation_seed.dart';
import 'package:motivation_app/features/affirmation/domain/repositories/affirmation_repository.dart';
import 'package:motivation_app/features/affirmation/presentation/bloc/affirmation_cubit.dart';
import 'package:motivation_app/features/home/presentation/bloc/home_cubit.dart';
import 'package:motivation_app/features/onboarding/presentation/bloc/onboarding_cubit.dart';
import 'package:motivation_app/injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final db = await openAppDatabase();

  const storage = FlutterSecureStorage();
  final objectiveType = await storage.read(key: 'onboarding_objective_type') ?? 'mrr';
  final mrrTarget = await storage.read(key: 'onboarding_mrr_target');
  final userName = await storage.read(key: 'onboarding_user_name');

  // ════════════════════════════════════════════════════════════
  // 🧪 DEBUG ONLY — supprimer avant la mise en production
  await db.delete(db.affirmationItems).go();
  await storage.delete(key: 'affirmation_last_fetch_date');
  print('❌ [DEBUG] BD vidée, last_fetch_date supprimée (onboarding conservé)');
  // ════════════════════════════════════════════════════════════

  // Peuple la DB localement avant runApp → pas de spinner au premier lancement
  await seedAffirmationsIfEmpty(db, name: userName, mrrTarget: mrrTarget);

  await di.init(
    db: db,
    objectiveType: objectiveType,
    mrrTarget: mrrTarget,
    userName: userName,
  );

  // ════════════════════════════════════════════════════════════
  // 🧪 DEBUG — état après seed
  final local = di.sl<AffirmationLocalDataSource>();
  final countAfterSeed = await local.totalCount();
  final dateAfterSeed = await storage.read(key: 'affirmation_last_fetch_date');
  print('❌ [DEBUG] Après seed    → $countAfterSeed affs en BD | last_fetch: ${dateAfterSeed ?? "aucune"}');
  // ════════════════════════════════════════════════════════════

  // Refresh hebdomadaire — awaité ici pour voir le résultat en debug
  await di.sl<AffirmationRepository>().weeklyRefreshInBackground();

  // ════════════════════════════════════════════════════════════
  // 🧪 DEBUG — état après refresh
  final countAfterRefresh = await local.totalCount();
  final dateAfterRefresh = await storage.read(key: 'affirmation_last_fetch_date');
  print('❌ [DEBUG] Après refresh → $countAfterRefresh affs en BD | last_fetch: ${dateAfterRefresh ?? "aucune"}');
  // ════════════════════════════════════════════════════════════

  final onboardingDone = userName != null;
  final router = createAppRouter(onboardingDone: onboardingDone);

  runApp(MyApp(router: router));
}

class MyApp extends StatelessWidget {
  final GoRouter router;

  const MyApp({super.key, required this.router});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<HomeCubit>()),
        BlocProvider(create: (_) => di.sl<OnboardingCubit>()),
        BlocProvider(create: (_) => di.sl<AffirmationCubit>()..loadNext()),
      ],
      child: MaterialApp.router(
        title: 'Motivation App',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        routerConfig: router,
      ),
    );
  }
}
