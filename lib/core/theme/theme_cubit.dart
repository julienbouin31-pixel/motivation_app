import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motivation_app/core/storage/secure_storage.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  final SecureStorage _storage;

  ThemeCubit(this._storage) : super(ThemeMode.system);

  Future<void> load() async {
    final saved = await _storage.readThemeMode();
    if (saved == null) return;
    emit(ThemeMode.values.firstWhere(
      (m) => m.name == saved,
      orElse: () => ThemeMode.system,
    ));
  }

  Future<void> setTheme(ThemeMode mode) async {
    await _storage.saveThemeMode(mode.name);
    emit(mode);
  }
}
