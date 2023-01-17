import 'dart:async';
import 'package:base_bloc/components/dialogs.dart';
import 'package:base_bloc/config/constant.dart';
import 'package:base_bloc/data/model/user_profile_model.dart';
import 'package:base_bloc/data/repository/user_repository.dart';
import 'package:base_bloc/modules/tab_profile/edit_settings/edit_account/edit_account_page.dart';
import 'package:base_bloc/modules/tab_profile/edit_settings/edit_settings_page.dart';
import 'package:base_bloc/router/router_utils.dart';
import 'package:base_bloc/utils/app_utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../components/type_profile_widget.dart';
import '../../../../data/globals.dart' as globals;
import '../../../../data/model/profile_model.dart';
import '../../../../localization/locale_keys.dart';
import '../../../../theme/colors.dart';
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

  EditAccountCubit(this.editAccountCallBack,TypeProfile roleType)
      : super( EditAccountState(status: EditAccountStatus.initial)) {
    if (state.status == EditAccountStatus.initial) {}
    state.typeProfile = roleType;
    getData();
  }

  void getData() async {
    // var userModel = await StorageUtils.getUserProfile();
    // emit(EditAccountState(model: userModel));
  }

  void saveInfo(BuildContext context, String firstname, String lastName,
      String height, String email) {
    Dialogs.showWidgetDialog(context, textButton: LocaleKeys.yesDialog.tr(), callback: () async {
      await Dialogs.hideLoadingDialog();
      Utils.hideKeyboard(context);
      await Future.delayed(Duration(milliseconds: 100));
      state.typeProfile;
      var role = (state.typeProfile == TypeProfile.USER) ? ApiKey.user : (state
          .typeProfile == TypeProfile.ROUTER_SETTER
          ? ApiKey.route_setter
          : ApiKey.trainer);
      Dialogs.showLoadingDialog(context);
      var response = await userRepository.updateUserProfile(
          first_name: firstname,
          last_name: lastName,
          height: height,
          /* photo: photo*/
          email: email, role: role);
      if (response.statusCode == 201) {
        await getUserProfile();
      }
      await Dialogs.hideLoadingDialog();
      editAccountCallBack.call();
      toast(response.message);
      emit(state.copyWith(isOnChangeInfo: false,));
    }, text: LocaleKeys.askWantToSaveInfo.tr());
  }

  void askSaveInfo(BuildContext context) {
    if(state.isOnChangeInfo!){
      Dialogs.showWidgetDialog(context, callback: () async {
        await Dialogs.hideLoadingDialog();
        RouterUtils.pop(context);
      },
          text: LocaleKeys.changeWillNotSave.tr(),
          textButton: LocaleKeys.backDialog.tr());
    } else {
      RouterUtils.pop(context);
    }
  }


  bool checkInfoProfile(String firstname, String lastName,
      String height, String email) {
    bool isValid = false;
    if (firstname.isEmpty) {
      isValid = false;
      emit(state.copyWith(
          errorName: LocaleKeys.mustFillInfo.tr(),));
    } else {
      emit(state.copyWith(errorName: ""));
    }
    if (lastName.isEmpty) {
      isValid = false;
      emit(state.copyWith(
          errorSurname: LocaleKeys.mustFillInfo.tr()));
    } else {
      emit(state.copyWith(errorSurname: ""));
    }
    if (height.isEmpty) {
      isValid = false;
      emit(state.copyWith(
          errorHeight: LocaleKeys.mustFillInfo.tr()));
    } else {
      emit(state.copyWith(errorHeight: ""));
    }
    if (email.isEmpty) {
      isValid = false;
      emit(state.copyWith(
          errorEmail: LocaleKeys.mustFillInfo.tr()));
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

  void onChangeInfo(String firstname, String lastName,
      String height, String email) {
    checkInfoProfile(firstname, lastName, height, email);
    emit(state.copyWith(isOnChangeInfo: true));
  }


  void showTypeDialog(BuildContext context) {
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: colorTransparent,
        context: context,
        builder: (x) => TypeProfileWidget(
            itemOnClick: (type) {
              Utils.hideKeyboard(context);
              emit(state.copyWith(typeProfile: type,isOnChangeInfo: true));
              Navigator.pop(context);
            },
            type: state.typeProfile!));
  }

}
