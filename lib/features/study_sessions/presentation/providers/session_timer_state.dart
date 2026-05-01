class SessionTimerState {
  final bool isRunning;
  final int elapsedSeconds;
  final String? sessionId;
  final String? materialTitle;

  const SessionTimerState({
    required this.isRunning,
    required this.elapsedSeconds,
    required this.sessionId,
    required this.materialTitle,
  });

  const SessionTimerState.initial()
    : isRunning = false,
      elapsedSeconds = 0,
      sessionId = null,
      materialTitle = null;

  SessionTimerState copyWith({
    bool? isRunning,
    int? elapsedSeconds,
    String? sessionId,
    String? materialTitle,
  }) {
    return SessionTimerState(
      isRunning: isRunning ?? this.isRunning,
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
      sessionId: sessionId ?? this.sessionId,
      materialTitle: materialTitle ?? this.materialTitle,
    );
  }
}
