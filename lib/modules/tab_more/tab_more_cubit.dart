import 'package:base_bloc/data/model/profile_model.dart';
import 'package:base_bloc/data/repository/user_repository.dart';
import 'package:base_bloc/modules/tab_more/tab_more_state.dart';
import 'package:base_bloc/router/router_utils.dart';
import 'package:base_bloc/utils/storage_utils.dart';
import 'package:base_bloc/utils/toast_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../components/dialogs.dart';
import '../../config/constant.dart';
import '../../router/router.dart';
import '../login/login.dart';

class TabMoreCubit extends Cubit<TabMoreState> {
  var repository = UserRepository();

  TabMoreCubit() : super(const TabMoreState());

  void onClickSearch(BuildContext context) => RouterUtils.pushProfile(
      context: context,
      route: ProfileRouters.search,
      argument: BottomNavigationConstant.TAB_PROFILE);

  void onClickLogin(BuildContext context) async {
    await RouterUtils.pushProfile(
        context: context,
        route: ProfileRouters.login,
        argument: BottomNavigationConstant.TAB_PROFILE);
    emit(TabMoreState(timeStamp: DateTime.now().microsecondsSinceEpoch));
  }

  void onClickNotification(BuildContext context) => RouterUtils.pushProfile(
      context: context,
      route: ProfileRouters.notifications,
      argument: BottomNavigationConstant.TAB_PROFILE);

  ProfileModel getCurrentUser() {
    return ProfileModel.fakeCurrentUser();
  }

  void onClickSupplier(BuildContext context) {
    RouterUtils.pushProfile(
        context: context,
        route: ProfileRouters.routesSupplierPage,
        argument: BottomNavigationConstant.TAB_PROFILE);
  }

  void logoutOnClick(BuildContext context) async {
    Dialogs.showLoadingDialog(context);
    var response = await repository.logout();
    toast("Đăng xuất thành công");
    await Dialogs.hideLoadingDialog();
    StorageUtils.logout();
    RouterUtils.openNewPage(Login(), context, isReplace: true);
  }
}
