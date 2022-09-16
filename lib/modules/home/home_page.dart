import 'package:base_bloc/components/app_scalford.dart';
import 'package:base_bloc/config/constant.dart';
import 'package:base_bloc/modules/root/root_climb_page.dart';
import 'package:base_bloc/modules/root/root_home_page.dart';
import 'package:base_bloc/modules/root/root_profile_page.dart';
import 'package:base_bloc/modules/root/root_reservation_page.dart';
import 'package:base_bloc/theme/app_styles.dart';
import 'package:base_bloc/utils/log_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../components/gradient_icon.dart';
import '../../localizations/app_localazations.dart';
import '../root/root_routes_page.dart';
import 'home_cubit.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _currentIndex = 0;
  final _pageController = PageController();
  final _bloc = HomeCubit();
  var tabs = [
    const RootHomePage(),
    const RootRoutesPage(),
    const RootClimbPage(),
    const RootReservationPage(),
    const RootProfilePage()
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AppScaffold(
            body: Stack(
              children: [
                PageView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: _pageController,
                  children: tabs,
                )
              ],
            ),
            bottomNavigationBar: BlocBuilder(
              builder: (c, x) => bottomNavigationBarWidget(),
              bloc: _bloc,
            )),
        BlocBuilder(
          bloc: _bloc,
          builder: (c, x) => climbIconWidget(),
        )
      ],
    );
  }

  void _jumpToPage(int index) {
    _currentIndex = index;
    _pageController.jumpToPage(index);
    _bloc.jumpToPage(_currentIndex);
  }

  Widget climbIconWidget() => Positioned.fill(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 45.h,
            width: 80.w,
            margin: EdgeInsets.only(bottom: 22.h),
            decoration: const BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(100),
                topRight: Radius.circular(100),
              ),
            ),
            child: MaterialButton(
              highlightColor: Colors.transparent,
              onPressed: () => _jumpToPage(BottomNavigationConstant.TAB_CLIMB),
              splashColor: Colors.transparent,
              child: GradientIcon(
                gradient: LinearGradient(
                  colors: _currentIndex == BottomNavigationConstant.TAB_CLIMB
                      ? [Colors.red, Colors.orange]
                      : [Colors.grey, Colors.grey],
                ),
                size: 22,
                icon: Icons.rocket_launch_outlined,
              ),
            ),
          ),
        ),
      );

  Widget bottomNavigationBarWidget() {
    return BottomNavigationBar(
      unselectedItemColor: Colors.grey,
      backgroundColor: Colors.black,
      iconSize: 11,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.orange,
      selectedFontSize: 12.sp,
      unselectedFontSize: 12.sp,
      selectedLabelStyle: typoSuperSmallTextRegular.copyWith(fontSize: 12.sp),
      items: [
        itemBottomNavigationBarWidget(
            index: BottomNavigationConstant.TAB_HOME,
            label: AppLocalizations.of(context)!.home,
            icon: Icons.home_filled),
        itemBottomNavigationBarWidget(
            index: BottomNavigationConstant.TAB_ROUTES,
            label: AppLocalizations.of(context)!.routes,
            icon: Icons.map),
        itemBottomNavigationBarWidget(
            isTransparent: true,
            index: BottomNavigationConstant.TAB_ROUTES,
            label: AppLocalizations.of(context)!.climb,
            icon: Icons.map),
        itemBottomNavigationBarWidget(
            index: BottomNavigationConstant.TAB_RESERVATIONS,
            label: AppLocalizations.of(context)!.reservations,
            icon: Icons.date_range_outlined),
        itemBottomNavigationBarWidget(
            index: BottomNavigationConstant.TAB_PROFILE,
            label: AppLocalizations.of(context)!.profile,
            icon: Icons.person_outline_outlined),
      ],
      currentIndex: _currentIndex,
      onTap: (index) {
        _jumpToPage(index);
      },
    );
  }

  BottomNavigationBarItem itemBottomNavigationBarWidget(
          {required index,
          required IconData icon,
          required String label,
          bool isTransparent = false}) =>
      BottomNavigationBarItem(
        icon: Padding(
          padding: EdgeInsets.only(bottom: 5.h),
          child: GradientIcon(
            gradient: LinearGradient(
              colors: isTransparent
                  ? [Colors.transparent, Colors.transparent]
                  : _currentIndex == index
                      ? [Colors.red, Colors.orange]
                      : [Colors.grey, Colors.grey],
            ),
            size: 22,
            icon: icon,
          ),
        ),
        label: label,
      );
}
