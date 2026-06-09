import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:motivation_app/features/affirmation/domain/entities/affirmation.dart';
import 'package:motivation_app/features/affirmation/domain/repositories/affirmation_repository.dart';

@injectable
class CustomAffirmationsCubit extends Cubit<List<Affirmation>> {
  final AffirmationRepository _repo;

  CustomAffirmationsCubit(this._repo) : super([]);

  Future<void> load() async {
    final result = await _repo.getCustomAffirmations();
    result.fold((_) => emit([]), (list) => emit(list));
  }

  Future<void> add(String text) async {
    await _repo.addCustomAffirmation(text.trim());
    await load();
  }

  Future<void> update(int id, String text) async {
    await _repo.updateCustomAffirmation(id, text.trim());
    await load();
  }

  Future<void> delete(int id) async {
    await _repo.deleteCustomAffirmation(id);
    await load();
  }
}
