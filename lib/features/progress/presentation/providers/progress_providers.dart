import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mentorax/features/progress/data/models/mobile_progress_summary_model.dart';
import 'package:mentorax/features/progress/data/progress_repository.dart';
import 'package:mentorax/features/progress/data/progress_service.dart';

final progressServiceProvider = Provider<ProgressService>((ref) {
  return ProgressService();
});

final progressRepositoryProvider = Provider<ProgressRepository>((ref) {
  return ProgressRepository(ref.read(progressServiceProvider));
});

final progressSummaryProvider = FutureProvider<MobileProgressSummaryModel>((ref) async {
  return ref.read(progressRepositoryProvider).getSummary();
});