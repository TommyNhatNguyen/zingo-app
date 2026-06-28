import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationPermissionCubit extends Cubit<bool> {
  static const key = 'notification_permission';

  NotificationPermissionCubit() : super(false) {
    _loadSaved();
  }

  Future<void> _loadSaved() async {
    final prefs = await SharedPreferences.getInstance();
    final isGranted = prefs.getBool(key);
    if (isGranted != null) emit(isGranted);
  }

  Future<void> setPermission(bool isGranted) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, isGranted);
    emit(isGranted);
  }
}
