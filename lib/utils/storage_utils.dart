import 'package:base_bloc/config/constant.dart';
import 'package:base_bloc/data/globals.dart' as globals;
import 'package:get_storage/get_storage.dart';

import '../data/model/user_model.dart';

class StorageUtils {
  static void login(UserModel model) {
    GetStorage().write(StorageKey.userModel, model.toJson());
    globals.isLogin = true;
    globals.accessToken = model.token ?? '';
    globals.userId = model.userId ?? 0;
  }

  static void logout() {
    GetStorage().remove(StorageKey.userModel);
    globals.isLogin = false;
    globals.accessToken = '';
    globals.userId = 0;
  }

  static Future<void> getInfo() async {
    var userStr = await GetStorage().read(StorageKey.userModel);
    try {
      var userModel = UserModel.fromJson(userStr);
      globals.accessToken = userModel.token ?? '';
      globals.isLogin = true;
      globals.userId = userModel.userId ?? 0;
    } catch (ex) {
      globals.isLogin = false;
      globals.accessToken = '';
      globals.userId = 0;
    }
    /*if(isLogin != null) {
      globals.isLogin = isLogin;
    }*/
  }
}