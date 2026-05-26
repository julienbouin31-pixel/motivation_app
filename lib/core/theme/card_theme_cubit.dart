import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motivation_app/core/storage/secure_storage.dart';
import 'package:motivation_app/core/theme/card_visual_theme.dart';

class CardThemeCubit extends Cubit<CardVisualTheme> {
  final SecureStorage _storage;

  CardThemeCubit(this._storage) : super(CardVisualTheme.minimal);

  Future<void> load() async {
    final saved = await _storage.readCardTheme();
    if (saved == null) return;
    emit(CardVisualTheme.values.firstWhere(
      (t) => t.name == saved,
      orElse: () => CardVisualTheme.minimal,
    ));
  }

  Future<void> setTheme(CardVisualTheme theme) async {
    await _storage.saveCardTheme(theme.name);
    emit(theme);
  }
}
