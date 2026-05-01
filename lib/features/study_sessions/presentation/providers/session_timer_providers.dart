import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'session_timer_controller.dart';
import 'session_timer_state.dart';

final sessionTimerProvider =
    StateNotifierProvider<SessionTimerController, SessionTimerState>((ref) {
      return SessionTimerController();
    });
