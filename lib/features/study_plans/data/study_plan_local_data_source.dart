import 'package:drift/drift.dart';
import 'package:mentorax/core/database/app_database.dart';
import 'package:mentorax/features/materials/data/models/material_chunk_model.dart';
import 'package:mentorax/features/study_plans/data/models/study_plan_detail_model.dart';
import 'package:mentorax/features/study_plans/data/models/study_plan_detail_session_model.dart';
import 'package:mentorax/features/study_plans/data/models/study_plan_item_model.dart';
import 'package:mentorax/features/study_plans/data/models/study_plan_model.dart';
import 'package:mentorax/features/study_plans/data/models/study_plan_session_model.dart';

class StudyPlanLocalDataSource {
  final AppDatabase _database;

  StudyPlanLocalDataSource(this._database);

  Future<void> cachePlans(List<StudyPlanModel> plans) async {
    await _database.batch((batch) {
      for (final plan in plans) {
        _writePlan(batch, plan);

        for (final session in plan.sessions) {
          _writePlanSession(batch, session, plan: plan);
        }

        for (final item in plan.items) {
          _writePlanItem(batch, item);
          _writeMaterialChunk(batch, item.materialChunk);

          for (final session in item.sessions) {
            _writePlanSession(
              batch,
              session,
              plan: plan,
              studyPlanItemId: item.id,
              materialTitle: item.materialChunk?.title ?? plan.title,
            );
          }
        }
      }
    });
  }

  Future<void> cachePlanDetail(StudyPlanDetailModel plan) async {
    await _database.batch((batch) {
      _writePlanDetail(batch, plan);

      for (final session in plan.sessions) {
        _writeDetailSession(batch, session, plan: plan);
      }

      for (final item in plan.items) {
        _writePlanItem(batch, item);
        _writeMaterialChunk(batch, item.materialChunk);

        for (final session in item.sessions) {
          _writeDetailItemSession(
            batch,
            session,
            plan: plan,
            studyPlanItemId: item.id,
            materialTitle: item.materialChunk?.title ?? plan.title,
          );
        }
      }
    });
  }

  Future<List<StudyPlanModel>> getPlans() async {
    final planRows =
        await (_database.select(_database.localStudyPlans)
              ..where((row) => row.isDeleted.equals(false))
              ..orderBy([(row) => OrderingTerm.desc(row.updatedAtUtc)]))
            .get();

    final plans = <StudyPlanModel>[];

    for (final plan in planRows) {
      plans.add(
        StudyPlanModel(
          id: plan.id,
          userId: plan.userId,
          learningMaterialId: plan.learningMaterialId,
          title: plan.title,
          startDate: plan.startDate,
          dailyTargetMinutes: plan.dailyTargetMinutes,
          status: plan.status,
          sessions: await _getPlanSessions(plan.id),
          items: await _getPlanItems(plan.id),
        ),
      );
    }

    return plans;
  }

  Future<StudyPlanDetailModel?> getPlanById(String planId) async {
    final plan =
        await (_database.select(_database.localStudyPlans)..where(
              (row) => row.id.equals(planId) & row.isDeleted.equals(false),
            ))
            .getSingleOrNull();

    if (plan == null) return null;

    return StudyPlanDetailModel(
      id: plan.id,
      userId: plan.userId,
      learningMaterialId: plan.learningMaterialId,
      title: plan.title,
      startDate: plan.startDate,
      dailyTargetMinutes: plan.dailyTargetMinutes,
      status: plan.status,
      sessions: await _getPlanDetailSessions(plan.id),
      items: await _getPlanItems(plan.id),
    );
  }

  Future<List<StudyPlanSessionModel>> _getPlanSessions(String planId) async {
    final rows =
        await (_database.select(_database.localStudySessions)
              ..where(
                (row) =>
                    row.studyPlanId.equals(planId) &
                    row.isDeleted.equals(false),
              )
              ..orderBy([(row) => OrderingTerm.asc(row.scheduledAtUtc)]))
            .get();

    return rows.map(_toStudyPlanSessionModel).toList();
  }

  Future<List<StudyPlanDetailSessionModel>> _getPlanDetailSessions(
    String planId,
  ) async {
    final rows =
        await (_database.select(_database.localStudySessions)
              ..where(
                (row) =>
                    row.studyPlanId.equals(planId) &
                    row.isDeleted.equals(false),
              )
              ..orderBy([(row) => OrderingTerm.asc(row.scheduledAtUtc)]))
            .get();

    return rows.map(_toStudyPlanDetailSessionModel).toList();
  }

