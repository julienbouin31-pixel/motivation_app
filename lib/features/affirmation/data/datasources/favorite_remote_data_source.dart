import 'package:injectable/injectable.dart';
import 'package:motivation_app/core/supabase/supabase_bootstrap.dart';

@lazySingleton
class FavoriteRemoteDataSource {
  Future<void> upsert({
    required String content,
    required String category,
    required bool isCustom,
    String? customAffirmationId,
  }) async {
    final client = supabaseClient;
    final userId = client.auth.currentUser?.id;
    if (userId == null) {
      throw StateError('Pas de session Supabase pour upsert favori');
    }
    await client.from('favorites').upsert(
      {
        'user_id': userId,
        'content': content,
        'category': category,
        'is_custom': isCustom,
        'custom_affirmation_id': customAffirmationId,
      },
      onConflict: 'user_id,content',
    );
  }

  Future<void> deleteByContent(String content) async {
    final client = supabaseClient;
    final userId = client.auth.currentUser?.id;
    if (userId == null) return;
    await client
        .from('favorites')
        .delete()
        .eq('user_id', userId)
        .eq('content', content);
  }
}
