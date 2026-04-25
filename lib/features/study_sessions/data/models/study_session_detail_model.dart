class StudySessionDetailModel {
  final String id;
  final String studyPlanId;
  final String? studyPlanItemId;
  final String learningMaterialId;
  final String? materialChunkId;
  final String planTitle;
  final String materialTitle;
  final String? chunkTitle;
  final String? chunkContent;
  final String? itemType;
  final int sequenceNumber;
  final DateTime scheduledAtUtc;
  final int plannedDurationMinutes;
  final String status;
  final DateTime? completedAtUtc;
  final int? actualDurationMinutes;
  final String? notes;

  StudySessionDetailModel({
    required this.id,
    required this.studyPlanId,
    required this.studyPlanItemId,
    required this.learningMaterialId,
    required this.materialChunkId,
    required this.planTitle,
    required this.materialTitle,
    required this.chunkTitle,
    required this.chunkContent,
    required this.itemType,
    required this.sequenceNumber,
    required this.scheduledAtUtc,
    required this.plannedDurationMinutes,
    required this.status,
    required this.completedAtUtc,
    required this.actualDurationMinutes,
    required this.notes,
  });

  factory StudySessionDetailModel.fromJson(Map<String, dynamic> json) {
    return StudySessionDetailModel(
      id: json['id'] as String,
      studyPlanId: json['studyPlanId'] as String,
      studyPlanItemId: json['studyPlanItemId'] as String?,
      learningMaterialId: json['learningMaterialId'] as String,
      materialChunkId: json['materialChunkId'] as String?,
      planTitle: json['planTitle'] as String,
      materialTitle: json['materialTitle'] as String,
      chunkTitle: json['chunkTitle'] as String?,
      chunkContent: json['chunkContent'] as String?,
      itemType: json['itemType'] as String?,
      sequenceNumber: json['sequenceNumber'] as int,
      scheduledAtUtc: _parseUtcDateTime(json['scheduledAtUtc'] as String),
      plannedDurationMinutes: json['plannedDurationMinutes'] as int,
      status: json['status'] as String,
      completedAtUtc: json['completedAtUtc'] != null
          ? _parseUtcDateTime(json['completedAtUtc'] as String)
          : null,
      actualDurationMinutes: json['actualDurationMinutes'] as int?,
      notes: json['notes'] as String?,
    );
  }
}

DateTime _parseUtcDateTime(String value) {
  final normalized = value.endsWith('Z') ? value : '${value}Z';
  return DateTime.parse(normalized);
}