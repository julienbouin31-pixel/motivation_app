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
    final objectiveType = profile.objectiveType;
    if (objectiveType == null || objectiveType == 'none') return;

    emit(const GoalState.loading());

    final result = await _repository.fetchGoalData(
      objectiveType: objectiveType,
      stripeApiKey: profile.stripeApiKey,
      target: profile.mrrTarget,
    );

    result.fold(
      (error) => emit(GoalState.error(error)),
      (data) async {
        emit(GoalState.loaded(data));

        // Notif "objectif atteint" — une seule fois par cible
        if (data.current >= data.target) {
          final targetKey = data.target.toStringAsFixed(0);
          final alreadyNotified = await _storage.readGoalAchievedNotifiedTarget();
          if (alreadyNotified != targetKey) {
            await _storage.saveGoalAchievedNotifiedTarget(targetKey);
            final currentLabel = data.objectiveType == 'mrr'
                ? _fmtRevenue(data.current)
                : _fmtCount(data.current);
            await NotificationService.showNow(
              id: 8888,
              title: '🎯 Objectif dépassé !',
              body: 'Tu génères $currentLabel ce mois-ci. Relève la barre.',
            );
          }
        }
      },
    );
  }

  String _fmtRevenue(double amount) {
    if (amount >= 1000) {
      final k = amount / 1000;
      final r = (k * 10).round() / 10;
      return r == r.truncateToDouble() ? '${r.toInt()}K€' : '${r.toStringAsFixed(1)}K€';
    }
    return '${amount.toInt()}€';
  }

  String _fmtCount(double count) {
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}K';
    return count.toInt().toString();
  }
}
