import 'package:injectable/injectable.dart';
import 'package:motivation_app/core/supabase/supabase_bootstrap.dart';

@lazySingleton
class ProfileRemoteDataSource {
  Future<void> upsertProfile({required String? name}) async {
    final client = supabaseClient;
    final userId = client.auth.currentUser?.id;
    if (userId == null) {
      throw StateError('Pas de session Supabase pour upsert profil');
    }
    await client.from('profiles').upsert({
      'user_id': userId,
      'name': name,
      'updated_at': DateTime.now().toUtc().toIso8601String(),
    });
  }

  Future<Map<String, dynamic>?> fetchProfile() async {
    final client = supabaseClient;
    final userId = client.auth.currentUser?.id;
    if (userId == null) return null;
    final row = await client
        .from('profiles')
        .select()
        .eq('user_id', userId)
        .maybeSingle();
    return row;
  }
}
