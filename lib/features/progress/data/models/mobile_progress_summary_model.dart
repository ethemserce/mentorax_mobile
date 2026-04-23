class MobileProgressSummaryModel {
  final int totalMaterials;
  final int activePlans;
  final int strongCount;
  final int mediumCount;
  final int weakCount;
  final int todayCompletedSessions;
  final int currentStreakDays;

  MobileProgressSummaryModel({
    required this.totalMaterials,
    required this.activePlans,
    required this.strongCount,
    required this.mediumCount,
    required this.weakCount,
    required this.todayCompletedSessions,
    required this.currentStreakDays,
  });

  factory MobileProgressSummaryModel.fromJson(Map<String, dynamic> json) {
    return MobileProgressSummaryModel(
      totalMaterials: json['totalMaterials'] as int,
      activePlans: json['activePlans'] as int,
      strongCount: json['strongCount'] as int,
      mediumCount: json['mediumCount'] as int,
      weakCount: json['weakCount'] as int,
      todayCompletedSessions: json['todayCompletedSessions'] as int,
      currentStreakDays: json['currentStreakDays'] as int,
    );
  }
}