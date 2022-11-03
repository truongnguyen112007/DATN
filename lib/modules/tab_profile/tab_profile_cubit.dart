import 'package:base_bloc/data/model/profile_model.dart';
import 'package:base_bloc/modules/tab_profile/edit_settings/edit_settings_page.dart';
import 'package:base_bloc/modules/tab_profile/tab_profile.dart';
import 'package:base_bloc/modules/tab_profile/tab_profile_state.dart';
import 'package:base_bloc/router/router_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/constant.dart';
import '../../router/router.dart';

class TabProfileCubit extends Cubit<TabProfileState> {
  TabProfileCubit() : super(const TabProfileState());

  void didPressEditProfile(BuildContext context) {
    RouterUtils.openNewPage(const EditSettingsPage(), context);
  }

  void onClickSearch(BuildContext context) => RouterUtils.pushProfile(
      context: context,
      route: ProfileRouters.search,
      argument: BottomNavigationConstant.TAB_PROFILE);

  void onClickLogin(BuildContext context) async {
    await RouterUtils.pushProfile(
        context: context,
        route: ProfileRouters.login,
        argument: BottomNavigationConstant.TAB_PROFILE);
    emit(TabProfileState(timeStamp: DateTime.now().microsecondsSinceEpoch));
  }

  void onClickNotification(BuildContext context) => RouterUtils.pushProfile(
      context: context,
      route: ProfileRouters.notifications,
      argument: BottomNavigationConstant.TAB_PROFILE);

  ProfileModel getCurrentUser() {
    return ProfileModel.fakeCurrentUser();
  }
}