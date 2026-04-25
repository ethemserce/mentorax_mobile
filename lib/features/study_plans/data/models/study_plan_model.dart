import 'package:mentorax/features/study_plans/data/models/study_plan_item_model.dart';

import 'study_plan_session_model.dart';

class StudyPlanModel {
  final String id;
  final String userId;
  final String learningMaterialId;
  final String title;
  final String startDate;
  final int dailyTargetMinutes;
  final String status;
  final List<StudyPlanSessionModel> sessions;
  final List<StudyPlanItemModel> items;

  StudyPlanModel({
    required this.id,
    required this.userId,
    required this.learningMaterialId,
    required this.title,
    required this.startDate,
    required this.dailyTargetMinutes,
    required this.status,
    required this.sessions,
    required this.items,
  });

  int get totalSessions => sessions.length;

  int get completedSessions =>
      sessions.where((x) => x.completedAtUtc != null).length;

  int get remainingSessions => totalSessions - completedSessions;

  double get progress =>
      totalSessions == 0 ? 0 : completedSessions / totalSessions;

  bool get isActive => status.toLowerCase() == 'active';

  StudyPlanSessionModel? get nextPendingSession {
    final pending = sessions
        .where((x) => x.completedAtUtc == null)
        .toList()
      ..sort((a, b) => a.scheduledAtUtc.compareTo(b.scheduledAtUtc));

    if (pending.isEmpty) return null;
    return pending.first;
  }

  factory StudyPlanModel.fromJson(Map<String, dynamic> json) {
    return StudyPlanModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      learningMaterialId: json['learningMaterialId'] as String,
      title: json['title'] as String,
      startDate: json['startDate'] as String,
      dailyTargetMinutes: json['dailyTargetMinutes'] as int,
      status: json['status'] as String,
sessions: ((json['sessions'] as List?) ?? [])
    .map((e) => StudyPlanSessionModel.fromJson(e as Map<String, dynamic>))
    .toList(),
items: ((json['items'] as List?) ?? [])
    .map((x) => StudyPlanItemModel.fromJson(x as Map<String, dynamic>))
    .toList(),
    );
  }
}