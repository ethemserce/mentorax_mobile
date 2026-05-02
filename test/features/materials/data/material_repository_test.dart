import 'dart:convert';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mentorax/core/database/app_database.dart';
import 'package:mentorax/features/materials/data/material_local_data_source.dart';
import 'package:mentorax/features/materials/data/material_repository.dart';
import 'package:mentorax/features/materials/data/material_service.dart';
import 'package:mentorax/features/materials/data/models/create_material_chunk_request.dart';
import 'package:mentorax/features/materials/data/models/create_material_request_model.dart';
import 'package:mentorax/features/materials/data/models/material_chunk_model.dart';
import 'package:mentorax/features/materials/data/models/material_model.dart';
import 'package:mentorax/features/materials/data/models/update_material_chunk_request.dart';

void main() {
  late AppDatabase database;
  late MaterialLocalDataSource local;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    local = MaterialLocalDataSource(database);
  });

  tearDown(() async {
    await database.close();
  });

  test('caches materials and chunks for offline reads', () async {
    await local.cacheMaterials([
      _material(id: 'material-1', title: 'Algebra'),
      _material(id: 'material-2', title: 'Geometry'),
    ]);
    await local.cacheChunks('material-1', [
      _chunk(id: 'chunk-1', orderNo: 1, title: 'Equations'),
      _chunk(id: 'chunk-2', orderNo: 2, title: 'Functions'),
    ]);

    final materials = await local.getMaterials();
    final material = await local.getMaterialById('material-1');
    final chunks = await local.getChunks('material-1');

    expect(
      materials.map((item) => item.id),
      containsAll(['material-1', 'material-2']),
    );
    expect(material?.title, 'Algebra');
    expect(chunks.map((chunk) => chunk.title), ['Equations', 'Functions']);
  });

  test('repository falls back to cached materials and chunks', () async {
    final service = _FakeMaterialService(
      materials: [_material(id: 'material-1', title: 'Server Material')],
      material: _material(id: 'material-1', title: 'Server Material'),
      chunks: [_chunk(id: 'chunk-1', title: 'Server Chunk')],
    );
    final repository = MaterialRepository(service: service, local: local);

    await repository.getMaterials();
    await repository.getMaterialById('material-1');
    await repository.getMaterialChunks('material-1');

    service.failReads = true;

    final cachedMaterials = await repository.getMaterials();
    final cachedMaterial = await repository.getMaterialById('material-1');
    final cachedChunks = await repository.getMaterialChunks('material-1');

    expect(cachedMaterials.single.title, 'Server Material');
    expect(cachedMaterial.title, 'Server Material');
    expect(cachedChunks.single.title, 'Server Chunk');
  });

  test(
    'repository creates materials locally and queues sync operation',
    () async {
      final service = _FakeMaterialService();
      final repository = MaterialRepository(service: service, local: local);

      final material = await repository.createMaterial(
        CreateMaterialRequestModel(
          title: 'Offline Material',
          materialType: 'Text',
          content: 'Offline material content',
          estimatedDurationMinutes: 40,
          description: 'Offline description',
          tags: 'offline,sync',
        ),
      );

      final localMaterial = await database
          .select(database.localMaterials)
          .getSingle();
      final defaultChunk = await database
          .select(database.localMaterialChunks)
          .getSingle();
      final outboxOperation = await database
          .select(database.syncOutbox)
          .getSingle();
      final payload =
          jsonDecode(outboxOperation.payload) as Map<String, dynamic>;

      expect(service.createMaterialCalls, 0);
      expect(material.id, localMaterial.id);
      expect(localMaterial.title, 'Offline Material');
      expect(localMaterial.syncStatus, 'pending');
      expect(defaultChunk.learningMaterialId, material.id);
      expect(defaultChunk.syncStatus, 'pending');
      expect(outboxOperation.operationType, 'MaterialCreated');
      expect(outboxOperation.entityType, 'Material');
      expect(outboxOperation.entityId, material.id);
      expect(payload['materialId'], material.id);
      expect(payload['defaultChunkId'], defaultChunk.id);
      expect(payload['title'], 'Offline Material');
    },
  );

  test('repository writes chunks locally and queues sync operations', () async {
    final service = _FakeMaterialService();
    final repository = MaterialRepository(service: service, local: local);

    await local.cacheMaterial(_material(id: 'material-1', title: 'Material'));

    final firstChunk = await repository.createMaterialChunk(
      materialId: 'material-1',
      request: CreateMaterialChunkRequest(
        title: 'First Chunk',
        content: 'First content',
        summary: null,
        keywords: null,
        difficultyLevel: 1,
        estimatedStudyMinutes: 10,
      ),
    );
    final secondChunk = await repository.createMaterialChunk(
      materialId: 'material-1',
      request: CreateMaterialChunkRequest(
        title: 'Second Chunk',
        content: 'Second content',
        summary: 'Second summary',
        keywords: 'second',
        difficultyLevel: 2,
        estimatedStudyMinutes: 12,
      ),
    );

    final thirdChunk = await repository.createMaterialChunk(
      materialId: 'material-1',
      request: CreateMaterialChunkRequest(
        title: 'Third Chunk',
        content: 'Third content',
        summary: null,
        keywords: null,
        difficultyLevel: 1,
        estimatedStudyMinutes: 10,
      ),
    );
    expect((await local.getChunks('material-1')).map((chunk) => chunk.title), [
      'First Chunk',
      'Second Chunk',
      'Third Chunk',
    ]);

    final updatedChunk = await repository.updateMaterialChunk(
      materialId: 'material-1',
      chunkId: firstChunk.id,
      request: UpdateMaterialChunkRequest(
        title: 'Updated Chunk',
        content: 'Updated content',
        summary: null,
        keywords: null,
        difficultyLevel: 2,
        estimatedStudyMinutes: 12,
      ),
    );
    expect(updatedChunk.title, 'Updated Chunk');

    await repository.reorderMaterialChunks(
      materialId: 'material-1',
      chunkIds: [secondChunk.id, firstChunk.id, thirdChunk.id],
    );
    expect((await local.getChunks('material-1')).map((chunk) => chunk.id), [
      secondChunk.id,
      firstChunk.id,
      thirdChunk.id,
    ]);

    await repository.deleteMaterialChunk(
      materialId: 'material-1',
      chunkId: firstChunk.id,
    );
    expect((await local.getChunks('material-1')).map((chunk) => chunk.id), [
      secondChunk.id,
      thirdChunk.id,
    ]);

    final deletedChunk = await (database.select(
      database.localMaterialChunks,
    )..where((row) => row.id.equals(firstChunk.id))).getSingle();
    final outboxOperations = await database.select(database.syncOutbox).get();

    expect(service.createChunkCalls, 0);
    expect(service.updateChunkCalls, 0);
    expect(service.reorderChunkCalls, 0);
    expect(service.deleteChunkCalls, 0);
    expect(deletedChunk.isDeleted, isTrue);
    expect(deletedChunk.syncStatus, 'pending');
    expect(
      outboxOperations.map((operation) => operation.operationType),
      containsAll([
        'MaterialChunkCreated',
        'MaterialChunkUpdated',
        'MaterialChunksReordered',
        'MaterialChunkDeleted',
      ]),
    );
  });
}

