import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:motivation_app/config/routes/app_router.dart';
import 'package:motivation_app/config/themes/app_theme.dart';
import 'package:motivation_app/core/database/app_database.dart';
import 'package:motivation_app/features/affirmation/data/datasources/affirmation_seed.dart';
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

  // Peuple la DB localement avant runApp → pas de spinner au premier lancement
  await seedAffirmationsIfEmpty(db, name: userName, mrrTarget: mrrTarget);

  await di.init(
    db: db,
    objectiveType: objectiveType,
    mrrTarget: mrrTarget,
    userName: userName,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
        routerConfig: appRouter,
      ),
    );
  }
}