  Future<List<StudyPlanItemModel>> _getPlanItems(String planId) async {
    final itemRows =
        await (_database.select(_database.localStudyPlanItems)
              ..where(
                (row) =>
                    row.studyPlanId.equals(planId) &
                    row.isDeleted.equals(false),
              )
              ..orderBy([(row) => OrderingTerm.asc(row.orderNo)]))
            .get();

    final items = <StudyPlanItemModel>[];

    for (final item in itemRows) {
      final sessionRows =
          await (_database.select(_database.localStudySessions)
                ..where(
                  (row) =>
                      row.studyPlanItemId.equals(item.id) &
                      row.isDeleted.equals(false),
                )
                ..orderBy([(row) => OrderingTerm.asc(row.scheduledAtUtc)]))
              .get();

      items.add(
        StudyPlanItemModel(
          id: item.id,
          studyPlanId: item.studyPlanId,
          materialChunkId: item.materialChunkId,
          title: item.title,
          description: item.description,
          itemType: item.itemType,
          orderNo: item.orderNo,
          plannedDateUtc: item.plannedDateUtc,
          plannedStartTime: item.plannedStartTime,
          plannedEndTime: item.plannedEndTime,
          durationMinutes: item.durationMinutes,
          status: item.status,
          materialChunk: item.materialChunkId == null
              ? null
              : await _getMaterialChunk(item.materialChunkId!),
          sessions: sessionRows.map(_toStudyPlanSessionModel).toList(),
        ),
      );
    }

    return items;
  }

  Future<MaterialChunkModel?> _getMaterialChunk(String chunkId) async {
    final chunk = await (_database.select(
      _database.localMaterialChunks,
    )..where((row) => row.id.equals(chunkId))).getSingleOrNull();

    if (chunk == null) return null;

    return MaterialChunkModel(
      id: chunk.id,
      learningMaterialId: chunk.learningMaterialId,
      orderNo: chunk.orderNo,
      title: chunk.title,
      content: chunk.content,
      summary: chunk.summary,
      keywords: chunk.keywords,
      difficultyLevel: chunk.difficultyLevel,
      estimatedStudyMinutes: chunk.estimatedStudyMinutes,
      characterCount: chunk.characterCount,
      isGeneratedByAI: chunk.isGeneratedByAI,
    );
  }

  void _writePlan(Batch batch, StudyPlanModel plan) {
    batch.insert(
      _database.localStudyPlans,
      LocalStudyPlansCompanion.insert(
        id: plan.id,
        userId: plan.userId,
        learningMaterialId: plan.learningMaterialId,
        title: plan.title,
        startDate: plan.startDate,
        dailyTargetMinutes: plan.dailyTargetMinutes,
        status: plan.status,
        updatedAtUtc: Value(DateTime.now().toUtc()),
      ),
      mode: InsertMode.insertOrReplace,
    );
  }

  void _writePlanDetail(Batch batch, StudyPlanDetailModel plan) {
    batch.insert(
      _database.localStudyPlans,
      LocalStudyPlansCompanion.insert(
        id: plan.id,
        userId: plan.userId,
        learningMaterialId: plan.learningMaterialId,
        title: plan.title,
        startDate: plan.startDate,
        dailyTargetMinutes: plan.dailyTargetMinutes,
        status: plan.status,
        updatedAtUtc: Value(DateTime.now().toUtc()),
      ),
      mode: InsertMode.insertOrReplace,
    );
  }

  void _writePlanItem(Batch batch, StudyPlanItemModel item) {
    batch.insert(
      _database.localStudyPlanItems,
      LocalStudyPlanItemsCompanion.insert(
        id: item.id,
        studyPlanId: item.studyPlanId,
        materialChunkId: Value(item.materialChunkId),
        title: item.title,
        description: Value(item.description),
        itemType: item.itemType,
        orderNo: item.orderNo,
        plannedDateUtc: item.plannedDateUtc,
        plannedStartTime: Value(item.plannedStartTime),
        plannedEndTime: Value(item.plannedEndTime),
        durationMinutes: item.durationMinutes,
        status: item.status,
        updatedAtUtc: Value(DateTime.now().toUtc()),
      ),
      mode: InsertMode.insertOrReplace,
    );
  }

  void _writeMaterialChunk(Batch batch, MaterialChunkModel? chunk) {
    if (chunk == null) return;

    batch.insert(
      _database.localMaterialChunks,
      LocalMaterialChunksCompanion.insert(
        id: chunk.id,
        learningMaterialId: chunk.learningMaterialId,
        orderNo: chunk.orderNo,
        title: Value(chunk.title),
        content: chunk.content,
        summary: Value(chunk.summary),
        keywords: Value(chunk.keywords),
        difficultyLevel: chunk.difficultyLevel,
        estimatedStudyMinutes: chunk.estimatedStudyMinutes,
        characterCount: chunk.characterCount,
        isGeneratedByAI: Value(chunk.isGeneratedByAI),
        updatedAtUtc: Value(DateTime.now().toUtc()),
      ),
      mode: InsertMode.insertOrReplace,
    );
  }

