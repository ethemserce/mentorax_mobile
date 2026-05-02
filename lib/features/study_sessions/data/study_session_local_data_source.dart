import 'package:drift/drift.dart';
import 'package:mentorax/core/database/app_database.dart';

import 'models/study_session_detail_model.dart';

class StudySessionLocalDataSource {
  final AppDatabase _database;

  StudySessionLocalDataSource(this._database);

  Future<void> cacheSessionDetail(
    StudySessionDetailModel session, {
    String? syncStatus,
  }) async {
    final existing = await (_database.select(
      _database.localStudySessions,
    )..where((row) => row.id.equals(session.id))).getSingleOrNull();

    await _database
        .into(_database.localStudySessions)
        .insert(
          LocalStudySessionsCompanion.insert(
            id: session.id,
            studyPlanId: session.studyPlanId,
            studyPlanItemId: Value(session.studyPlanItemId),
            learningMaterialId: session.learningMaterialId,
            materialTitle: Value(session.materialTitle),
            scheduledAtUtc: session.scheduledAtUtc,
            startedAtUtc: Value(session.startedAtUtc ?? existing?.startedAtUtc),
            completedAtUtc: Value(session.completedAtUtc),
            isCompleted: Value(session.completedAtUtc != null),
            sequenceNumber: Value(session.sequenceNumber),
            plannedDurationMinutes: Value(session.plannedDurationMinutes),
            actualDurationMinutes: Value(session.actualDurationMinutes),
            reviewNotes: Value(session.notes),
            status: Value(session.status),
            syncStatus: Value(syncStatus ?? existing?.syncStatus ?? 'synced'),
            updatedAtUtc: Value(DateTime.now().toUtc()),
          ),
          mode: InsertMode.insertOrReplace,
        );

    if (session.studyPlanItemId != null) {
      await _database
          .into(_database.localStudyPlanItems)
          .insert(
            LocalStudyPlanItemsCompanion.insert(
              id: session.studyPlanItemId!,
              studyPlanId: session.studyPlanId,
              materialChunkId: Value(session.materialChunkId),
              title: session.chunkTitle ?? session.materialTitle,
              itemType: session.itemType ?? 'Study',
              orderNo: session.sequenceNumber,
              plannedDateUtc: session.scheduledAtUtc,
              durationMinutes: session.plannedDurationMinutes,
              status: session.status,
              updatedAtUtc: Value(DateTime.now().toUtc()),
            ),
            mode: InsertMode.insertOrReplace,
          );
    }

    if (session.materialChunkId != null && session.chunkContent != null) {
      final existingChunk =
          await (_database.select(_database.localMaterialChunks)
                ..where((row) => row.id.equals(session.materialChunkId!)))
              .getSingleOrNull();

      await _database
          .into(_database.localMaterialChunks)
          .insert(
            LocalMaterialChunksCompanion.insert(
              id: session.materialChunkId!,
              learningMaterialId: session.learningMaterialId,
              orderNo: session.sequenceNumber,
              title: Value(session.chunkTitle),
              content: session.chunkContent!,
              summary: Value(existingChunk?.summary),
              keywords: Value(existingChunk?.keywords),
              difficultyLevel: existingChunk?.difficultyLevel ?? 1,
              estimatedStudyMinutes:
                  existingChunk?.estimatedStudyMinutes ??
                  session.plannedDurationMinutes,
              characterCount:
                  existingChunk?.characterCount ?? session.chunkContent!.length,
              isGeneratedByAI: Value(existingChunk?.isGeneratedByAI ?? false),
              updatedAtUtc: Value(DateTime.now().toUtc()),
            ),
            mode: InsertMode.insertOrReplace,
          );
    }
  }

  Future<StudySessionDetailModel?> getSessionById(String sessionId) async {
    final session = await (_database.select(
      _database.localStudySessions,
    )..where((row) => row.id.equals(sessionId))).getSingleOrNull();

    if (session == null) return null;

    final plan = await (_database.select(
      _database.localStudyPlans,
    )..where((row) => row.id.equals(session.studyPlanId))).getSingleOrNull();

    final item = session.studyPlanItemId == null
        ? null
        : await (_database.select(_database.localStudyPlanItems)
                ..where((row) => row.id.equals(session.studyPlanItemId!)))
              .getSingleOrNull();

    final chunk = item?.materialChunkId == null
        ? null
        : await (_database.select(_database.localMaterialChunks)
                ..where((row) => row.id.equals(item!.materialChunkId!)))
              .getSingleOrNull();

    return StudySessionDetailModel(
      id: session.id,
      studyPlanId: session.studyPlanId,
      studyPlanItemId: session.studyPlanItemId,
      learningMaterialId: session.learningMaterialId,
      materialChunkId: item?.materialChunkId,
      planTitle: plan?.title ?? 'Study Plan',
      materialTitle:
          session.materialTitle ?? chunk?.title ?? plan?.title ?? 'Study',
      chunkTitle: chunk?.title ?? item?.title,
      chunkContent: chunk?.content,
      itemType: item?.itemType,
      sequenceNumber: session.sequenceNumber,
      scheduledAtUtc: session.scheduledAtUtc,
      startedAtUtc: session.startedAtUtc,
      plannedDurationMinutes: session.plannedDurationMinutes,
      status: session.status,
      completedAtUtc: session.completedAtUtc,
      actualDurationMinutes: session.actualDurationMinutes,
      notes: session.reviewNotes,
    );
  }
}
