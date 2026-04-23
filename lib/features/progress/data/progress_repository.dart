import 'models/mobile_progress_summary_model.dart';
import 'progress_service.dart';

class ProgressRepository {
  final ProgressService _service;

  ProgressRepository(this._service);

  Future<MobileProgressSummaryModel> getSummary() {
    return _service.getSummary();
  }
}