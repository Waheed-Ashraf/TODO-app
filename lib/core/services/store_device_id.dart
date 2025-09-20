// lib/core/services/device_id_service.dart
import 'package:uuid/uuid.dart';
import 'package:todo_app_task/core/services/shared_preferences_singleton.dart';

class DeviceIdService {
  static const _kKey = 'install_device_id';

  static Future<String> getOrCreate() async {
    final existing = Prefs.getString(_kKey);
    if (existing != null && existing.isNotEmpty) return existing;
    final id = const Uuid().v4();
    await Prefs.setString(_kKey, id);
    return id;
  }
}
