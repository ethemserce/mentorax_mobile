import 'models/mobile_progress_summary_model.dart';
import 'progress_local_data_source.dart';
import 'progress_service.dart';

class ProgressRepository {
  final ProgressService _service;
  final ProgressLocalDataSource? _local;

  ProgressRepository({
    required ProgressService service,
    ProgressLocalDataSource? local,
  }) : _service = service,
       _local = local;

  Future<MobileProgressSummaryModel> getSummary() async {
    try {
      return await _service.getSummary();
    } catch (error) {
      final cached = await _local?.getSummary();

      if (cached != null) return cached;

      rethrow;
    }
  }
}