  void _writePlanSession(
    Batch batch,
    StudyPlanSessionModel session, {
    required StudyPlanModel plan,
    String? studyPlanItemId,
    String? materialTitle,
  }) {
    batch.insert(
      _database.localStudySessions,
      LocalStudySessionsCompanion.insert(
        id: session.id,
        studyPlanId: session.studyPlanId,
        studyPlanItemId: Value(studyPlanItemId),
        learningMaterialId: plan.learningMaterialId,
        materialTitle: Value(materialTitle ?? plan.title),
        userId: Value(plan.userId),
        scheduledAtUtc: session.scheduledAtUtc,
        startedAtUtc: const Value(null),
        completedAtUtc: Value(session.completedAtUtc),
        isCompleted: Value(session.completedAtUtc != null),
        sequenceNumber: Value(session.sequenceNumber),
        plannedDurationMinutes: Value(session.plannedDurationMinutes),
        actualDurationMinutes: Value(session.actualDurationMinutes),
        reviewNotes: Value(session.notes),
        status: Value(session.status),
        updatedAtUtc: Value(DateTime.now().toUtc()),
      ),
      mode: InsertMode.insertOrReplace,
    );
  }

  void _writeDetailItemSession(
    Batch batch,
    StudyPlanSessionModel session, {
    required StudyPlanDetailModel plan,
    String? studyPlanItemId,
    String? materialTitle,
  }) {
    batch.insert(
      _database.localStudySessions,
      LocalStudySessionsCompanion.insert(
        id: session.id,
        studyPlanId: session.studyPlanId,
        studyPlanItemId: Value(studyPlanItemId),
        learningMaterialId: plan.learningMaterialId,
        materialTitle: Value(materialTitle ?? plan.title),
        userId: Value(plan.userId),
        scheduledAtUtc: session.scheduledAtUtc,
        startedAtUtc: const Value(null),
        completedAtUtc: Value(session.completedAtUtc),
        isCompleted: Value(session.completedAtUtc != null),
        sequenceNumber: Value(session.sequenceNumber),
        plannedDurationMinutes: Value(session.plannedDurationMinutes),
        actualDurationMinutes: Value(session.actualDurationMinutes),
        reviewNotes: Value(session.notes),
        status: Value(session.status),
        updatedAtUtc: Value(DateTime.now().toUtc()),
      ),
      mode: InsertMode.insertOrReplace,
    );
  }

  void _writeDetailSession(
    Batch batch,
    StudyPlanDetailSessionModel session, {
    required StudyPlanDetailModel plan,
  }) {
    batch.insert(
      _database.localStudySessions,
      LocalStudySessionsCompanion.insert(
        id: session.id,
        studyPlanId: session.studyPlanId,
        learningMaterialId: plan.learningMaterialId,
        materialTitle: Value(plan.title),
        userId: Value(plan.userId),
        scheduledAtUtc: session.scheduledAtUtc,
        completedAtUtc: Value(session.completedAtUtc),
        isCompleted: Value(session.completedAtUtc != null),
        sequenceNumber: Value(session.sequenceNumber),
        plannedDurationMinutes: Value(session.plannedDurationMinutes),
        actualDurationMinutes: Value(session.actualDurationMinutes),
        reviewNotes: Value(session.notes),
        status: Value(session.status),
        updatedAtUtc: Value(DateTime.now().toUtc()),
      ),
      mode: InsertMode.insertOrReplace,
    );
  }
}

StudyPlanSessionModel _toStudyPlanSessionModel(LocalStudySession session) {
  return StudyPlanSessionModel(
    id: session.id,
    studyPlanId: session.studyPlanId,
    sequenceNumber: session.sequenceNumber,
    scheduledAtUtc: session.scheduledAtUtc,
    plannedDurationMinutes: session.plannedDurationMinutes,
    status: session.status,
    completedAtUtc: session.completedAtUtc,
    actualDurationMinutes: session.actualDurationMinutes,
    notes: session.reviewNotes,
    easinessFactor: null,
    intervalDays: null,
    repetitionCount: null,
  );
}

StudyPlanDetailSessionModel _toStudyPlanDetailSessionModel(
  LocalStudySession session,
) {
  return StudyPlanDetailSessionModel(
    id: session.id,
    studyPlanId: session.studyPlanId,
    sequenceNumber: session.sequenceNumber,
    scheduledAtUtc: session.scheduledAtUtc,
    plannedDurationMinutes: session.plannedDurationMinutes,
    status: session.status,
    completedAtUtc: session.completedAtUtc,
    actualDurationMinutes: session.actualDurationMinutes,
    notes: session.reviewNotes,
    easinessFactor: null,
    intervalDays: null,
    repetitionCount: null,
  );
}
