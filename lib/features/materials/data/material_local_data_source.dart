import 'package:drift/drift.dart';
import 'package:mentorax/core/database/app_database.dart';

import 'models/material_chunk_model.dart';
import 'models/material_model.dart';

class MaterialLocalDataSource {
  final AppDatabase _database;

  MaterialLocalDataSource(this._database);

  Future<void> cacheMaterials(List<MaterialModel> materials) async {
    final now = DateTime.now().toUtc();
    final materialIds = materials.map((material) => material.id).toSet();

    await _database.transaction(() async {
      final existing = await _database.select(_database.localMaterials).get();

      for (final material in existing) {
        if (!materialIds.contains(material.id)) {
          await (_database.update(
            _database.localMaterials,
          )..where((row) => row.id.equals(material.id))).write(
            LocalMaterialsCompanion(
              isDeleted: const Value(true),
              updatedAtUtc: Value(now),
            ),
          );
        }
      }

      for (final material in materials) {
        await cacheMaterial(material, updatedAtUtc: now);
      }
    });
  }

  Future<void> cacheMaterial(
    MaterialModel material, {
    DateTime? updatedAtUtc,
  }) async {
    await _database
        .into(_database.localMaterials)
        .insert(
          LocalMaterialsCompanion.insert(
            id: material.id,
            userId: material.userId,
            title: material.title,
            materialType: material.materialType,
            content: material.content,
            estimatedDurationMinutes: material.estimatedDurationMinutes,
            description: Value(material.description),
            tags: Value(material.tags),
            hasActivePlan: Value(material.hasActivePlan),
            activePlanId: Value(material.activePlanId),
            activePlanTitle: Value(material.activePlanTitle),
            isDeleted: const Value(false),
            updatedAtUtc: Value(updatedAtUtc ?? DateTime.now().toUtc()),
          ),
          mode: InsertMode.insertOrReplace,
        );
  }

  Future<List<MaterialModel>> getMaterials() async {
    final rows =
        await (_database.select(_database.localMaterials)
              ..where((row) => row.isDeleted.equals(false))
              ..orderBy([(row) => OrderingTerm.desc(row.updatedAtUtc)]))
            .get();

    return rows.map(_toMaterialModel).toList();
  }

  Future<MaterialModel?> getMaterialById(String materialId) async {
    final row =
        await (_database.select(_database.localMaterials)..where(
              (material) =>
                  material.id.equals(materialId) &
                  material.isDeleted.equals(false),
            ))
            .getSingleOrNull();

    if (row == null) return null;

    return _toMaterialModel(row);
  }

  Future<void> cacheChunks(
    String materialId,
    List<MaterialChunkModel> chunks,
  ) async {
    final now = DateTime.now().toUtc();
    final chunkIds = chunks.map((chunk) => chunk.id).toSet();

    await _database.transaction(() async {
      final existing = await (_database.select(
        _database.localMaterialChunks,
      )..where((row) => row.learningMaterialId.equals(materialId))).get();

      for (final chunk in existing) {
        if (!chunkIds.contains(chunk.id)) {
          await (_database.update(
            _database.localMaterialChunks,
          )..where((row) => row.id.equals(chunk.id))).write(
            LocalMaterialChunksCompanion(
              isDeleted: const Value(true),
              updatedAtUtc: Value(now),
            ),
          );
        }
      }

      for (final chunk in chunks) {
        await cacheChunk(chunk, updatedAtUtc: now);
      }
    });
  }

  Future<void> cacheChunk(
    MaterialChunkModel chunk, {
    DateTime? updatedAtUtc,
  }) async {
    await _database
        .into(_database.localMaterialChunks)
        .insert(
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
            isDeleted: const Value(false),
            updatedAtUtc: Value(updatedAtUtc ?? DateTime.now().toUtc()),
          ),
          mode: InsertMode.insertOrReplace,
        );
  }

  Future<List<MaterialChunkModel>> getChunks(String materialId) async {
    final rows =
        await (_database.select(_database.localMaterialChunks)
              ..where(
                (row) =>
                    row.learningMaterialId.equals(materialId) &
                    row.isDeleted.equals(false),
              )
              ..orderBy([(row) => OrderingTerm.asc(row.orderNo)]))
            .get();

    return rows.map(_toMaterialChunkModel).toList();
  }

  Future<void> deleteChunk(String chunkId) async {
    await (_database.update(
      _database.localMaterialChunks,
    )..where((row) => row.id.equals(chunkId))).write(
      LocalMaterialChunksCompanion(
        isDeleted: const Value(true),
        updatedAtUtc: Value(DateTime.now().toUtc()),
      ),
    );
  }
}

MaterialModel _toMaterialModel(LocalMaterial material) {
  return MaterialModel(
    id: material.id,
    userId: material.userId,
    title: material.title,
    materialType: material.materialType,
    content: material.content,
    estimatedDurationMinutes: material.estimatedDurationMinutes,
    description: material.description,
    tags: material.tags,
    hasActivePlan: material.hasActivePlan,
    activePlanId: material.activePlanId,
    activePlanTitle: material.activePlanTitle,
  );
}

MaterialChunkModel _toMaterialChunkModel(LocalMaterialChunk chunk) {
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
