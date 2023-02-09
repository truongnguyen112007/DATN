import 'package:base_bloc/data/model/user_model.dart';
import 'package:base_bloc/data/repository/user_repository.dart';
import 'package:base_bloc/modules/home/home_page.dart';
import 'package:base_bloc/modules/login/login_state.dart';
import 'package:base_bloc/utils/log_utils.dart';
import 'package:base_bloc/utils/storage_utils.dart';
import 'package:base_bloc/utils/toast_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../components/dialogs.dart';
import '../register/register.dart';

class LoginCubit extends Cubit<LoginState> {
  var repository = UserRepository();

  LoginCubit() : super(LoginState());

  void openRegister(BuildContext context) {
    // RouterUtils.openNewPage(const Otp(), context);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Register()));
  }

  void openHomePage(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HomePage()));
  }

  void loginOnclick(String phone, String pass, BuildContext context) async {
    if (phone.isEmpty || pass.isEmpty) {
      toast("Vui long nhập đầy đủ thông tin");
      return;
    }
    Dialogs.showLoadingDialog(context);
    var response = await repository.login(phone, pass);
    await Dialogs.hideLoadingDialog();
    if (response.error != null) {
      toast(response.error.toString());
    } else {
      toast(response.message);
      StorageUtils.login(UserModel.fromJson(response.data));
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomePage()),);
    }
  }
}
