import 'dart:convert';
import 'dart:math' as math;

import 'package:drift/drift.dart';
import 'package:mentorax/core/database/app_database.dart';

import 'models/create_material_chunk_request.dart';
import 'models/create_material_request_model.dart';
import 'models/material_chunk_model.dart';
import 'models/material_model.dart';
import 'models/update_material_chunk_request.dart';

class MaterialLocalDataSource {
  static const _pendingStatus = 'pending';
  static const _syncedStatus = 'synced';
  static const _offlineUserId = 'offline-user';

  final AppDatabase _database;

  MaterialLocalDataSource(this._database);

  Future<void> cacheMaterials(List<MaterialModel> materials) async {
    final now = DateTime.now().toUtc();
    final materialIds = materials.map((material) => material.id).toSet();

    await _database.transaction(() async {
      final existing = await _database.select(_database.localMaterials).get();

      for (final material in existing) {
        if (!materialIds.contains(material.id) &&
            material.syncStatus == _syncedStatus) {
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
    final existing = await (_database.select(
      _database.localMaterials,
    )..where((row) => row.id.equals(material.id))).getSingleOrNull();

    if (existing != null && existing.syncStatus != _syncedStatus) return;

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
        if (!chunkIds.contains(chunk.id) && chunk.syncStatus == _syncedStatus) {
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
    final existing = await (_database.select(
      _database.localMaterialChunks,
    )..where((row) => row.id.equals(chunk.id))).getSingleOrNull();

    if (existing != null && existing.syncStatus != _syncedStatus) return;

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

  Future<MaterialModel> createMaterialLocally(
    CreateMaterialRequestModel request,
  ) async {
    final materialId = _newGuid();
    final defaultChunkId = _newGuid();
    final now = DateTime.now().toUtc();

    final material = MaterialModel(
      id: materialId,
      userId: _offlineUserId,
      title: request.title,
      materialType: request.materialType,
      content: request.content,
      estimatedDurationMinutes: request.estimatedDurationMinutes,
      description: request.description,
      tags: request.tags,
      hasActivePlan: false,
      activePlanId: null,
      activePlanTitle: null,
    );

    final defaultChunk = MaterialChunkModel(
      id: defaultChunkId,
      learningMaterialId: materialId,
      orderNo: 1,
      title: request.title,
      content: request.content,
      summary: request.description,
      keywords: request.tags,
      difficultyLevel: 1,
      estimatedStudyMinutes: request.estimatedDurationMinutes,
      characterCount: request.content.length,
      isGeneratedByAI: false,
    );

    await _database.transaction(() async {
      await _insertMaterial(material, syncStatus: _pendingStatus, now: now);
      await _insertChunk(defaultChunk, syncStatus: _pendingStatus, now: now);
      await _enqueueOperation(
        id: 'create-material-$materialId',
        operationType: 'MaterialCreated',
        entityType: 'Material',
        entityId: materialId,
        payload: {
          'materialId': materialId,
          'defaultChunkId': defaultChunkId,
          ...request.toJson(),
        },
        createdAtUtc: now,
      );
    });

    return material;
  }

  Future<MaterialChunkModel?> createChunkLocally({
    required String materialId,
    required CreateMaterialChunkRequest request,
  }) async {
    final material = await _visibleMaterialRow(materialId);
    if (material == null) return null;

    final chunkId = _newGuid();
    final now = DateTime.now().toUtc();
    final orderNo = await _nextChunkOrderNo(materialId);
    final chunk = MaterialChunkModel(
      id: chunkId,
      learningMaterialId: materialId,
      orderNo: orderNo,
      title: request.title,
      content: request.content,
      summary: request.summary,
      keywords: request.keywords,
      difficultyLevel: request.difficultyLevel,
      estimatedStudyMinutes: request.estimatedStudyMinutes,
      characterCount: request.content.length,
      isGeneratedByAI: false,
    );

    await _database.transaction(() async {
      await _insertChunk(chunk, syncStatus: _pendingStatus, now: now);
      await _touchMaterial(materialId, now);
      await _enqueueOperation(
        id: 'create-chunk-$chunkId',
        operationType: 'MaterialChunkCreated',
        entityType: 'MaterialChunk',
        entityId: chunkId,
        payload: {
          'materialId': materialId,
          'chunkId': chunkId,
          ...request.toJson(),
          'orderNo': orderNo,
        },
        createdAtUtc: now,
      );
    });

    return chunk;
  }

  Future<MaterialChunkModel?> updateChunkLocally({
    required String materialId,
    required String chunkId,
    required UpdateMaterialChunkRequest request,
  }) async {
    final existing = await _visibleChunkRow(
      materialId: materialId,
      chunkId: chunkId,
    );
    if (existing == null) return null;

    final now = DateTime.now().toUtc();

    await _database.transaction(() async {
      await (_database.update(
        _database.localMaterialChunks,
      )..where((row) => row.id.equals(chunkId))).write(
        LocalMaterialChunksCompanion(
          title: Value(request.title),
          content: Value(request.content),
          summary: Value(request.summary),
          keywords: Value(request.keywords),
          difficultyLevel: Value(request.difficultyLevel),
          estimatedStudyMinutes: Value(request.estimatedStudyMinutes),
          characterCount: Value(request.content.length),
          syncStatus: const Value(_pendingStatus),
          isDeleted: const Value(false),
          updatedAtUtc: Value(now),
        ),
      );
      await _touchMaterial(materialId, now);
      await _enqueueOperation(
        id: 'update-chunk-$chunkId-${_newGuid()}',
        operationType: 'MaterialChunkUpdated',
        entityType: 'MaterialChunk',
        entityId: chunkId,
        payload: {
          'materialId': materialId,
          'chunkId': chunkId,
          ...request.toJson(),
        },
        createdAtUtc: now,
      );
    });

    final updated = await _visibleChunkRow(
      materialId: materialId,
      chunkId: chunkId,
    );

    return updated == null ? null : _toMaterialChunkModel(updated);
  }

  Future<bool> deleteChunkLocally({
    required String materialId,
    required String chunkId,
  }) async {
    final existing = await _visibleChunkRow(
      materialId: materialId,
      chunkId: chunkId,
    );
    if (existing == null) return false;

    final now = DateTime.now().toUtc();

    await _database.transaction(() async {
      await (_database.update(
        _database.localMaterialChunks,
      )..where((row) => row.id.equals(chunkId))).write(
        LocalMaterialChunksCompanion(
          syncStatus: const Value(_pendingStatus),
          isDeleted: const Value(true),
          updatedAtUtc: Value(now),
        ),
      );
      await _reorderVisibleChunks(materialId, now);
      await _touchMaterial(materialId, now);
      await _enqueueOperation(
        id: 'delete-chunk-$chunkId',
        operationType: 'MaterialChunkDeleted',
        entityType: 'MaterialChunk',
        entityId: chunkId,
        payload: {'materialId': materialId, 'chunkId': chunkId},
        createdAtUtc: now,
      );
    });

    return true;
  }

  Future<List<MaterialChunkModel>?> reorderChunksLocally({
    required String materialId,
    required List<String> chunkIds,
  }) async {
    final material = await _visibleMaterialRow(materialId);
    if (material == null) return null;

    final chunks = await getChunks(materialId);
    final requestedIds = chunkIds.toSet();
    final currentIds = chunks.map((chunk) => chunk.id).toSet();

    if (chunkIds.isEmpty ||
        requestedIds.length != chunkIds.length ||
        requestedIds.length != currentIds.length ||
        !requestedIds.containsAll(currentIds)) {
      return null;
    }

    final now = DateTime.now().toUtc();

    await _database.transaction(() async {
      for (var index = 0; index < chunkIds.length; index++) {
        await (_database.update(
          _database.localMaterialChunks,
        )..where((row) => row.id.equals(chunkIds[index]))).write(
          LocalMaterialChunksCompanion(
            orderNo: Value(index + 1),
            updatedAtUtc: Value(now),
          ),
        );
      }

      await (_database.update(
        _database.localMaterials,
      )..where((row) => row.id.equals(materialId))).write(
        LocalMaterialsCompanion(
          syncStatus: const Value(_pendingStatus),
          updatedAtUtc: Value(now),
        ),
      );

      await _enqueueOperation(
        id: 'reorder-chunks-$materialId-${_newGuid()}',
        operationType: 'MaterialChunksReordered',
        entityType: 'Material',
        entityId: materialId,
        payload: {'materialId': materialId, 'chunkIds': chunkIds},
        createdAtUtc: now,
      );
    });

    return getChunks(materialId);
  }

  Future<LocalMaterial?> _visibleMaterialRow(String materialId) {
    return (_database.select(_database.localMaterials)..where(
          (row) => row.id.equals(materialId) & row.isDeleted.equals(false),
        ))
        .getSingleOrNull();
  }

  Future<LocalMaterialChunk?> _visibleChunkRow({
    required String materialId,
    required String chunkId,
  }) {
    return (_database.select(_database.localMaterialChunks)..where(
          (row) =>
              row.id.equals(chunkId) &
              row.learningMaterialId.equals(materialId) &
              row.isDeleted.equals(false),
        ))
        .getSingleOrNull();
  }

  Future<int> _nextChunkOrderNo(String materialId) async {
    final chunks =
        await (_database.select(_database.localMaterialChunks)..where(
              (row) =>
                  row.learningMaterialId.equals(materialId) &
                  row.isDeleted.equals(false),
            ))
            .get();

    return chunks.fold<int>(
          0,
          (current, chunk) => math.max(current, chunk.orderNo),
        ) +
        1;
  }

  Future<void> _insertMaterial(
    MaterialModel material, {
    required String syncStatus,
    required DateTime now,
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
            syncStatus: Value(syncStatus),
            isDeleted: const Value(false),
            updatedAtUtc: Value(now),
          ),
          mode: InsertMode.insertOrReplace,
        );
  }

  Future<void> _insertChunk(
    MaterialChunkModel chunk, {
    required String syncStatus,
    required DateTime now,
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
            syncStatus: Value(syncStatus),
            isDeleted: const Value(false),
            updatedAtUtc: Value(now),
          ),
          mode: InsertMode.insertOrReplace,
        );
  }

  Future<void> _touchMaterial(String materialId, DateTime now) async {
    await (_database.update(_database.localMaterials)
          ..where((row) => row.id.equals(materialId)))
        .write(LocalMaterialsCompanion(updatedAtUtc: Value(now)));
  }

  Future<void> _reorderVisibleChunks(
    String materialId,
    DateTime updatedAtUtc,
  ) async {
    final chunks =
        await (_database.select(_database.localMaterialChunks)
              ..where(
                (row) =>
                    row.learningMaterialId.equals(materialId) &
                    row.isDeleted.equals(false),
              )
              ..orderBy([(row) => OrderingTerm.asc(row.orderNo)]))
            .get();

    for (var index = 0; index < chunks.length; index++) {
      await (_database.update(
        _database.localMaterialChunks,
      )..where((row) => row.id.equals(chunks[index].id))).write(
        LocalMaterialChunksCompanion(
          orderNo: Value(index + 1),
          updatedAtUtc: Value(updatedAtUtc),
        ),
      );
    }
  }

  Future<void> _enqueueOperation({
    required String id,
    required String operationType,
    required String entityType,
    required String entityId,
    required Map<String, dynamic> payload,
    required DateTime createdAtUtc,
  }) async {
    await _database
        .into(_database.syncOutbox)
        .insert(
          SyncOutboxCompanion.insert(
            id: id,
            operationType: operationType,
            entityType: entityType,
            entityId: entityId,
            payload: jsonEncode(payload),
            createdAtUtc: createdAtUtc,
            updatedAtUtc: Value(createdAtUtc),
          ),
          mode: InsertMode.insertOrReplace,
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

final _guidRandom = math.Random.secure();

String _newGuid() {
  final bytes = List<int>.generate(16, (_) => _guidRandom.nextInt(256));
  bytes[6] = (bytes[6] & 0x0f) | 0x40;
  bytes[8] = (bytes[8] & 0x3f) | 0x80;

  final hex = bytes
      .map((byte) => byte.toRadixString(16).padLeft(2, '0'))
      .join();

  return '${hex.substring(0, 8)}-'
      '${hex.substring(8, 12)}-'
      '${hex.substring(12, 16)}-'
      '${hex.substring(16, 20)}-'
      '${hex.substring(20)}';
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
