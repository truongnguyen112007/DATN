import 'package:base_bloc/components/dialogs.dart';
import 'package:base_bloc/data/model/user_model.dart';
import 'package:base_bloc/data/model/user_profile_model.dart';
import 'package:base_bloc/data/repository/user_repository.dart';
import 'package:base_bloc/modules/home/home_page.dart';
import 'package:base_bloc/modules/login/login_state.dart';
import 'package:base_bloc/router/router_utils.dart';
import 'package:base_bloc/utils/app_utils.dart';
import 'package:base_bloc/utils/log_utils.dart';
import 'package:base_bloc/utils/storage_utils.dart';
import 'package:base_bloc/utils/toast_utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/globals.dart' as globals;

import '../../data/model/playlist_model.dart';
import '../../localization/locale_keys.dart';

class LoginCubit extends Cubit<LoginState> {
  var userRepository = UserRepository();
  final bool isGoBack;
  LoginCubit(this.isGoBack) : super(const LoginState(errorEmail: '', errorPassword: '')){
    globals.isTokenExpired = false;
  }

  void onClickLogin(String email, String password, BuildContext context) async {
    bool isValidEmail = checkValidEmail(email);
    bool isValidPass = checkValidPassword(password);
    if (isValidPass && isValidEmail) {
      Dialogs.showLoadingDialog(context);
      var response = await userRepository.login(email, password);
      if (response.error != null) {
        await Dialogs.hideLoadingDialog();
        toast(response.error.toString());
      } else {
        var userModel = UserModel.fromJson(response.data);
        StorageUtils.login(UserModel.fromJson(response.data));
        await getUserProfile(userModel);
        await checkPlaylistId(userModel);
        await Dialogs.hideLoadingDialog();
        Utils.hideKeyboard(context);
        toast(LocaleKeys.login_success.tr());
        if(isGoBack) {
          RouterUtils.pop(context);
        } else {
          RouterUtils.openNewPage(const HomePage(), context, isReplace: true);
        }
      }
    }
  }

  Future<void> createPlaylist(UserModel userModel) async {
    var userResponse =
    await userRepository.createPlaylist('', userModel.userId ?? 0);
    if (userResponse.data != null && userResponse.error == null) {
      checkPlaylistId(userModel);
    }
  }

  Future<void> getUserProfile(UserModel userModel) async{
    var response = await userRepository.getUserProfile(userModel.userId??0);
    if(response.error==null && response.data!=null){
      var userProfile = UserProfileModel.fromJson(response.data);
      StorageUtils.saveUserProfile(userProfile);
    }
  }

  Future<void> checkPlaylistId(UserModel userModel) async {
    var response = await userRepository.getPlaylists();
    if (response.error == null && response.data != null) {
      try {
        var lPlaylist = playListModelFromJson(response.data);
        globals.playlistId = lPlaylist[0].id ?? '';
        StorageUtils.savePlaylistId(globals.playlistId);
      } catch (ex) {
        createPlaylist(userModel);
      }
    }
}

bool checkValidEmail(String email) {
  bool isValid = false;
  if (email.isEmpty) {
    isValid = false;
    emit(state.copyOf(errorEmail: LocaleKeys.please_input_email.tr()));
  } else if (!EmailValidator.validate(email)) {
    emit(state.copyOf(errorEmail: LocaleKeys.please_input_valid_email.tr()));
    isValid = false;
  } else {
    isValid = true;
    emit(state.copyOf(errorEmail: ''));
  }
  return isValid;
}

bool checkValidPassword(String password) {
  bool isValid = false;
  if (password.isEmpty) {
    isValid = false;
    emit(state.copyOf(errorPassword: LocaleKeys.please_input_pass.tr()));
  } else if (!Utils.validatePassword(password)) {
    emit(state.copyOf(errorPassword: LocaleKeys.please_input_valid_pass.tr()));
    isValid = false;
  } else {
    isValid = true;
    emit(state.copyOf(errorPassword: ''));
  }
  return isValid;
}}
