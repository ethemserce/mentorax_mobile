import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mentorax/features/materials/data/models/material_model.dart';
import '../../data/material_repository.dart';
import '../../data/material_service.dart';

final materialServiceProvider = Provider<MaterialService>((ref) {
  return MaterialService();
});

final materialRepositoryProvider = Provider<MaterialRepository>((ref) {
  return MaterialRepository(ref.read(materialServiceProvider));
});

final materialListProvider =
    FutureProvider<List<MaterialModel>>((ref) async {
  return ref.read(materialRepositoryProvider).getMaterials();
});

final materialDetailProvider =
    FutureProvider.family<MaterialModel, String>((ref, materialId) {
  return ref.read(materialServiceProvider).getMaterialById(materialId);
});