import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:motivation_app/core/database/app_database.dart';
import 'package:motivation_app/core/storage/secure_storage.dart';
import 'package:motivation_app/features/affirmation/data/models/affirmation_model.dart';
import 'package:motivation_app/features/affirmation/domain/entities/affirmation_category.dart';

abstract class AffirmationLocalDataSource {
  Future<AffirmationModel?> getNextUnviewed({List<String>? categories});
  Future<List<AffirmationModel>> getFavorites();
  Future<void> saveAll(List<AffirmationModel> affirmations);
  Future<void> clearAll();
  Future<void> markAsViewed(int id);
  Future<void> toggleFavorite(int id);
  Future<int> totalCount({List<String>? categories});
  Future<List<AffirmationCategory>> getSavedCategories();
  Future<void> saveCategories(List<AffirmationCategory> categories);
  Future<DateTime?> getLastFetchDate();
  Future<void> setLastFetchDate(DateTime date);
}

@LazySingleton(as: AffirmationLocalDataSource)
class AffirmationLocalDataSourceImpl implements AffirmationLocalDataSource {
  final AppDatabase db;
  final SecureStorage _secureStorage;

  AffirmationLocalDataSourceImpl({
    required this.db,
    required SecureStorage secureStorage,
  }) : _secureStorage = secureStorage;

  @override
  Future<AffirmationModel?> getNextUnviewed({List<String>? categories}) async {
    final query = db.select(db.affirmationItems);
    if (categories != null && categories.isNotEmpty) {
      query.where((t) => t.category.isIn(categories));
    }
    // Carte la moins récemment vue en premier (NULL = jamais vue → priorité maximale)
    query
      ..orderBy([
        (t) => OrderingTerm(
              expression: t.lastViewedAt,
              nulls: NullsOrder.first,
            ),
      ])
      ..limit(1);
    final results = await query.get();
    if (results.isEmpty) return null;
    return _fromRow(results.first);
  }

  @override
  Future<List<AffirmationModel>> getFavorites() async {
    final rows = await (db.select(db.affirmationItems)
          ..where((t) => t.isFavorite.equals(true)))
        .get();
    return rows.map(_fromRow).toList();
  }

  @override
  Future<void> saveAll(List<AffirmationModel> affirmations) async {
    await db.batch((batch) {
      batch.insertAll(
        db.affirmationItems,
        affirmations.map(
          (a) => AffirmationItemsCompanion.insert(
            content: a.text,
            category: a.category,
          ),
        ),
        mode: InsertMode.insertOrIgnore,
      );
    });
  }

  @override
  Future<void> clearAll() async {
    await db.delete(db.affirmationItems).go();
  }

  @override
  Future<void> markAsViewed(int id) async {
    await (db.update(db.affirmationItems)..where((t) => t.id.equals(id)))
        .write(AffirmationItemsCompanion(lastViewedAt: Value(DateTime.now())));
  }

  @override
  Future<void> toggleFavorite(int id) async {
    final row = await (db.select(db.affirmationItems)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    if (row != null) {
      await (db.update(db.affirmationItems)..where((t) => t.id.equals(id)))
          .write(AffirmationItemsCompanion(isFavorite: Value(!row.isFavorite)));
    }
  }

  @override
  Future<int> totalCount({List<String>? categories}) async {
    final query = db.select(db.affirmationItems);
    if (categories != null && categories.isNotEmpty) {
      query.where((t) => t.category.isIn(categories));
    }
    final results = await query.get();
    return results.length;
  }

  @override
  Future<List<AffirmationCategory>> getSavedCategories() async {
    try {
      final saved = await _secureStorage.readCategories();
      if (saved == null || saved.isEmpty) return [];
      return saved
          .split(',')
          .map((s) => AffirmationCategory.values.where((c) => c.name == s).firstOrNull)
          .whereType<AffirmationCategory>()
          .toList();
    } catch (e) {
      debugPrint('[getSavedCategories] Erreur: $e');
      return [];
    }
  }

  @override
  Future<void> saveCategories(List<AffirmationCategory> categories) async {
    try {
      await _secureStorage.saveCategories(categories.map((c) => c.name).join(','));
    } catch (e) {
      debugPrint('[saveCategories] Erreur: $e');
    }
  }

  @override
  Future<DateTime?> getLastFetchDate() async {
    try {
      final raw = await _secureStorage.readLastFetchDate();
      if (raw == null) return null;
      return DateTime.tryParse(raw);
    } catch (e) {
      debugPrint('[getLastFetchDate] Erreur: $e');
      return null;
    }
  }

  @override
  Future<void> setLastFetchDate(DateTime date) async {
    try {
      await _secureStorage.saveLastFetchDate(date.toIso8601String());
    } catch (e) {
      debugPrint('[setLastFetchDate] Erreur: $e');
    }
  }

  AffirmationModel _fromRow(AffirmationItem row) => AffirmationModel(
        id: row.id,
        text: row.content,
        category: row.category,
        lastViewedAt: row.lastViewedAt,
        isFavorite: row.isFavorite,
      );
}
