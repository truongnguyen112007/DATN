import 'package:base_bloc/data/model/user_model.dart';
import 'package:base_bloc/modules/tab_profile/edit_settings/edit_settings_page.dart';
import 'package:base_bloc/modules/tab_profile/tab_profile.dart';
import 'package:base_bloc/modules/tab_profile/tab_profile_state.dart';
import 'package:base_bloc/router/router_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/constant.dart';
import '../../router/router.dart';

class TabProfileCubit extends Cubit<TabProfileState> {
  TabProfileCubit() : super(TabProfileState());

  void didPressEditProfile(BuildContext context) {
    RouterUtils.openNewPage(EditSettingsPage(), context);
  }

  void onClickLogin(BuildContext context) async {
    await RouterUtils.pushProfile(
        context: context,
        route: ProfileRouters.login,
        argument: BottomNavigationConstant.TAB_PROFILE);
    emit(TabProfileState(timeStamp: DateTime.now().microsecondsSinceEpoch));
  }

  UserModel getCurrentUser() {
    return UserModel.fakeCurrentUser();
  }
}