MaterialModel _material({String id = 'material-1', String title = 'Material'}) {
  return MaterialModel(
    id: id,
    userId: 'user-1',
    title: title,
    materialType: 'Text',
    content: '$title content',
    estimatedDurationMinutes: 30,
    description: '$title description',
    tags: 'math,study',
    hasActivePlan: false,
    activePlanId: null,
    activePlanTitle: null,
  );
}

MaterialChunkModel _chunk({
  String id = 'chunk-1',
  String materialId = 'material-1',
  int orderNo = 1,
  String title = 'Chunk',
}) {
  return MaterialChunkModel(
    id: id,
    learningMaterialId: materialId,
    orderNo: orderNo,
    title: title,
    content: '$title content',
    summary: '$title summary',
    keywords: 'focus',
    difficultyLevel: 1,
    estimatedStudyMinutes: 10,
    characterCount: '$title content'.length,
    isGeneratedByAI: false,
  );
}

class _FakeMaterialService extends MaterialService {
  List<MaterialModel> materials;
  MaterialModel? material;
  List<MaterialChunkModel> chunks;
  bool failReads = false;
  int createMaterialCalls = 0;
  int createChunkCalls = 0;
  int updateChunkCalls = 0;
  int deleteChunkCalls = 0;
  int reorderChunkCalls = 0;

  _FakeMaterialService({
    this.materials = const [],
    this.material,
    this.chunks = const [],
  });

  @override
  Future<MaterialModel> createMaterial(
    CreateMaterialRequestModel request,
  ) async {
    createMaterialCalls += 1;
    return _material(title: request.title);
  }

  @override
  Future<List<MaterialModel>> getMaterials() async {
    if (failReads) throw Exception('network unavailable');
    return materials;
  }

  @override
  Future<MaterialModel> getMaterialById(String id) async {
    if (failReads) throw Exception('network unavailable');
    return material ?? materials.singleWhere((item) => item.id == id);
  }

  @override
  Future<List<MaterialChunkModel>> getMaterialChunks(String materialId) async {
    if (failReads) throw Exception('network unavailable');
    return chunks;
  }

  @override
  Future<MaterialChunkModel> createMaterialChunk({
    required String materialId,
    required CreateMaterialChunkRequest request,
  }) async {
    createChunkCalls += 1;
    return _chunk(materialId: materialId, title: request.title ?? 'Chunk');
  }

  @override
  Future<MaterialChunkModel> updateMaterialChunk({
    required String materialId,
    required String chunkId,
    required UpdateMaterialChunkRequest request,
  }) async {
    updateChunkCalls += 1;
    return _chunk(
      id: chunkId,
      materialId: materialId,
      title: request.title ?? 'Chunk',
    );
  }

  @override
  Future<void> deleteMaterialChunk({
    required String materialId,
    required String chunkId,
  }) async {
    deleteChunkCalls += 1;
  }

  @override
  Future<List<MaterialChunkModel>> reorderMaterialChunks({
    required String materialId,
    required List<String> chunkIds,
  }) async {
    reorderChunkCalls += 1;
    return chunks;
  }
}
