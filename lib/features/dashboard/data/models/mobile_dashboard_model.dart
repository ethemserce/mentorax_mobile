import 'next_session_model.dart';
import 'weak_material_model.dart';

class MobileDashboardModel {
  final int dueCount;
  final int todayPlannedMinutes;
  final int todayCompletedMinutes;
  final NextSessionModel? nextSession;
  final List<WeakMaterialModel> weakMaterials;

  MobileDashboardModel({
    required this.dueCount,
    required this.todayPlannedMinutes,
    required this.todayCompletedMinutes,
    required this.nextSession,
    required this.weakMaterials,
  });

  factory MobileDashboardModel.fromJson(Map<String, dynamic> json) {
    return MobileDashboardModel(
      dueCount: json['dueCount'] as int,
      todayPlannedMinutes: json['todayPlannedMinutes'] as int,
      todayCompletedMinutes: json['todayCompletedMinutes'] as int,
      nextSession: json['nextSession'] != null
          ? NextSessionModel.fromJson(json['nextSession'] as Map<String, dynamic>)
          : null,
      weakMaterials: (json['weakMaterials'] as List<dynamic>)
          .map((e) => WeakMaterialModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}