import 'package:base_bloc/utils/log_utils.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionUtils {
  static Future<bool> isRequestPermission(Permission permission,
      {bool isRequest = false}) async {
    var isLocation = await permission.isDenied;
    if (isLocation) {
      if (isRequest) return false;
      var result = await permission.request();
      if (result.isGranted) return true;
      return false;
    }
    return true;
  }
}
