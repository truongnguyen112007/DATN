import 'package:base_bloc/data/model/user_model.dart';
import 'package:base_bloc/data/repository/user_repository.dart';
import 'package:base_bloc/modules/home/home_page.dart';
import 'package:base_bloc/modules/login/login_state.dart';
import 'package:base_bloc/utils/log_utils.dart';
import 'package:base_bloc/utils/storage_utils.dart';
import 'package:base_bloc/utils/toast_utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../components/dialogs.dart';
import '../../localization/locale_keys.dart';
import '../../utils/app_utils.dart';
import '../register/register.dart';

class LoginCubit extends Cubit<LoginState> {
  var repository = UserRepository();

  LoginCubit() : super(LoginState());

  void openRegister(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Register()));
  }

  void openHomePage(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HomePage()));
  }

  void loginOnclick(String phone, String pass, BuildContext context) async {
    bool isValidPhone = checkPhoneNumber(phone);
    bool isValidPass = checkValidPassword(pass);
    if(isValidPass && isValidPhone){
      Dialogs.showLoadingDialog(context);
    }
    // if (phone.isEmpty || pass.isEmpty) {
    //   toast("Vui lòng nhập đầy đủ thông tin");
    //   return;
    // }
    Dialogs.showLoadingDialog(context);
    var response = await repository.login(phone, pass);
    await Dialogs.hideLoadingDialog();
    if (response.error != null) {
      toast(response.error.toString());
    } else {
      toast(response.message);
      StorageUtils.login(UserModel.fromJson(response.data));
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    }
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

  bool checkPhoneNumber(String phoneNumber) {
    bool isValid = false;
    if (phoneNumber.isEmpty) {
      isValid = false;
      emit(state.copyOf(errorPhone: "Bạn không được để trống số điện thoại"));
    } else if (!Utils.validateMobile(phoneNumber)) {
      emit(state.copyOf(errorPhone: "Số điện thoại không đúng"));
      isValid = false;
    }else{
      isValid = true;
      emit(state.copyOf(errorPhone:""));
    }
    return isValid;
  }

}
