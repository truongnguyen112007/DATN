import 'package:base_bloc/config/constant.dart';
import 'package:base_bloc/modules/home/home_page.dart';
import 'package:base_bloc/modules/login/login_state.dart';
import 'package:base_bloc/router/router_utils.dart';
import 'package:base_bloc/utils/app_utils.dart';
import 'package:base_bloc/utils/log_utils.dart';
import 'package:base_bloc/utils/storage_utils.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/eventbus/new_page_event.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(const LoginState(errorEmail: '', errorPassword: ''));

  void onClickLogin(String email, String password, BuildContext context) async {
    bool isValidEmail = checkValidEmail(email);
    bool isValidPass = checkValidPassword(password);
    if (isValidPass && isValidEmail) {
      StorageUtils.setLogin(true);
      /*  RouterUtils.pop(context);*/
      Utils.fireEvent(NewPageEvent(HomePage()));
    }
  }

  bool checkValidEmail(String email) {
    bool isValid = false;
    if (email.isEmpty) {
      isValid = false;
      emit(state.copyOf(errorEmail: 'You need to fill in your email'));
    } else if (!EmailValidator.validate(email)) {
      emit(state.copyOf(errorEmail: 'Your email is not true'));
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
      emit(state.copyOf(errorPassword: 'You need to fill in your password'));
    } else if (!Utils.validatePassword(password)) {
      emit(state.copyOf(errorPassword: 'Your password is not true'));
      isValid = false;
    } else {
      isValid = true;
      emit(state.copyOf(errorPassword: ''));
    }
    return isValid;
  }
}
