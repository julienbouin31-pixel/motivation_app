import 'package:drift/drift.dart';
import 'package:motivation_app/core/database/app_database.dart';
import 'package:motivation_app/features/affirmation/data/models/affirmation_model.dart';

abstract class AffirmationLocalDataSource {
  Future<AffirmationModel?> getNextUnviewed({List<String>? categories});
  Future<List<AffirmationModel>> getFavorites();
  Future<void> saveAll(List<AffirmationModel> affirmations);
  Future<void> clearAll();
  Future<void> markAsViewed(int id);
  Future<void> toggleFavorite(int id);
  Future<int> countUnviewed({List<String>? categories});
  Future<int> totalCount({List<String>? categories});
  Future<void> resetViewed({List<String>? categories});
  Future<Set<String>> getAllContents();
}

class AffirmationLocalDataSourceImpl implements AffirmationLocalDataSource {
  final AppDatabase db;

  AffirmationLocalDataSourceImpl({required this.db});

  @override
  Future<AffirmationModel?> getNextUnviewed({List<String>? categories}) async {
    final query = db.select(db.affirmationItems)
      ..where((t) => t.isViewed.equals(false));
    if (categories != null && categories.isNotEmpty) {
      query.where((t) => t.category.isIn(categories));
    }
    // Ordre aléatoire
    query
      ..orderBy([
        (t) => OrderingTerm(
              expression: const CustomExpression<int>('RANDOM()'),
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
        .write(const AffirmationItemsCompanion(isViewed: Value(true)));
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
  Future<int> countUnviewed({List<String>? categories}) async {
    final query = db.select(db.affirmationItems)
      ..where((t) => t.isViewed.equals(false));
    if (categories != null && categories.isNotEmpty) {
      query.where((t) => t.category.isIn(categories));
    }
    final results = await query.get();
    return results.length;
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
  Future<Set<String>> getAllContents() async {
    final rows = await db.select(db.affirmationItems).get();
    return rows.map((r) => r.content).toSet();
  }

  @override
  Future<void> resetViewed({List<String>? categories}) async {
    final q = db.update(db.affirmationItems)
      ..where((t) => t.isViewed.equals(true));
    if (categories != null && categories.isNotEmpty) {
      q.where((t) => t.category.isIn(categories));
    }
    await q.write(const AffirmationItemsCompanion(isViewed: Value(false)));
  }

  AffirmationModel _fromRow(AffirmationItem row) => AffirmationModel(
        id: row.id,
        text: row.content,
        category: row.category,
        isViewed: row.isViewed,
        isFavorite: row.isFavorite,
      );
}
