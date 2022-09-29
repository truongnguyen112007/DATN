import 'package:base_bloc/data/model/user_model.dart';
import 'package:base_bloc/modules/tab_profile/edit_settings/edit_settings_page.dart';
import 'package:base_bloc/modules/tab_profile/tab_profile_state.dart';
import 'package:base_bloc/router/router_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TabProfileCubit extends Cubit<TabProfileState> {
  TabProfileCubit() : super(TabProfileInitialState());

  void didPressEditProfile(BuildContext context) {
    RouterUtils.openNewPage(EditSettingsPage(), context);
  }

  UserModel getCurrentUser() {
    return UserModel.fakeCurrentUser();
  }
}