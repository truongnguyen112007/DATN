import 'package:base_bloc/components/dialogs.dart';
import 'package:base_bloc/data/repository/user_repository.dart';
import 'package:base_bloc/modules/register/register_state.dart';
import 'package:base_bloc/utils/toast_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../login/login.dart';

class RegisterCubit extends Cubit<RegisterState> {
  var repository = UserRepository();

  RegisterCubit() : super(RegisterState());

  void registerOnClick(
      BuildContext context, String phone, String pass, String name) async {
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
/*
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => Login()));
    toast("Đăng ký thành công");
*/
  }
}
