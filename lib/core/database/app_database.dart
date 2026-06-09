import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

class AffirmationItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get content => text().customConstraint('UNIQUE NOT NULL')();
  TextColumn get category => text()();
  DateTimeColumn get lastViewedAt => dateTime().nullable()();
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();
  BoolColumn get isCustom => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().nullable()();
  TextColumn get remoteId => text().nullable()();
}

class SyncQueueItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get entityType => text()();
  IntColumn get entityLocalId => integer().nullable()();
  TextColumn get operation => text()();
  TextColumn get payload => text()();
  DateTimeColumn get createdAt => dateTime()();
  IntColumn get attempts => integer().withDefault(const Constant(0))();
  TextColumn get lastError => text().nullable()();
  DateTimeColumn get nextAttemptAt => dateTime().nullable()();
}

@DriftDatabase(tables: [AffirmationItems, SyncQueueItems])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 7;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.drop(affirmationItems);
            await m.createTable(affirmationItems);
          }
          if (from < 3) {
            await m.drop(affirmationItems);
            await m.createTable(affirmationItems);
          }
          if (from < 4) {
            await m.drop(affirmationItems);
            await m.createTable(affirmationItems);
          }
          if (from < 5) {
            await m.addColumn(affirmationItems, affirmationItems.isCustom);
          }
          if (from < 6) {
            await m.addColumn(affirmationItems, affirmationItems.createdAt);
          }
          if (from < 7) {
            await m.addColumn(affirmationItems, affirmationItems.remoteId);
            await m.createTable(syncQueueItems);
          }
        },
      );
}

Future<AppDatabase> openAppDatabase() async {
  final dir = await getApplicationDocumentsDirectory();
  final file = File(p.join(dir.path, 'motivation_app.db'));
  return AppDatabase(NativeDatabase.createInBackground(file));
}
