import 'dart:async';

import 'package:base_bloc/components/dialogs.dart';
import 'package:base_bloc/data/model/user_profile_model.dart';
import 'package:base_bloc/data/repository/user_repository.dart';
import 'package:base_bloc/utils/app_utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data/globals.dart' as globals;
import '../../../../data/model/profile_model.dart';
import '../../../../localization/locale_keys.dart';
import '../../../../utils/log_utils.dart';
import '../../../../utils/storage_utils.dart';
import '../../../../utils/toast_utils.dart';
import 'edit_account_state.dart';

enum AccountFieldType {
  NICKNAME,
  NAME,
  SURNAME,
  TYPE,
  HEIGHT,
  FAVORITE_ROUTE_GRADE,
  EMAIL
}

class EditAccountCubit extends Cubit<EditAccountState> {
  var userRepository = UserRepository();
  final VoidCallback editAccountCallBack;

  EditAccountCubit(this.editAccountCallBack)
      : super(const EditAccountState(status: EditAccountStatus.initial)) {
    if (state.status == EditAccountStatus.initial) {}
    getData();
  }

  void getData() async {
    // var userModel = await StorageUtils.getUserProfile();
    // emit(EditAccountState(model: userModel));
  }

  void saveInfo(BuildContext context, String firstname, String lastName,
      String role, String height, String email) {
    Dialogs.showWidgetDialog(context, callback: () async {
      await Dialogs.hideLoadingDialog();
      Utils.hideKeyboard(context);
      await Future.delayed(Duration(milliseconds: 200));
      Dialogs.showLoadingDialog(context);
      var response = await userRepository.updateUserProfile(
          first_name: firstname,
          last_name: lastName,
          role: role,
          height: height,
          /* photo: photo*/
          email: email);
      await Dialogs.hideLoadingDialog();
      if (response.statusCode == 201) {
        await getUserProfile();
      }
      editAccountCallBack.call();
      toast("Update Info Success");
      emit(state.copyWith(isOnChangeInfo: false));
    }, text: "Do you want to save changes?");
  }

  bool checkInfoProfile(String firstname, String lastName, String role,
      String height, String email) {
    bool isValid = false;
    if (firstname.isEmpty) {
      isValid = false;
      emit(state.copyWith(
          errorName: "You cannot leave this information blank!"));
    } else {
      emit(state.copyWith(errorName: ""));
    }
    if (lastName.isEmpty) {
      isValid = false;
      emit(state.copyWith(
          errorSurname: "You cannot leave this information blank!"));
    } else {
      emit(state.copyWith(errorSurname: ""));
    }
    if (role.isEmpty) {
      isValid = false;
      emit(state.copyWith(
          errorType: "You cannot leave this information blank!"));
    } else {
      emit(state.copyWith(errorType: ""));
    }
    if (height.isEmpty) {
      isValid = false;
      emit(state.copyWith(
          errorHeight: "You cannot leave this information blank!"));
    } else {
      emit(state.copyWith(errorHeight: ""));
    }
    if (email.isEmpty) {
      isValid = false;
      emit(state.copyWith(
          errorEmail: "You cannot leave this information blank!"));
    } else if (!EmailValidator.validate(email)) {
      emit(
          state.copyWith(errorEmail: LocaleKeys.please_input_valid_email.tr()));
      isValid = false;
    } else {
      isValid = true;
      emit(state.copyWith(errorEmail: ''));
    }
    return isValid;
  }

  Future<void> getUserProfile() async {
    var response = await userRepository.getUserProfile(globals.userId ?? 0);
    if (response.error == null && response.data != null) {
      var userProfile = UserProfileModel.fromJson(response.data);
      await StorageUtils.saveUserProfile(userProfile);
    }
  }

  void onChangeInfo(String firstname, String lastName, String role,
      String height, String email) {
    checkInfoProfile(firstname, lastName, role, height, email);
    emit(state.copyWith(isOnChangeInfo: true));
  }
}
