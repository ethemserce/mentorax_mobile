import 'package:flutter_test/flutter_test.dart';
import 'package:mentorax/features/study_sessions/data/session_elapsed_time.dart';

void main() {
  test('calculates elapsed seconds from startedAtUtc', () {
    final elapsed = SessionElapsedTime.secondsSinceStart(
      startedAtUtc: DateTime.utc(2026, 5, 1, 10),
      nowUtc: DateTime.utc(2026, 5, 1, 10, 7, 30),
    );

    expect(elapsed, 450);
  });

  test('does not return negative elapsed seconds', () {
    final elapsed = SessionElapsedTime.secondsSinceStart(
      startedAtUtc: DateTime.utc(2026, 5, 1, 10, 10),
      nowUtc: DateTime.utc(2026, 5, 1, 10),
    );

    expect(elapsed, 0);
  });

  test('rounds tracked seconds up to minutes', () {
    expect(SessionElapsedTime.roundedMinutes(0), 0);
    expect(SessionElapsedTime.roundedMinutes(1), 1);
    expect(SessionElapsedTime.roundedMinutes(60), 1);
    expect(SessionElapsedTime.roundedMinutes(61), 2);
  });
}
