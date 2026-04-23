class CreateStudyPlanRequest {
  final String learningMaterialId;
  final String title;
  final String startDate;
  final int dailyTargetMinutes;
  final int preferredHour;
  final List<int>? dayOffsets;

  CreateStudyPlanRequest({
    required this.learningMaterialId,
    required this.title,
    required this.startDate,
    required this.dailyTargetMinutes,
    required this.preferredHour,
    this.dayOffsets,
  });

  Map<String, dynamic> toJson() {
    return {
      'learningMaterialId': learningMaterialId,
      'title': title,
      'startDate': startDate,
      'dailyTargetMinutes': dailyTargetMinutes,
      'preferredHour': preferredHour,
      'dayOffsets': dayOffsets,
    };
  }
}