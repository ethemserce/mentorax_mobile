import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'session_timer_state.dart';

class SessionTimerController extends StateNotifier<SessionTimerState> {
  Timer? _timer;

  SessionTimerController() : super(const SessionTimerState.initial());

  void start({
    required String sessionId,
    required String materialTitle,
  }) {
    _timer?.cancel();

    state = SessionTimerState(
      isRunning: true,
      elapsedSeconds: 0,
      sessionId: sessionId,
      materialTitle: materialTitle,
    );

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      state = state.copyWith(
        elapsedSeconds: state.elapsedSeconds + 1,
      );
    });
  }

  void stop() {
    _timer?.cancel();
    state = state.copyWith(isRunning: false);
  }

  void reset() {
    _timer?.cancel();
    state = const SessionTimerState.initial();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}