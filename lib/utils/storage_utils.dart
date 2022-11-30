import 'package:base_bloc/config/constant.dart';
import 'package:base_bloc/data/globals.dart' as globals;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
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
    GetStorage().remove(StorageKey.playlistId);
    GetStorage().remove(StorageKey.userModel);
    globals.isLogin = false;
    globals.accessToken = '';
    globals.playlistId = '';
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
  }

  static Future<void> savePlaylistId(String playlistId) =>
      GetStorage().write(StorageKey.playlistId, playlistId);

  static Future<String?> getPlaylistId() async {
    var playlistId = await GetStorage().read(StorageKey.playlistId);
    return playlistId;
  }

  static Future<void> saveGuideline(bool isGuideline) async =>
      await GetStorage().write(StorageKey.isGuideline, isGuideline);

  static Future<bool> getGuideline() async =>
      await GetStorage().read(StorageKey.isGuideline) ?? false;

  static Future<void> saveLanguageCode(String code) async {
    globals.languageCode = code;
    return await GetStorage().write(StorageKey.languageCode, code);
  }

  static Future<String> getLanguageCode(BuildContext context) async {
    var languageCode = await GetStorage().read(StorageKey.languageCode) ?? context.locale.languageCode;
    globals.languageCode = languageCode;
    return languageCode;
  }}
