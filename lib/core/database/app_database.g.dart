// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $AffirmationItemsTable extends AffirmationItems
    with TableInfo<$AffirmationItemsTable, AffirmationItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AffirmationItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isViewedMeta = const VerificationMeta(
    'isViewed',
  );
  @override
  late final GeneratedColumn<bool> isViewed = GeneratedColumn<bool>(
    'is_viewed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_viewed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isFavoriteMeta = const VerificationMeta(
    'isFavorite',
  );
  @override
  late final GeneratedColumn<bool> isFavorite = GeneratedColumn<bool>(
    'is_favorite',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_favorite" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    content,
    category,
    isViewed,
    isFavorite,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'affirmation_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<AffirmationItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('is_viewed')) {
      context.handle(
        _isViewedMeta,
        isViewed.isAcceptableOrUnknown(data['is_viewed']!, _isViewedMeta),
      );
    }
    if (data.containsKey('is_favorite')) {
      context.handle(
        _isFavoriteMeta,
        isFavorite.isAcceptableOrUnknown(data['is_favorite']!, _isFavoriteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AffirmationItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AffirmationItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      isViewed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_viewed'],
      )!,
      isFavorite: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_favorite'],
      )!,
    );
  }

  @override
  $AffirmationItemsTable createAlias(String alias) {
    return $AffirmationItemsTable(attachedDatabase, alias);
  }
}

