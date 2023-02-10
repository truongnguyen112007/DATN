import 'package:base_bloc/components/dialogs.dart';
import 'package:base_bloc/data/repository/user_repository.dart';
import 'package:base_bloc/modules/register/register_state.dart';
import 'package:base_bloc/utils/toast_utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../localization/locale_keys.dart';
import '../../utils/app_utils.dart';
import '../login/login.dart';

class RegisterCubit extends Cubit<RegisterState> {
  var repository = UserRepository();

  RegisterCubit() : super(RegisterState());

  void registerOnClick(
      BuildContext context, String phone, String pass, String name) async {
    // bool isValidName = checkName(name);
    // bool isValidPhone = checkPhone(phone);
    // bool isValidPass = checkValidPassword(pass);
    // if(isValidName && isValidPass && isValidPhone){
    //   Dialogs.showLoadingDialog(context);
    // }
    if (phone.isEmpty || pass.isEmpty || name.isEmpty) {
      toast("Vui lòng điền đầy đủ thông tin");
      return;
    }
    Dialogs.showLoadingDialog(context);
    var response = await repository.register(phone, pass, name);
    await Dialogs.hideLoadingDialog();
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => Login()));
    toast("Đăng ký thành công");
    if (response.error != null) {
      toast(response.error.toString());
    } else {
      toast(response.data.toString());
    }
  }

  bool checkName (String name) {
    bool isValid = false;
    if (name.isEmpty) {
      isValid = false;
      emit(state.copyOf(errorName: "Bạn không được để trống tên"));
    } else{
      isValid = true;
      emit(state.copyOf(errorPhone: ''));
    }
      return isValid;
  }

  bool checkPhone(String phone) {
    bool isValid = false;
    if (phone.isEmpty) {
      isValid = false;
      emit(state.copyOf(errorPhone: "Bạn không được để trống số điện thoại"));
    } else if (!Utils.validateMobile(phone)) {
      emit(state.copyOf(errorPhone: "Số điện thoại không đúng"));
      isValid = false;
    }else{
      isValid = true;
      emit(state.copyOf(errorPhone: ''));
    }
    return isValid;
  }

  bool checkValidPassword(String password) {
    bool isValid = false;
    if (password.isEmpty) {
      isValid = false;
      emit(state.copyOf(errorPassword: LocaleKeys.please_input_pass.tr()));
    } else if (!Utils.validatePassword(password)) {
      emit(
          state.copyOf(errorPassword: LocaleKeys.please_input_valid_pass.tr()));
      isValid = false;
    } else {
      isValid = true;
      emit(state.copyOf(errorPassword: ''));
    }
    return isValid;
  }

}
