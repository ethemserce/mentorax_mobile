import 'dart:async';

class AuthSession {
  static final StreamController<void> _unauthorizedController =
      StreamController<void>.broadcast();

  static Stream<void> get onUnauthorized => _unauthorizedController.stream;

  static void notifyUnauthorized() {
    if (!_unauthorizedController.isClosed) {
      _unauthorizedController.add(null);
    }
  }

  static void dispose() {
    _unauthorizedController.close();
  }
}