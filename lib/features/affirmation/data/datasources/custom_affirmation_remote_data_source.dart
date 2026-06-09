import 'package:injectable/injectable.dart';
import 'package:motivation_app/core/supabase/supabase_bootstrap.dart';

@lazySingleton
class CustomAffirmationRemoteDataSource {
  Future<String> insert(String content) async {
    final client = supabaseClient;
    final userId = client.auth.currentUser?.id;
    if (userId == null) {
      throw StateError('Pas de session Supabase pour insert custom');
    }
    final row = await client
        .from('custom_affirmations')
        .insert({
          'user_id': userId,
          'content': content,
        })
        .select('id')
        .single();
    return row['id'] as String;
  }

  Future<void> update(String remoteId, String content) async {
    await supabaseClient.from('custom_affirmations').update({
      'content': content,
      'updated_at': DateTime.now().toUtc().toIso8601String(),
    }).eq('id', remoteId);
  }

  Future<void> delete(String remoteId) async {
    await supabaseClient.from('custom_affirmations').delete().eq('id', remoteId);
  }
}
