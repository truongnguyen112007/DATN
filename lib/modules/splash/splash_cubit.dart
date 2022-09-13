import 'package:base_bloc/modules/splash/splash_state.dart';
import 'package:base_bloc/router/router_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../router/router.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(InitState());

  void openHomePage(){
    emit(OpenHomeState());
  }
      // RouterUtils.push(context: context, route: Routers.home);
}
