import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class SyncStateStorage {
  Future<DateTime?> getLastSyncAt();
  Future<void> saveLastSyncAt(DateTime value);
  Future<void> clearLastSyncAt();
}

class SecureSyncStateStorage implements SyncStateStorage {
  static const _lastSyncAtKey = 'sync_last_sync_at_utc';

  final FlutterSecureStorage _storage;

  SecureSyncStateStorage({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  @override
  Future<DateTime?> getLastSyncAt() async {
    final rawValue = await _storage.read(key: _lastSyncAtKey);
    if (rawValue == null || rawValue.isEmpty) return null;

    return DateTime.tryParse(rawValue)?.toUtc();
  }

  @override
  Future<void> saveLastSyncAt(DateTime value) {
    return _storage.write(
      key: _lastSyncAtKey,
      value: value.toUtc().toIso8601String(),
    );
  }

  @override
  Future<void> clearLastSyncAt() {
    return _storage.delete(key: _lastSyncAtKey);
  }
}
