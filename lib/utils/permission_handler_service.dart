import 'package:flutter/widgets.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionHandlerService {
  static Future<PermissionStatus> requestPermission({
    required Permission permission,
  }) async {
    try {
      final status = await permission.status;
      debugPrint("Permission status: $status");
      if (status.isGranted) {
        debugPrint("Permission is granted");
        return status;
      } else if (status.isDenied) {
        final result = await permission.request();
        debugPrint("Permission after request: $result");
        return result;
      }
      return status;
    } catch (e) {
      debugPrint("Failed to request permission: $e");
      return PermissionStatus.denied;
    }
  }
}
