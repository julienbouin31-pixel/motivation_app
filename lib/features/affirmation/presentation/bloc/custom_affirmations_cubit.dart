import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motivation_app/features/affirmation/data/datasources/affirmation_local_data_source.dart';
import 'package:motivation_app/features/affirmation/domain/entities/affirmation.dart';

class CustomAffirmationsCubit extends Cubit<List<Affirmation>> {
  final AffirmationLocalDataSource _local;

  CustomAffirmationsCubit(this._local) : super([]);

  Future<void> load() async {
    final models = await _local.getCustomAffirmations();
    emit(models.map((m) => m.toEntity()).toList());
  }

  Future<void> add(String text) async {
    await _local.saveCustomAffirmation(text.trim());
    await load();
  }

  Future<void> delete(int id) async {
    await _local.deleteAffirmation(id);
    await load();
  }
}
