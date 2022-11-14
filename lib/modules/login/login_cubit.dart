import 'package:base_bloc/components/dialogs.dart';
import 'package:base_bloc/config/constant.dart';
import 'package:base_bloc/data/model/user_model.dart';
import 'package:base_bloc/data/repository/user_repository.dart';
import 'package:base_bloc/localizations/app_localazations.dart';
import 'package:base_bloc/modules/home/home_page.dart';
import 'package:base_bloc/modules/login/login_state.dart';
import 'package:base_bloc/router/router_utils.dart';
import 'package:base_bloc/utils/app_utils.dart';
import 'package:base_bloc/utils/log_utils.dart';
import 'package:base_bloc/utils/storage_utils.dart';
import 'package:base_bloc/utils/toast_utils.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/globals.dart' as globals;
import 'package:dio/dio.dart';

import '../../data/model/playlist_model.dart';

class LoginCubit extends Cubit<LoginState> {
  var userRepository = UserRepository();

  LoginCubit() : super(const LoginState(errorEmail: '', errorPassword: ''));

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
        await checkPlaylistId(userModel);
        await Dialogs.hideLoadingDialog();
        toast(LocaleKeys.login_success);
        RouterUtils.openNewPage(const HomePage(), context, isReplace: true);
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
    emit(state.copyOf(errorEmail: LocaleKeys.please_input_email));
  } else if (!EmailValidator.validate(email)) {
    emit(state.copyOf(errorEmail: LocaleKeys.please_input_valid_email));
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
    emit(state.copyOf(errorPassword: LocaleKeys.please_input_pass));
  } else if (!Utils.validatePassword(password)) {
    emit(state.copyOf(errorPassword: LocaleKeys.please_input_valid_pass));
    isValid = false;
  } else {
    isValid = true;
    emit(state.copyOf(errorPassword: ''));
  }
  return isValid;
}}
