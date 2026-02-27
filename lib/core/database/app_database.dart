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
}

@DriftDatabase(tables: [AffirmationItems])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            // v2 : isViewed → lastViewedAt (nullable), UNIQUE sur content
            await m.drop(affirmationItems);
            await m.createTable(affirmationItems);
          }
          if (from < 3) {
            // v3 : les placeholders {name}/{target} sont désormais stockés en DB
            await m.drop(affirmationItems);
            await m.createTable(affirmationItems);
          }
          if (from < 4) {
            // v4 : nettoyage des entrées avec noms baked-in (anciens onboardings)
            //      → toutes les entrées doivent utiliser {name}/{target} comme placeholders
            await m.drop(affirmationItems);
            await m.createTable(affirmationItems);
          }
        },
      );
}

Future<AppDatabase> openAppDatabase() async {
  final dir = await getApplicationDocumentsDirectory();
  final file = File(p.join(dir.path, 'motivation_app.db'));
  return AppDatabase(NativeDatabase.createInBackground(file));
}
