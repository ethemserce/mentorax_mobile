import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mentorax/core/database/database_provider.dart';
import 'package:mentorax/features/materials/data/models/material_chunk_model.dart';
import 'package:mentorax/features/materials/data/models/material_model.dart';
import '../../data/material_local_data_source.dart';
import '../../data/material_repository.dart';
import '../../data/material_service.dart';

final materialServiceProvider = Provider<MaterialService>((ref) {
  return MaterialService();
});

final materialLocalDataSourceProvider = Provider<MaterialLocalDataSource>((
  ref,
) {
  return MaterialLocalDataSource(ref.read(appDatabaseProvider));
});

final materialRepositoryProvider = Provider<MaterialRepository>((ref) {
  return MaterialRepository(
    service: ref.read(materialServiceProvider),
    local: ref.read(materialLocalDataSourceProvider),
  );
});

final materialListProvider = FutureProvider<List<MaterialModel>>((ref) {
  return ref.read(materialRepositoryProvider).getMaterials();
});

final materialDetailProvider = FutureProvider.family<MaterialModel, String>((
  ref,
  materialId,
) {
  return ref.read(materialRepositoryProvider).getMaterialById(materialId);
});

final materialChunksProvider =
    FutureProvider.family<List<MaterialChunkModel>, String>((ref, materialId) {
      return ref.read(materialRepositoryProvider).getMaterialChunks(materialId);
    });
