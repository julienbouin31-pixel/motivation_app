import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:motivation_app/core/notifications/notification_service.dart';
import 'package:motivation_app/core/storage/secure_storage.dart';
import 'package:motivation_app/features/goal/domain/repositories/goal_repository.dart';
import 'package:motivation_app/features/goal/presentation/bloc/goal_state.dart';
import 'package:motivation_app/features/onboarding/domain/entities/user_profile.dart';

@lazySingleton
class GoalCubit extends Cubit<GoalState> {
  final GoalRepository _repository;
  final SecureStorage _storage;

  GoalCubit(this._repository, this._storage) : super(const GoalState.initial());

  Future<void> fetchGoal(UserProfile? profile) async {
    if (profile == null) return;
    final apiKey = profile.stripeApiKey;
    if (apiKey == null || apiKey.isEmpty) return;

    emit(const GoalState.loading());

    final result = await _repository.fetchGoalData(
      stripeApiKey: apiKey,
      target: profile.mrrTarget,
    );

    result.fold(
      (error) => emit(GoalState.error(error)),
      (data) async {
        emit(GoalState.loaded(data));

        if (data.current >= data.target) {
          final targetKey = data.target.toStringAsFixed(0);
          final alreadyNotified = await _storage.readGoalAchievedNotifiedTarget();
          if (alreadyNotified != targetKey) {
            await _storage.saveGoalAchievedNotifiedTarget(targetKey);
            await NotificationService.showNow(
              id: 8888,
              title: '🎯 Objectif dépassé !',
              body: 'Tu génères ${_fmt(data.current)} ce mois-ci. Relève la barre.',
            );
          }
        }
      },
    );
  }

  String _fmt(double amount) {
    if (amount >= 1000) {
      final k = amount / 1000;
      final r = (k * 10).round() / 10;
      return r == r.truncateToDouble() ? '${r.toInt()}K€' : '${r.toStringAsFixed(1)}K€';
    }
    return '${amount.toInt()}€';
  }
}
