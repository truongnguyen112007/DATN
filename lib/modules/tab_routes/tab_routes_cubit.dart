import 'package:base_bloc/modules/tab_routes/tab_routes_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/constant.dart';
import '../../localizations/app_localazations.dart';
import '../../router/router.dart';
import '../../router/router_utils.dart';
import '../../utils/toast_utils.dart';
import '../home/home_state.dart';

class TabRouteCubit extends Cubit<TabRouteState>{
  TabRouteCubit() : super(const TabRouteState());

  void onClickSearch(BuildContext context) => RouterUtils.pushRoutes(
      context: context,
      route: RoutesRouters.search,
      argument: BottomNavigationConstant.TAB_ROUTES);

  void onClickNotification(BuildContext context) => /*toast(LocaleKeys.thisFeatureIsUnder);*/
      RouterUtils.pushRoutes(
      context: context,
      route: RoutesRouters.notifications,
      argument: BottomNavigationConstant.TAB_ROUTES);

  void onClickLogin(BuildContext context) async {
    await RouterUtils.pushRoutes(
        context: context,
        route: RoutesRouters.login,
        argument: BottomNavigationConstant.TAB_ROUTES);
    emit(TabRouteState(timeStamp: DateTime.now().microsecondsSinceEpoch));
  }
}
