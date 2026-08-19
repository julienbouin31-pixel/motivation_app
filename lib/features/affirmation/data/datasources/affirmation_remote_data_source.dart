import 'package:injectable/injectable.dart';
import 'package:motivation_app/core/supabase/supabase_bootstrap.dart';
import 'package:motivation_app/features/affirmation/data/models/affirmation_model.dart';

abstract class AffirmationRemoteDataSource {
  Future<List<AffirmationModel>> fetchAffirmations({
    String? name,
    String? category,
  });
}

@LazySingleton(as: AffirmationRemoteDataSource)
class AffirmationRemoteDataSourceImpl implements AffirmationRemoteDataSource {
  @override
  Future<List<AffirmationModel>> fetchAffirmations({
    String? name,
    String? category,
  }) async {
    try {
      final data = await supabaseClient
          .from('affirmations')
          .select('content, category, tone, themes, author') as List<dynamic>;
      return data.map((row) {
        final map = row as Map<String, dynamic>;
        return AffirmationModel.fromMap({
          'text': map['content'] as String,
          'category': map['category'] as String,
          'tone': map['tone'],
          'themes': map['themes'],
          'author': map['author'],
        });
      }).toList();
    } catch (_) {
      // Colonnes tone/themes pas encore créées côté Supabase → repli sur les
      // colonnes de base (valeurs par défaut appliquées).
      final data = await supabaseClient
          .from('affirmations')
          .select('content, category') as List<dynamic>;
      return data.map((row) {
        final map = row as Map<String, dynamic>;
        return AffirmationModel.fromMap({
          'text': map['content'] as String,
          'category': map['category'] as String,
        });
      }).toList();
    }
  }
}
