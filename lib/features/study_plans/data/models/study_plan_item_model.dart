import 'package:mentorax/features/materials/data/models/material_chunk_model.dart';
import 'study_plan_session_model.dart';

class StudyPlanItemModel {
  final String id;
  final String studyPlanId;
  final String? materialChunkId;
  final String title;
  final String? description;
  final String itemType;
  final int orderNo;
  final DateTime plannedDateUtc;
  final String? plannedStartTime;
  final String? plannedEndTime;
  final int durationMinutes;
  final String status;
  final MaterialChunkModel? materialChunk;
  final List<StudyPlanSessionModel> sessions;

  StudyPlanItemModel({
    required this.id,
    required this.studyPlanId,
    required this.materialChunkId,
    required this.title,
    required this.description,
    required this.itemType,
    required this.orderNo,
    required this.plannedDateUtc,
    required this.plannedStartTime,
    required this.plannedEndTime,
    required this.durationMinutes,
    required this.status,
    required this.materialChunk,
    required this.sessions,
  });

  factory StudyPlanItemModel.fromJson(Map<String, dynamic> json) {
    return StudyPlanItemModel(
      id: json['id'] as String,
      studyPlanId: json['studyPlanId'] as String,
      materialChunkId: json['materialChunkId'] as String?,
      title: json['title'] as String,
      description: json['description'] as String?,
      itemType: json['itemType'] as String,
      orderNo: json['orderNo'] as int,
      plannedDateUtc: _parseUtcDateTime(json['plannedDateUtc'] as String),
      plannedStartTime: json['plannedStartTime'] as String?,
      plannedEndTime: json['plannedEndTime'] as String?,
      durationMinutes: json['durationMinutes'] as int,
      status: json['status'] as String,
      materialChunk: json['materialChunk'] == null
          ? null
          : MaterialChunkModel.fromJson(
              json['materialChunk'] as Map<String, dynamic>,
            ),
      sessions: ((json['sessions'] as List?) ?? [])
          .map((x) => StudyPlanSessionModel.fromJson(x as Map<String, dynamic>))
          .toList(),
    );
  }
}

DateTime _parseUtcDateTime(String value) {
  final normalized = value.endsWith('Z') ? value : '${value}Z';
  return DateTime.parse(normalized);
}