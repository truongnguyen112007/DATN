import 'package:base_bloc/modules/home/home_page.dart';
import 'package:base_bloc/modules/login/login_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../register/register.dart';


class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginState());

  void openRegister (BuildContext context) {
    // RouterUtils.openNewPage(const Otp(), context);
    Navigator.push(context, MaterialPageRoute(builder: (context)=> Register()));
  }

  void openHomePage (BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context)=> HomePage()));
  }

}