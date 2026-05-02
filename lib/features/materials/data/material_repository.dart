import 'material_local_data_source.dart';
import 'material_service.dart';
import 'models/create_material_chunk_request.dart';
import 'models/create_material_request_model.dart';
import 'models/material_chunk_model.dart';
import 'models/material_model.dart';
import 'models/update_material_chunk_request.dart';

class MaterialRepository {
  final MaterialService _service;
  final MaterialLocalDataSource? _local;

  MaterialRepository({
    required MaterialService service,
    MaterialLocalDataSource? local,
  }) : _service = service,
       _local = local;

  Future<MaterialModel> createMaterial(
    CreateMaterialRequestModel request,
  ) async {
    final local = _local;
    if (local != null) {
      return local.createMaterialLocally(request);
    }

    final material = await _service.createMaterial(request);

    return material;
  }

  Future<List<MaterialModel>> getMaterials() async {
    try {
      final materials = await _service.getMaterials();
      await _local?.cacheMaterials(materials);

      return materials;
    } catch (error) {
      final cached = await _local?.getMaterials();

      if (cached != null && cached.isNotEmpty) return cached;

      rethrow;
    }
  }

  Future<MaterialModel> getMaterialById(String id) async {
    try {
      final material = await _service.getMaterialById(id);
      await _local?.cacheMaterial(material);

      return material;
    } catch (error) {
      final cached = await _local?.getMaterialById(id);

      if (cached != null) return cached;

      rethrow;
    }
  }

  Future<List<MaterialChunkModel>> getMaterialChunks(String materialId) async {
    try {
      final chunks = await _service.getMaterialChunks(materialId);
      await _local?.cacheChunks(materialId, chunks);

      return chunks;
    } catch (error) {
      final cached = await _local?.getChunks(materialId);

      if (cached != null && cached.isNotEmpty) return cached;

      rethrow;
    }
  }

  Future<MaterialChunkModel> createMaterialChunk({
    required String materialId,
    required CreateMaterialChunkRequest request,
  }) async {
    final localChunk = await _local?.createChunkLocally(
      materialId: materialId,
      request: request,
    );
    if (localChunk != null) return localChunk;

    final chunk = await _service.createMaterialChunk(
      materialId: materialId,
      request: request,
    );
    await _local?.cacheChunk(chunk);

    return chunk;
  }

  Future<MaterialChunkModel> updateMaterialChunk({
    required String materialId,
    required String chunkId,
    required UpdateMaterialChunkRequest request,
  }) async {
    final localChunk = await _local?.updateChunkLocally(
      materialId: materialId,
      chunkId: chunkId,
      request: request,
    );
    if (localChunk != null) return localChunk;

    final chunk = await _service.updateMaterialChunk(
      materialId: materialId,
      chunkId: chunkId,
      request: request,
    );
    await _local?.cacheChunk(chunk);

    return chunk;
  }

  Future<void> deleteMaterialChunk({
    required String materialId,
    required String chunkId,
  }) async {
    final deletedLocally = await _local?.deleteChunkLocally(
      materialId: materialId,
      chunkId: chunkId,
    );
    if (deletedLocally == true) return;

    await _service.deleteMaterialChunk(
      materialId: materialId,
      chunkId: chunkId,
    );
    await _local?.deleteChunk(chunkId);
  }

  Future<List<MaterialChunkModel>> reorderMaterialChunks({
    required String materialId,
    required List<String> chunkIds,
  }) async {
    final localChunks = await _local?.reorderChunksLocally(
      materialId: materialId,
      chunkIds: chunkIds,
    );
    if (localChunks != null) return localChunks;

    final chunks = await _service.reorderMaterialChunks(
      materialId: materialId,
      chunkIds: chunkIds,
    );
    await _local?.cacheChunks(materialId, chunks);

    return chunks;
  }
}
