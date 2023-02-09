import 'dart:async';
import 'dart:math' as math;
import 'dart:io';
import 'package:base_bloc/base/hex_color.dart';
import 'package:base_bloc/components/app_scalford.dart';
import 'package:base_bloc/config/constant.dart';
import 'package:base_bloc/data/eventbus/hold_set_event.dart';
import 'package:base_bloc/data/eventbus/new_page_event.dart';
import 'package:base_bloc/data/eventbus/switch_tab_event.dart';
import 'package:base_bloc/modules/home/home_state.dart';
import 'package:base_bloc/modules/root/root_climb_page.dart';
import 'package:base_bloc/modules/root/root_home_page.dart';
import 'package:base_bloc/modules/root/root_profile_page.dart';
import 'package:base_bloc/modules/root/root_reservation_page.dart';
import 'package:base_bloc/router/router_utils.dart';
import 'package:base_bloc/theme/colors.dart';
import 'package:base_bloc/utils/app_utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../components/gradient_icon.dart';
import '../../gen/assets.gen.dart';
import '../../localization/locale_keys.dart';
import '../root/root_routes_page.dart';
import 'home_cubit.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var tabs = [
    const RootOverView(),
    const RootReceipt(),
    const RootGoods(),
    const RootNotification(),
    const RootMore()
  ];

  var _currentIndex = 0;
  final _pageController = PageController();
  final _bloc = HomeCubit();
  bool isShowBottomBar = false;

  StreamSubscription<NewPageEvent>? _newPageStream;

  @override
  void initState() {
    _newPageStream = Utils.eventBus.on<NewPageEvent>().listen((event) async {
      var result = await RouterUtils.pushTo(context, event.newPage,
          isReplace: event.isReplace);
      if (result != null && event.type != null) {
        switch (event.type) {
          case NewPageType.HOLD_SET:
            Utils.fireEvent(HoldSetEvent(result));
            return;
          case NewPageType.FILL_PLACE:
          case NewPageType.ZOOM_ROUTES:
            Utils.fireEvent(result);
            return;
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _bloc.close();
    _newPageStream?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      fullStatusBar: true,
      resizeToAvoidBottomInset: false,
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        children: tabs,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BlocBuilder(
          bloc: _bloc,
          builder: (c, state) => Visibility(
                visible: state is InitState
                    ? true
                    : (state is HideBottomNavigationBarState && state.isHide
                        ? false
                        : true),
                child: bottomNavigationBarWidget(),
              )),
    );
  }

  void _jumpToPage(int index) {
    isShowBottomBar = false;
    setState(() {});
    if (index == _currentIndex) Utils.fireEvent(SwitchTabEvent(index));
    if (index == BottomNavigationConstant.TAB_CLIMB) {
      isShowBottomBar = true;
      setState(() {});
    }
    _currentIndex = index;
    _pageController.jumpToPage(index);
    _bloc.jumpToPage(_currentIndex);
  }

  Widget climbIconWidget() => Positioned.fill(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: EdgeInsets.only(top: 17.h),
            height: 50.h,
            margin:  EdgeInsets.only(bottom: 28.h),
            decoration: const BoxDecoration(
              color: colorBlack,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(100),
                topRight: Radius.circular(100),
              ),
            ),
            child: MaterialButton(
              highlightColor: Colors.transparent,
              onPressed: () => _jumpToPage(BottomNavigationConstant.TAB_CLIMB),
              splashColor: Colors.transparent,
              child: Container(color: Colors.white,width: 5,height: 5,),
            ),
          ),
        ),
      );

  Widget bottomNavigationBarWidget() {
    return Theme(
      data: Theme.of(context).copyWith(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: SizedBox(
        child: BottomNavigationBar(
          showSelectedLabels: true,
          unselectedItemColor: colorWhite,
          backgroundColor: colorGreen60,
          iconSize: 20,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.yellowAccent,
          selectedFontSize: 11.sp,
          unselectedFontSize: 11.sp,
          enableFeedback: false,
          items: [
            itemBottomNavigationBarWidget(
                index: BottomNavigationConstant.TAB_OVERVIEW,
                label: LocaleKeys.overview.tr(),
                icon: Icons.insert_chart),
            itemBottomNavigationBarWidget(
                index: BottomNavigationConstant.TAB_RECEIPT,
                label: LocaleKeys.receipt.tr(),
                icon: Icons.assignment),
            itemBottomNavigationBarWidget(
                index: BottomNavigationConstant.TAB_CLIMB,
                label: LocaleKeys.goods.tr(),
                icon: Icons.local_mall),
            itemBottomNavigationBarWidget(
                index: BottomNavigationConstant.TAB_RESERVATIONS,
                label: LocaleKeys.notification.tr(),
                icon: Icons.notifications),
            itemBottomNavigationBarWidget(
                index: BottomNavigationConstant.TAB_PROFILE,
                label: LocaleKeys.more.tr(),
                icon: Icons.dehaze),
          ],
          currentIndex: _currentIndex,
          onTap: (index) {
            _jumpToPage(index);
          },
        ),
      ),
    );
  }

  BottomNavigationBarItem itemBottomNavigationBarWidget(
          {required index,
          double? size,
          required IconData icon,
          required String label,
          bool isTransparent = false}) =>
      BottomNavigationBarItem(
        icon: Padding(
          padding: EdgeInsets.only(bottom: 6.h),
          child: GradientIcon(
            gradient: LinearGradient(
              colors: isTransparent
                  ? [Colors.transparent, Colors.transparent]
                  : _currentIndex == index
                      ? [Colors.yellowAccent,Colors.yellowAccent]
                      : [colorWhite, colorWhite],
            ),
            size: size ?? 20,
            icon: icon,
          ),
        ),
        label: label,
      );

  List<Color> gradientBottomNavigationBar() =>
      [HexColor('FF9300'), HexColor('FF5A00'), HexColor('FF5A00')];
}
