class ReminderDebugState {
  final String? lastAction;
  final String? sessionId;
  final String? planId;
  final DateTime? sessionTime;
  final DateTime? reminderTime;
  final String? message;

  const ReminderDebugState({
    this.lastAction,
    this.sessionId,
    this.planId,
    this.sessionTime,
    this.reminderTime,
    this.message,
  });

  const ReminderDebugState.empty()
      : lastAction = null,
        sessionId = null,
        planId = null,
        sessionTime = null,
        reminderTime = null,
        message = null;

  ReminderDebugState copyWith({
    String? lastAction,
    String? sessionId,
    String? planId,
    DateTime? sessionTime,
    DateTime? reminderTime,
    String? message,
  }) {
    return ReminderDebugState(
      lastAction: lastAction ?? this.lastAction,
      sessionId: sessionId ?? this.sessionId,
      planId: planId ?? this.planId,
      sessionTime: sessionTime ?? this.sessionTime,
      reminderTime: reminderTime ?? this.reminderTime,
      message: message ?? this.message,
    );
  }
}