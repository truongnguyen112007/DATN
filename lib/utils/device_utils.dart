import 'dart:io';
import 'package:base_bloc/utils/log_utils.dart';
import 'package:device_info/device_info.dart';

import '../data/globals.dart' as global;

class DeviceUtils {
  DeviceUtils._();

  static Future<void> getInfo() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      var android = await deviceInfo.androidInfo;
      global.deviceModel = android.model.toString();
      global.deviceId = android.androidId.toString();
      global.deviceName = android.brand.toString();
    } else if (Platform.isIOS) {
      var iosInfo = await deviceInfo.iosInfo;
      global.deviceModel = iosInfo.localizedModel.toString();
      global.deviceName = iosInfo.systemName.toString();
      global.deviceId = iosInfo.identifierForVendor.toString();
    }
  }
}
