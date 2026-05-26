import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:motivation_app/features/goal/data/datasources/stripe_remote_data_source.dart';
import 'package:motivation_app/features/goal/domain/entities/goal_data.dart';
import 'package:motivation_app/features/goal/domain/repositories/goal_repository.dart';

@LazySingleton(as: GoalRepository)
class GoalRepositoryImpl implements GoalRepository {
  final StripeRemoteDataSource _stripe;

  GoalRepositoryImpl(this._stripe);

  @override
  Future<Either<String, GoalData>> fetchGoalData({
    String? stripeApiKey,
    String? target,
  }) async {
    try {
      if (stripeApiKey == null || stripeApiKey.isEmpty) {
        return const Left('Clé API Stripe manquante');
      }
      final mrr = await _stripe.fetchMrr(stripeApiKey);
      final parsedTarget = _parseTarget(target);
      return Right(GoalData(
        current: mrr.currentMrr,
        target: parsedTarget,
        changePct: mrr.changePct,
        lastUpdated: DateTime.now(),
      ));
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      if (statusCode == 401) return const Left('Clé API invalide ou expirée');
      if (statusCode == 403) return const Left('Accès refusé — vérifie les permissions');
      return Left('Erreur réseau : ${e.message}');
    } catch (e) {
      return Left('Erreur : $e');
    }
  }

  double _parseTarget(String? target) {
    if (target == null) return 5000;
    final t = target
        .toUpperCase()
        .replaceAll('€', '')
        .replaceAll('+', '')
        .replaceAll('/MOIS', '')
        .trim();
    if (t.endsWith('K')) {
      return (double.tryParse(t.replaceAll('K', '')) ?? 5) * 1000;
    }
    return double.tryParse(t) ?? 5000;
  }
}
