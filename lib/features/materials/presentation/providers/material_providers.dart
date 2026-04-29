import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mentorax/features/materials/data/models/material_chunk_model.dart';
import 'package:mentorax/features/materials/data/models/material_model.dart';
import '../../data/material_repository.dart';
import '../../data/material_service.dart';


final materialServiceProvider = Provider<MaterialService>((ref) {
  return MaterialService();
});
final materialRepositoryProvider = Provider<MaterialRepository>((ref) {
  return MaterialRepository(ref.read(materialServiceProvider));
});

final materialListProvider = FutureProvider<List<MaterialModel>>((ref) {
  return ref.read(materialServiceProvider).getMaterials();
});

final materialDetailProvider =
    FutureProvider.family<MaterialModel, String>((ref, materialId) {
  return ref.read(materialServiceProvider).getMaterialById(materialId);
});

final materialChunksProvider =
    FutureProvider.family<List<MaterialChunkModel>, String>((ref, materialId) {
  return ref.read(materialServiceProvider).getMaterialChunks(materialId);
});