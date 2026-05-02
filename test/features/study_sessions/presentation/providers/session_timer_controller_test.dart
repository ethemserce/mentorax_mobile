import 'package:flutter_test/flutter_test.dart';
import 'package:mentorax/features/study_sessions/presentation/providers/session_timer_controller.dart';

void main() {
  test('starts from persisted session start time', () {
    final controller = SessionTimerController(
      now: () => DateTime.utc(2026, 5, 1, 10, 5),
    );

    controller.start(
      sessionId: 'session-1',
      materialTitle: 'Offline Material',
      startedAtUtc: DateTime.utc(2026, 5, 1, 10),
    );

    expect(controller.state.isRunning, isTrue);
    expect(controller.state.sessionId, 'session-1');
    expect(controller.state.elapsedSeconds, 300);

    controller.dispose();
  });
}
