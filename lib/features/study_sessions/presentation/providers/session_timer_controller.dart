import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mentorax/features/study_sessions/data/session_elapsed_time.dart';
import 'session_timer_state.dart';

class SessionTimerController extends StateNotifier<SessionTimerState> {
  final DateTime Function() _now;
  Timer? _timer;
  DateTime? _startedAtUtc;

  SessionTimerController({DateTime Function()? now})
    : _now = now ?? (() => DateTime.now().toUtc()),
      super(const SessionTimerState.initial());

  void start({
    required String sessionId,
    required String materialTitle,
    DateTime? startedAtUtc,
  }) {
    _timer?.cancel();
    _startedAtUtc = (startedAtUtc ?? _now()).toUtc();

    state = SessionTimerState(
      isRunning: true,
      elapsedSeconds: _elapsedSeconds(),
      sessionId: sessionId,
      materialTitle: materialTitle,
    );

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      state = state.copyWith(elapsedSeconds: _elapsedSeconds());
    });
  }

  void stop() {
    _timer?.cancel();
    state = state.copyWith(isRunning: false);
  }

  void reset() {
    _timer?.cancel();
    _startedAtUtc = null;
    state = const SessionTimerState.initial();
  }

  int _elapsedSeconds() {
    return SessionElapsedTime.secondsSinceStart(
      startedAtUtc: _startedAtUtc,
      nowUtc: _now(),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
