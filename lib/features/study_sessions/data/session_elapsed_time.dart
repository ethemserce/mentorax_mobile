class SessionElapsedTime {
  const SessionElapsedTime._();

  static int secondsSinceStart({
    required DateTime? startedAtUtc,
    DateTime? nowUtc,
  }) {
    if (startedAtUtc == null) return 0;

    final now = (nowUtc ?? DateTime.now().toUtc()).toUtc();
    final startedAt = startedAtUtc.toUtc();
    final elapsed = now.difference(startedAt).inSeconds;

    return elapsed < 0 ? 0 : elapsed;
  }

  static int roundedMinutes(int elapsedSeconds) {
    if (elapsedSeconds <= 0) return 0;

    return (elapsedSeconds / 60).ceil();
  }
}
