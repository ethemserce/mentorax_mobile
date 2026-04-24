class NextSessionModel {
  final String sessionId;
  final String studyPlanId;
  final String materialId;
  final String materialTitle;
  final DateTime scheduledAtUtc;
  final DateTime? startedAtUtc;
  final int estimatedMinutes;
  final bool isDue;

  NextSessionModel({
    required this.sessionId,
    required this.studyPlanId,
    required this.materialId,
    required this.materialTitle,
    required this.scheduledAtUtc,
    required this.startedAtUtc,
    required this.estimatedMinutes,
    required this.isDue,
  });

  factory NextSessionModel.fromJson(Map<String, dynamic> json) {
    return NextSessionModel(
      sessionId: json['sessionId'] as String,
      studyPlanId: json['studyPlanId'] as String,
      materialId: json['materialId'] as String,
      materialTitle: json['materialTitle'] as String,
scheduledAtUtc: DateTime.parse('${json['scheduledAtUtc']}Z'),
startedAtUtc: json['startedAtUtc'] != null
    ? DateTime.parse('${json['startedAtUtc']}Z')
    : null,
      estimatedMinutes: json['estimatedMinutes'] as int,
      isDue: json['isDue'] as bool,
    );
  }
}