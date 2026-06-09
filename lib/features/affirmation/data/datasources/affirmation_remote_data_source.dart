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
    final query = supabaseClient.from('affirmations').select('content, category');
    final data = await query as List<dynamic>;
    return data.map((row) {
      final map = row as Map<String, dynamic>;
      return AffirmationModel.fromMap({
        'text': map['content'] as String,
        'category': map['category'] as String,
      });
    }).toList();
  }
}