class AffirmationItem extends DataClass implements Insertable<AffirmationItem> {
  final int id;
  final String content;
  final String category;
  final bool isViewed;
  final bool isFavorite;
  const AffirmationItem({
    required this.id,
    required this.content,
    required this.category,
    required this.isViewed,
    required this.isFavorite,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['content'] = Variable<String>(content);
    map['category'] = Variable<String>(category);
    map['is_viewed'] = Variable<bool>(isViewed);
    map['is_favorite'] = Variable<bool>(isFavorite);
    return map;
  }

  AffirmationItemsCompanion toCompanion(bool nullToAbsent) {
    return AffirmationItemsCompanion(
      id: Value(id),
      content: Value(content),
      category: Value(category),
      isViewed: Value(isViewed),
      isFavorite: Value(isFavorite),
    );
  }

  factory AffirmationItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AffirmationItem(
      id: serializer.fromJson<int>(json['id']),
      content: serializer.fromJson<String>(json['content']),
      category: serializer.fromJson<String>(json['category']),
      isViewed: serializer.fromJson<bool>(json['isViewed']),
      isFavorite: serializer.fromJson<bool>(json['isFavorite']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'content': serializer.toJson<String>(content),
      'category': serializer.toJson<String>(category),
      'isViewed': serializer.toJson<bool>(isViewed),
      'isFavorite': serializer.toJson<bool>(isFavorite),
    };
  }

  AffirmationItem copyWith({
    int? id,
    String? content,
    String? category,
    bool? isViewed,
    bool? isFavorite,
  }) => AffirmationItem(
    id: id ?? this.id,
    content: content ?? this.content,
    category: category ?? this.category,
    isViewed: isViewed ?? this.isViewed,
    isFavorite: isFavorite ?? this.isFavorite,
  );
  AffirmationItem copyWithCompanion(AffirmationItemsCompanion data) {
    return AffirmationItem(
      id: data.id.present ? data.id.value : this.id,
      content: data.content.present ? data.content.value : this.content,
      category: data.category.present ? data.category.value : this.category,
      isViewed: data.isViewed.present ? data.isViewed.value : this.isViewed,
      isFavorite: data.isFavorite.present
          ? data.isFavorite.value
          : this.isFavorite,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AffirmationItem(')
          ..write('id: $id, ')
          ..write('content: $content, ')
          ..write('category: $category, ')
          ..write('isViewed: $isViewed, ')
          ..write('isFavorite: $isFavorite')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, content, category, isViewed, isFavorite);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AffirmationItem &&
          other.id == this.id &&
          other.content == this.content &&
          other.category == this.category &&
          other.isViewed == this.isViewed &&
          other.isFavorite == this.isFavorite);
}

class AffirmationItemsCompanion extends UpdateCompanion<AffirmationItem> {
  final Value<int> id;
  final Value<String> content;
  final Value<String> category;
  final Value<bool> isViewed;
  final Value<bool> isFavorite;
  const AffirmationItemsCompanion({
    this.id = const Value.absent(),
    this.content = const Value.absent(),
    this.category = const Value.absent(),
    this.isViewed = const Value.absent(),
    this.isFavorite = const Value.absent(),
  });
  AffirmationItemsCompanion.insert({
    this.id = const Value.absent(),
    required String content,
    required String category,
    this.isViewed = const Value.absent(),
    this.isFavorite = const Value.absent(),
  }) : content = Value(content),
       category = Value(category);
  static Insertable<AffirmationItem> custom({
    Expression<int>? id,
    Expression<String>? content,
    Expression<String>? category,
    Expression<bool>? isViewed,
    Expression<bool>? isFavorite,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (content != null) 'content': content,
      if (category != null) 'category': category,
      if (isViewed != null) 'is_viewed': isViewed,
      if (isFavorite != null) 'is_favorite': isFavorite,
    });
  }

  AffirmationItemsCompanion copyWith({
    Value<int>? id,
    Value<String>? content,
    Value<String>? category,
    Value<bool>? isViewed,
    Value<bool>? isFavorite,
  }) {
    return AffirmationItemsCompanion(
      id: id ?? this.id,
      content: content ?? this.content,
      category: category ?? this.category,
      isViewed: isViewed ?? this.isViewed,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (isViewed.present) {
      map['is_viewed'] = Variable<bool>(isViewed.value);
    }
    if (isFavorite.present) {
      map['is_favorite'] = Variable<bool>(isFavorite.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AffirmationItemsCompanion(')
          ..write('id: $id, ')
          ..write('content: $content, ')
          ..write('category: $category, ')
          ..write('isViewed: $isViewed, ')
          ..write('isFavorite: $isFavorite')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $AffirmationItemsTable affirmationItems = $AffirmationItemsTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [affirmationItems];
}

typedef $$AffirmationItemsTableCreateCompanionBuilder =
    AffirmationItemsCompanion Function({
      Value<int> id,
      required String content,
      required String category,
      Value<bool> isViewed,
      Value<bool> isFavorite,
    });
typedef $$AffirmationItemsTableUpdateCompanionBuilder =
    AffirmationItemsCompanion Function({
      Value<int> id,
      Value<String> content,
      Value<String> category,
      Value<bool> isViewed,
      Value<bool> isFavorite,
    });

class $$AffirmationItemsTableFilterComposer
    extends Composer<_$AppDatabase, $AffirmationItemsTable> {
  $$AffirmationItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isViewed => $composableBuilder(
    column: $table.isViewed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AffirmationItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $AffirmationItemsTable> {
  $$AffirmationItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isViewed => $composableBuilder(
    column: $table.isViewed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AffirmationItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AffirmationItemsTable> {
  $$AffirmationItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<bool> get isViewed =>
      $composableBuilder(column: $table.isViewed, builder: (column) => column);

  GeneratedColumn<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => column,
  );
}

class $$AffirmationItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AffirmationItemsTable,
          AffirmationItem,
          $$AffirmationItemsTableFilterComposer,
          $$AffirmationItemsTableOrderingComposer,
          $$AffirmationItemsTableAnnotationComposer,
          $$AffirmationItemsTableCreateCompanionBuilder,
          $$AffirmationItemsTableUpdateCompanionBuilder,
          (
            AffirmationItem,
            BaseReferences<
              _$AppDatabase,
              $AffirmationItemsTable,
              AffirmationItem
            >,
          ),
          AffirmationItem,
          PrefetchHooks Function()
        > {
  $$AffirmationItemsTableTableManager(
    _$AppDatabase db,
    $AffirmationItemsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AffirmationItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AffirmationItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AffirmationItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<bool> isViewed = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
              }) => AffirmationItemsCompanion(
                id: id,
                content: content,
                category: category,
                isViewed: isViewed,
                isFavorite: isFavorite,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String content,
                required String category,
                Value<bool> isViewed = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
              }) => AffirmationItemsCompanion.insert(
                id: id,
                content: content,
                category: category,
                isViewed: isViewed,
                isFavorite: isFavorite,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AffirmationItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AffirmationItemsTable,
      AffirmationItem,
      $$AffirmationItemsTableFilterComposer,
      $$AffirmationItemsTableOrderingComposer,
      $$AffirmationItemsTableAnnotationComposer,
      $$AffirmationItemsTableCreateCompanionBuilder,
      $$AffirmationItemsTableUpdateCompanionBuilder,
      (
        AffirmationItem,
        BaseReferences<_$AppDatabase, $AffirmationItemsTable, AffirmationItem>,
      ),
      AffirmationItem,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$AffirmationItemsTableTableManager get affirmationItems =>
      $$AffirmationItemsTableTableManager(_db, _db.affirmationItems);
}
