import 'package:injectable/injectable.dart';
import 'package:motivation_app/core/supabase/supabase_bootstrap.dart';

@lazySingleton
class StreakRemoteDataSource {
  Future<void> upsertStreak({required int count, required String lastDate}) async {
    final client = supabaseClient;
    final userId = client.auth.currentUser?.id;
    if (userId == null) {
      throw StateError('Pas de session Supabase pour upsert streak');
    }
    await client.from('streaks').upsert({
      'user_id': userId,
      'count': count,
      'last_date': lastDate,
      'updated_at': DateTime.now().toUtc().toIso8601String(),
    });
  }

  Future<Map<String, dynamic>?> fetchStreak() async {
    final client = supabaseClient;
    final userId = client.auth.currentUser?.id;
    if (userId == null) return null;
    return client
        .from('streaks')
        .select()
        .eq('user_id', userId)
        .maybeSingle();
  }
}
