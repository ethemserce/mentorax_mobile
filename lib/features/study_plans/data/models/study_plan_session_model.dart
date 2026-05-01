class StudyPlanSessionModel {
  final String id;
  final String studyPlanId;
  final int sequenceNumber;
  final DateTime scheduledAtUtc;
  final int plannedDurationMinutes;
  final String status;
  final DateTime? completedAtUtc;
  final int? actualDurationMinutes;
  final String? notes;
  final double? easinessFactor;
  final int? intervalDays;
  final int? repetitionCount;

  StudyPlanSessionModel({
    required this.id,
    required this.studyPlanId,
    required this.sequenceNumber,
    required this.scheduledAtUtc,
    required this.plannedDurationMinutes,
    required this.status,
    required this.completedAtUtc,
    required this.actualDurationMinutes,
    required this.notes,
    required this.easinessFactor,
    required this.intervalDays,
    required this.repetitionCount,
  });

  factory StudyPlanSessionModel.fromJson(Map<String, dynamic> json) {
    return StudyPlanSessionModel(
      id: json['id'] as String,
      studyPlanId: json['studyPlanId'] as String,
      sequenceNumber: json['sequenceNumber'] as int,
      scheduledAtUtc: parseUtcDateTime(json['scheduledAtUtc'] as String),
      plannedDurationMinutes: json['plannedDurationMinutes'] as int,
      status: json['status'] as String,
      completedAtUtc: json['completedAtUtc'] != null
          ? parseUtcDateTime(json['completedAtUtc'] as String)
          : null,
      actualDurationMinutes: json['actualDurationMinutes'] as int?,
      notes: json['notes'] as String?,
      easinessFactor: (json['easinessFactor'] as num?)?.toDouble(),
      intervalDays: json['intervalDays'] as int?,
      repetitionCount: json['repetitionCount'] as int?,
    );
  }
}

DateTime parseUtcDateTime(String value) {
  final normalized = value.endsWith('Z') ? value : '${value}Z';
  return DateTime.parse(normalized);
}
