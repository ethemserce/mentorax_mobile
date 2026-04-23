import 'material_service.dart';
import 'models/create_material_request_model.dart';
import 'models/material_model.dart';

class MaterialRepository {
  final MaterialService _service;

  MaterialRepository(this._service);

  Future<MaterialModel> createMaterial(CreateMaterialRequestModel request) {
    return _service.createMaterial(request);
  }

  Future<List<MaterialModel>> getMaterials() {
  return _service.getMaterials();
}
}