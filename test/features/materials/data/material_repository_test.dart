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

  test('successful chunk writes keep local cache current', () async {
    final service = _FakeMaterialService(
      createdChunk: _chunk(id: 'chunk-1', title: 'Created Chunk'),
      updatedChunk: _chunk(id: 'chunk-1', title: 'Updated Chunk'),
      reorderedChunks: [
        _chunk(id: 'chunk-2', orderNo: 1, title: 'Second'),
        _chunk(id: 'chunk-1', orderNo: 2, title: 'Updated Chunk'),
      ],
    );
    final repository = MaterialRepository(service: service, local: local);

    await repository.createMaterialChunk(
      materialId: 'material-1',
      request: CreateMaterialChunkRequest(
        title: 'Created Chunk',
        content: 'Created content',
        summary: null,
        keywords: null,
        difficultyLevel: 1,
        estimatedStudyMinutes: 10,
      ),
    );
    expect((await local.getChunks('material-1')).single.title, 'Created Chunk');

    await repository.updateMaterialChunk(
      materialId: 'material-1',
      chunkId: 'chunk-1',
      request: UpdateMaterialChunkRequest(
        title: 'Updated Chunk',
        content: 'Updated content',
        summary: null,
        keywords: null,
        difficultyLevel: 2,
        estimatedStudyMinutes: 12,
      ),
    );
    expect((await local.getChunks('material-1')).single.title, 'Updated Chunk');

    await repository.reorderMaterialChunks(
      materialId: 'material-1',
      chunkIds: ['chunk-2', 'chunk-1'],
    );
    expect((await local.getChunks('material-1')).map((chunk) => chunk.id), [
      'chunk-2',
      'chunk-1',
    ]);

    await repository.deleteMaterialChunk(
      materialId: 'material-1',
      chunkId: 'chunk-1',
    );
    expect((await local.getChunks('material-1')).map((chunk) => chunk.id), [
      'chunk-2',
    ]);
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
  MaterialChunkModel? createdChunk;
  MaterialChunkModel? updatedChunk;
  List<MaterialChunkModel>? reorderedChunks;
  bool failReads = false;

  _FakeMaterialService({
    this.materials = const [],
    this.material,
    this.chunks = const [],
    this.createdChunk,
    this.updatedChunk,
    this.reorderedChunks,
  });

  @override
  Future<MaterialModel> createMaterial(
    CreateMaterialRequestModel request,
  ) async {
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
    return createdChunk ??
        _chunk(materialId: materialId, title: request.title ?? 'Chunk');
  }

  @override
  Future<MaterialChunkModel> updateMaterialChunk({
    required String materialId,
    required String chunkId,
    required UpdateMaterialChunkRequest request,
  }) async {
    return updatedChunk ??
        _chunk(
          id: chunkId,
          materialId: materialId,
          title: request.title ?? 'Chunk',
        );
  }

  @override
  Future<void> deleteMaterialChunk({
    required String materialId,
    required String chunkId,
  }) async {}

  @override
  Future<List<MaterialChunkModel>> reorderMaterialChunks({
    required String materialId,
    required List<String> chunkIds,
  }) async {
    return reorderedChunks ?? chunks;
  }
}
