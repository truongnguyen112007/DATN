import 'dart:convert';

import 'package:base_bloc/config/constant.dart';
import 'package:base_bloc/data/globals.dart' as globals;
import 'package:base_bloc/data/model/user_profile_model.dart';
import 'package:base_bloc/utils/log_utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_storage/get_storage.dart';
import '../data/model/hold_set_model.dart';
import '../data/model/user_model.dart';

class StorageUtils {
  static void login(UserModel model) {
    GetStorage().write(StorageKey.userModel, model.toJson());
    globals.isLogin = true;
    globals.accessToken = model.token ?? '';
    globals.refreshToken = model.refreshToken ?? '';
    globals.userId = model.userId ?? 0;
    globals.isTokenExpired = false;
  }

  static void logout() {
    GetStorage().remove(StorageKey.userProfile);
    GetStorage().remove(StorageKey.playlistId);
    GetStorage().remove(StorageKey.userModel);
    globals.isLogin = false;
    globals.accessToken = '';
    globals.playlistId = '';
    globals.lastName = '';
    globals.firstName = '';
    globals.userId = 0;
  }

  static Future<void> saveHoldSets(List<HoldSetModel> lHoldSet) async {
    GetStorage().remove(StorageKey.holdSet);
    GetStorage().write(StorageKey.holdSet,
        jsonEncode(lHoldSet.map((e) => e.toJson()).toList()));
  }

  static Future<List<HoldSetModel>> getHoldSet() async {
    var response = await GetStorage().read(StorageKey.holdSet);
    if (response == null) return [];
    var result = holdSetModelFromJson(json.decode(response));
    return result;
  }

  static Future<UserModel?> getUser() async {
    var userStr = await GetStorage().read(StorageKey.userModel);
    try {
      var userModel = UserModel.fromJson(userStr);
      globals.accessToken = userModel.token ?? '';
      globals.isLogin = true;
      globals.refreshToken = userModel.refreshToken??'';
      globals.userId = userModel.userId ?? 0;
      return userModel;
    } catch (ex) {
      globals.isLogin = false;
      globals.accessToken = '';
      globals.userId = 0;
    }
    return null;
  }

  static Future<void> saveUserProfile(UserProfileModel model) async {
    globals.lastName = model.lastName ?? '';
    globals.firstName = model.firstName ?? '';
    await GetStorage().write(StorageKey.userProfile, model.toJson());
  }

  static Future<UserProfileModel?> getUserProfile() async {
    var profileStr = GetStorage().read(StorageKey.userProfile) ?? "";
    if (profileStr.isNotEmpty) {
      var profileModel = UserProfileModel.fromJson(profileStr);
      globals.lastName = profileModel.lastName ?? '';
      globals.firstName = profileModel.firstName ?? '';
      globals.accountId = profileModel.accountId ?? 0;
    return profileModel;
    }
    return null;
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
