import 'package:mentorax/core/database/app_database.dart';

import 'models/mobile_progress_summary_model.dart';

class ProgressLocalDataSource {
  final AppDatabase _database;
  final DateTime Function() _now;

  ProgressLocalDataSource(this._database, {DateTime Function()? now})
    : _now = now ?? DateTime.now;

  Future<MobileProgressSummaryModel> getSummary() async {
    final materials = await _database.select(_database.localMaterials).get();
    final plans = await _database.select(_database.localStudyPlans).get();
    final sessions = await _database.select(_database.localStudySessions).get();

    final activeMaterials = materials
        .where((material) => !material.isDeleted)
        .toList();
    final activePlans = plans
        .where(
          (plan) => !plan.isDeleted && plan.status.toLowerCase() == 'active',
        )
        .toList();
    final completedSessions = sessions
        .where(
          (session) =>
              !session.isDeleted &&
              session.isCompleted &&
              session.completedAtUtc != null,
        )
        .toList();

    final now = _now();
    final today = _dateOnly(now);
    final completedDays = completedSessions
        .map((session) => _dateOnly(session.completedAtUtc!.toLocal()))
        .toSet();
    final performanceBuckets = _performanceBuckets(completedSessions);

    return MobileProgressSummaryModel(
      totalMaterials: activeMaterials.length,
      activePlans: activePlans.length,
      strongCount: performanceBuckets.strong,
      mediumCount: performanceBuckets.medium,
      weakCount: performanceBuckets.weak,
      todayCompletedSessions: completedSessions
          .where(
            (session) => _dateOnly(session.completedAtUtc!.toLocal()) == today,
          )
          .length,
      currentStreakDays: _calculateStreak(completedDays, today),
    );
  }

  _PerformanceBuckets _performanceBuckets(
    List<LocalStudySession> completedSessions,
  ) {
    final scoresByMaterial = <String, List<int>>{};

    for (final session in completedSessions) {
      final qualityScore = session.qualityScore;

      if (qualityScore == null) continue;

      scoresByMaterial
          .putIfAbsent(session.learningMaterialId, () => <int>[])
          .add(qualityScore);
    }

    var strong = 0;
    var medium = 0;
    var weak = 0;

    for (final scores in scoresByMaterial.values) {
      final averageScore =
          scores.fold<int>(0, (sum, score) => sum + score) / scores.length;

      if (averageScore >= 4) {
        strong += 1;
      } else if (averageScore >= 3) {
        medium += 1;
      } else {
        weak += 1;
      }
    }

    return _PerformanceBuckets(strong: strong, medium: medium, weak: weak);
  }

  int _calculateStreak(Set<DateTime> completedDays, DateTime today) {
    var streak = 0;
    var cursor = today;

    while (completedDays.contains(cursor)) {
      streak += 1;
      cursor = cursor.subtract(const Duration(days: 1));
    }

    return streak;
  }

  DateTime _dateOnly(DateTime value) {
    final local = value.toLocal();
    return DateTime(local.year, local.month, local.day);
  }
}

class _PerformanceBuckets {
  final int strong;
  final int medium;
  final int weak;

  const _PerformanceBuckets({
    required this.strong,
    required this.medium,
    required this.weak,
  });
}
