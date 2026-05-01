import 'package:drift/drift.dart';

import 'database_connection.dart';

part 'app_database.g.dart';

class LocalMaterials extends Table {
  @override
  String get tableName => 'local_materials';

  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get title => text()();
  TextColumn get materialType => text()();
  TextColumn get content => text()();
  IntColumn get estimatedDurationMinutes => integer()();
  TextColumn get description => text().nullable()();
  TextColumn get tags => text().nullable()();
  BoolColumn get hasActivePlan =>
      boolean().withDefault(const Constant(false))();
  TextColumn get activePlanId => text().nullable()();
  TextColumn get activePlanTitle => text().nullable()();
  TextColumn get syncStatus => text().withDefault(const Constant('synced'))();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get updatedAtUtc => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class LocalMaterialChunks extends Table {
  @override
  String get tableName => 'local_material_chunks';

  TextColumn get id => text()();
  TextColumn get learningMaterialId => text()();
  IntColumn get orderNo => integer()();
  TextColumn get title => text().nullable()();
  TextColumn get content => text()();
  TextColumn get summary => text().nullable()();
  TextColumn get keywords => text().nullable()();
  IntColumn get difficultyLevel => integer()();
  IntColumn get estimatedStudyMinutes => integer()();
  IntColumn get characterCount => integer()();
  BoolColumn get isGeneratedByAI =>
      boolean().withDefault(const Constant(false))();
  TextColumn get syncStatus => text().withDefault(const Constant('synced'))();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get updatedAtUtc => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class LocalStudyPlans extends Table {
  @override
  String get tableName => 'local_study_plans';

  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get learningMaterialId => text()();
  TextColumn get title => text()();
  TextColumn get startDate => text()();
  IntColumn get dailyTargetMinutes => integer()();
  TextColumn get status => text()();
  TextColumn get syncStatus => text().withDefault(const Constant('synced'))();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get updatedAtUtc => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class LocalStudyPlanItems extends Table {
  @override
  String get tableName => 'local_study_plan_items';

  TextColumn get id => text()();
  TextColumn get studyPlanId => text()();
  TextColumn get materialChunkId => text().nullable()();
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  TextColumn get itemType => text()();
  IntColumn get orderNo => integer()();
  DateTimeColumn get plannedDateUtc => dateTime()();
  TextColumn get plannedStartTime => text().nullable()();
  TextColumn get plannedEndTime => text().nullable()();
  IntColumn get durationMinutes => integer()();
  TextColumn get status => text()();
  TextColumn get syncStatus => text().withDefault(const Constant('synced'))();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get updatedAtUtc => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class LocalStudySessions extends Table {
  @override
  String get tableName => 'local_study_sessions';

  TextColumn get id => text()();
  TextColumn get studyPlanId => text()();
  TextColumn get studyPlanItemId => text().nullable()();
  TextColumn get learningMaterialId => text()();
  TextColumn get userId => text().nullable()();
  TextColumn get studyProgressId => text().nullable()();
  DateTimeColumn get scheduledAtUtc => dateTime()();
  DateTimeColumn get startedAtUtc => dateTime().nullable()();
  DateTimeColumn get completedAtUtc => dateTime().nullable()();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  IntColumn get sequenceNumber => integer().withDefault(const Constant(0))();
  IntColumn get qualityScore => integer().nullable()();
  IntColumn get difficultyScore => integer().nullable()();
  IntColumn get actualDurationMinutes => integer().nullable()();
  TextColumn get reviewNotes => text().nullable()();
  TextColumn get status => text().withDefault(const Constant('pending'))();
  TextColumn get syncStatus => text().withDefault(const Constant('synced'))();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get updatedAtUtc => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class SyncOutbox extends Table {
  @override
  String get tableName => 'sync_outbox';

  TextColumn get id => text()();
  TextColumn get operationType => text()();
  TextColumn get entityType => text()();
  TextColumn get entityId => text()();
  TextColumn get payload => text()();
  TextColumn get status => text().withDefault(const Constant('pending'))();
  IntColumn get retryCount => integer().withDefault(const Constant(0))();
  TextColumn get lastError => text().nullable()();
  DateTimeColumn get createdAtUtc => dateTime()();
  DateTimeColumn get updatedAtUtc => dateTime().nullable()();
  DateTimeColumn get nextAttemptAtUtc => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DriftDatabase(
  tables: [
    LocalMaterials,
    LocalMaterialChunks,
    LocalStudyPlans,
    LocalStudyPlanItems,
    LocalStudySessions,
    SyncOutbox,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? openConnection());

  @override
  int get schemaVersion => 1;
}
