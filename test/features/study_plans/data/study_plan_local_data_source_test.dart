import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mentorax/core/database/app_database.dart';
import 'package:mentorax/features/dashboard/data/dashboard_local_data_source.dart';
import 'package:mentorax/features/study_plans/data/models/study_plan_detail_model.dart';
import 'package:mentorax/features/study_plans/data/models/study_plan_item_model.dart';
import 'package:mentorax/features/study_plans/data/models/study_plan_model.dart';
import 'package:mentorax/features/study_plans/data/models/study_plan_session_model.dart';
import 'package:mentorax/features/study_plans/data/study_plan_local_data_source.dart';
import 'package:mentorax/features/study_plans/data/study_plan_repository.dart';
import 'package:mentorax/features/study_plans/data/study_plan_service.dart';

void main() {
  late AppDatabase database;
  late StudyPlanLocalDataSource studyPlans;
  late DashboardLocalDataSource dashboard;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    studyPlans = StudyPlanLocalDataSource(database);
    dashboard = DashboardLocalDataSource(database);
  });

  tearDown(() async {
    await database.close();
  });

  test('caches study plans and exposes offline sessions', () async {
    final plan = _samplePlan();

    await studyPlans.cachePlans([plan]);

    final cachedPlans = await studyPlans.getPlans();
    final cachedDetail = await studyPlans.getPlanById('plan-1');
    final cachedNextSession = await dashboard.getNextSession();
    final cachedDashboard = await dashboard.getDashboard();

    expect(cachedPlans, hasLength(1));
    expect(cachedPlans.single.title, 'Offline Plan');
    expect(cachedPlans.single.sessions.single.id, 'session-1');
    expect(cachedDetail?.items.single.sessions.single.id, 'session-1');
    expect(cachedNextSession?.sessionId, 'session-1');
    expect(cachedNextSession?.isDue, isTrue);
    expect(cachedDashboard?.todayPlannedMinutes, 30);
    expect(cachedDashboard?.dueCount, 1);
  });

  test('repository falls back to cached plans when remote fails', () async {
    final plan = _samplePlan();
    final repository = StudyPlanRepository(
      remote: _FailingStudyPlanService(),
      local: studyPlans,
    );

    await studyPlans.cachePlans([plan]);

    final cachedPlans = await repository.getPlans();
    final cachedDetail = await repository.getPlanById(plan.id);

    expect(cachedPlans.single.id, plan.id);
    expect(cachedDetail.id, plan.id);
    expect(cachedDetail.sessions.single.id, 'session-1');
  });
}

StudyPlanModel _samplePlan() {
  final now = DateTime.now();
  final todayStart = DateTime(now.year, now.month, now.day);
  final scheduledLocal =
      now.difference(todayStart) > const Duration(minutes: 15)
      ? now.subtract(const Duration(minutes: 10))
      : todayStart;
  final scheduledAt = scheduledLocal.toUtc();
  final session = StudyPlanSessionModel(
    id: 'session-1',
    studyPlanId: 'plan-1',
    sequenceNumber: 1,
    scheduledAtUtc: scheduledAt,
    plannedDurationMinutes: 30,
    status: 'Pending',
    completedAtUtc: null,
    actualDurationMinutes: null,
    notes: null,
    easinessFactor: null,
    intervalDays: null,
    repetitionCount: null,
  );

  return StudyPlanModel(
    id: 'plan-1',
    userId: 'user-1',
    learningMaterialId: 'material-1',
    title: 'Offline Plan',
    startDate: '2026-05-01',
    dailyTargetMinutes: 30,
    status: 'Active',
    sessions: [session],
    items: [
      StudyPlanItemModel(
        id: 'item-1',
        studyPlanId: 'plan-1',
        materialChunkId: null,
        title: 'Read chunk',
        description: null,
        itemType: 'NewStudy',
        orderNo: 1,
        plannedDateUtc: scheduledAt,
        plannedStartTime: null,
        plannedEndTime: null,
        durationMinutes: 30,
        status: 'Pending',
        materialChunk: null,
        sessions: [session],
      ),
    ],
  );
}

class _FailingStudyPlanService extends StudyPlanService {
  @override
  Future<List<StudyPlanModel>> getPlans() {
    throw Exception('network unavailable');
  }

  @override
  Future<StudyPlanDetailModel> getPlanById(String planId) {
    throw Exception('network unavailable');
  }
}
