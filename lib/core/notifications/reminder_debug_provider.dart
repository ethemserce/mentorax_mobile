import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'reminder_debug_state.dart';

class ReminderDebugController extends StateNotifier<ReminderDebugState> {
  ReminderDebugController() : super(const ReminderDebugState.empty());

  void update(ReminderDebugState state) {
    this.state = state;
  }

  void clear() {
    state = const ReminderDebugState.empty();
  }
}

final reminderDebugProvider =
    StateNotifierProvider<ReminderDebugController, ReminderDebugState>((ref) {
  return ReminderDebugController();
});