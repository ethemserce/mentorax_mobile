import 'package:mentorax/features/dashboard/data/models/mobile_dashboard_model.dart';
import 'package:mentorax/features/dashboard/data/models/next_session_model.dart';
import 'package:mentorax/features/materials/data/models/material_chunk_model.dart';
import 'package:mentorax/features/materials/data/models/material_model.dart';
import 'package:mentorax/features/study_plans/data/models/study_plan_model.dart';

class SyncBootstrapModel {
  final DateTime serverTimeUtc;
  final List<StudyPlanModel> studyPlans;
  final List<MaterialModel> materials;
  final List<MaterialChunkModel> materialChunks;
  final MobileDashboardModel dashboard;
  final NextSessionModel? nextSession;

  SyncBootstrapModel({
    required this.serverTimeUtc,
    required this.studyPlans,
    required this.materials,
    required this.materialChunks,
    required this.dashboard,
    required this.nextSession,
  });

  factory SyncBootstrapModel.fromJson(Map<String, dynamic> json) {
    return SyncBootstrapModel(
      serverTimeUtc: _parseUtcDateTime(json['serverTimeUtc'] as String),
      studyPlans: ((json['studyPlans'] as List?) ?? [])
          .map((item) => StudyPlanModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      materials: ((json['materials'] as List?) ?? [])
          .map((item) => MaterialModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      materialChunks: ((json['materialChunks'] as List?) ?? [])
          .map(
            (item) => MaterialChunkModel.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
      dashboard: MobileDashboardModel.fromJson(
        json['dashboard'] as Map<String, dynamic>,
      ),
      nextSession: json['nextSession'] == null
          ? null
          : NextSessionModel.fromJson(
              json['nextSession'] as Map<String, dynamic>,
            ),
    );
  }
}

class SyncChangesModel {
  final DateTime serverTimeUtc;
  final List<SyncChangeModel> changes;

  SyncChangesModel({required this.serverTimeUtc, required this.changes});

  factory SyncChangesModel.fromJson(Map<String, dynamic> json) {
    return SyncChangesModel(
      serverTimeUtc: _parseUtcDateTime(json['serverTimeUtc'] as String),
      changes: ((json['changes'] as List?) ?? [])
          .map((item) => SyncChangeModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

class SyncChangeModel {
  final String entityType;
  final String entityId;
  final String changeType;
  final DateTime changedAtUtc;
  final Map<String, dynamic>? payload;

  SyncChangeModel({
    required this.entityType,
    required this.entityId,
    required this.changeType,
    required this.changedAtUtc,
    required this.payload,
  });

  factory SyncChangeModel.fromJson(Map<String, dynamic> json) {
    final payload = json['payload'];

    return SyncChangeModel(
      entityType: json['entityType'] as String,
      entityId: json['entityId'] as String,
      changeType: json['changeType'] as String,
      changedAtUtc: _parseUtcDateTime(json['changedAtUtc'] as String),
      payload: payload is Map ? Map<String, dynamic>.from(payload) : null,
    );
  }
}

class SyncPushResponse {
  final DateTime serverTimeUtc;
  final List<SyncPushOperationResult> results;

  SyncPushResponse({required this.serverTimeUtc, required this.results});

  factory SyncPushResponse.fromJson(Map<String, dynamic> json) {
    return SyncPushResponse(
      serverTimeUtc: _parseUtcDateTime(json['serverTimeUtc'] as String),
      results: (json['results'] as List<dynamic>)
          .map(
            (item) =>
                SyncPushOperationResult.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
    );
  }
}

class SyncPushOperationResult {
  final String operationId;
  final String status;
  final String? error;

  SyncPushOperationResult({
    required this.operationId,
    required this.status,
    required this.error,
  });

  factory SyncPushOperationResult.fromJson(Map<String, dynamic> json) {
    return SyncPushOperationResult(
      operationId: json['operationId'] as String,
      status: json['status'] as String,
      error: json['error'] as String?,
    );
  }
}

class SyncRunResult {
  final int attemptedCount;
  final int syncedCount;
  final int retryCount;
  final int conflictCount;

  const SyncRunResult({
    required this.attemptedCount,
    required this.syncedCount,
    required this.retryCount,
    this.conflictCount = 0,
  });

  static const empty = SyncRunResult(
    attemptedCount: 0,
    syncedCount: 0,
    retryCount: 0,
    conflictCount: 0,
  );
}

DateTime _parseUtcDateTime(String value) {
  final normalized = value.endsWith('Z') ? value : '${value}Z';
  return DateTime.parse(normalized);
}
