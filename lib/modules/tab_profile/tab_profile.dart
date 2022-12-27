import 'package:base_bloc/components/app_circle_loading.dart';
import 'package:base_bloc/components/app_text.dart';
import 'package:base_bloc/components/appbar_widget.dart';
import 'package:base_bloc/components/profile_info_widget.dart';
import 'package:base_bloc/modules/tab_profile/tab_profile_cubit.dart';
import 'package:base_bloc/modules/tab_profile/tab_profile_post/tab_profile_post.dart';
import 'package:base_bloc/modules/tab_profile/tab_profile_state.dart';
import 'package:base_bloc/theme/app_styles.dart';
import 'package:base_bloc/utils/storage_utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../components/app_scalford.dart';
import '../../components/check_login.dart';
import '../../components/dynamic_sliver_appbar.dart';
import '../../data/globals.dart';
import '../../localization/locale_keys.dart';
import '../../theme/colors.dart';
import '../designed/designed_page.dart';
import '../history/history_page.dart';

class TabProfile extends StatefulWidget {
  const TabProfile({Key? key}) : super(key: key);

  @override
  State<TabProfile> createState() => _TabProfileState();
}

class _TabProfileState extends State<TabProfile> {
  late final TabProfileCubit _bloc;
  late final DynamicSliverAppBar _silerAppBar;

  @override
  void initState() {
    _bloc = TabProfileCubit();
    // _silerAppBar = DynamicSliverAppBar(
    //     maxHeight: 0.0,
    //     child: _buildProfileInfoHeaderSliverAppBarFlex());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return /*AppScaffold(body: BlocBuilder(
        bloc: _bloc,
        builder: (c, s) => !isLogin
            ? CheckLogin(
          loginCallBack: () {
            _bloc.onClickLogin(context);
          },
        )
            :EditSettingsPage()));*/
        AppScaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: colorMainBackground,
      appbar: homeAppbar(context, onClickSearch: () {
        _bloc.onClickSearch(context);
      }, onClickNotification: () {
        _bloc.onClickNotification(context);
      },
          onClickJumpToTop: () {},
          widget: AppText(
            LocaleKeys.profile.tr(),
            style: googleFont.copyWith(color: colorWhite),
          )),
      body: BlocBuilder<TabProfileCubit, TabProfileState>(
        bloc: _bloc,
        builder: (c, s) => !isLogin
            ? CheckLogin(
                loginCallBack: () {
                  _bloc.onClickLogin(context);
                },
              )
            : s.model == null
                ? const Center(child: AppCircleLoading())
                : SafeArea(
                    child: DefaultTabController(
                      length: 3,
                      child: Scaffold(
                        backgroundColor: colorMainBackground,
                        appBar: PreferredSize(
                            preferredSize: Size.fromHeight(
                                MediaQuery.of(context).size.height),
                            child: NestedScrollView(
                              headerSliverBuilder: (context, value) {
                                return [
                                  DynamicSliverAppBar(
                                      maxHeight: 0.0,
                                      child:
                                          _buildProfileInfoHeaderSliverAppBarFlex(
                                              s)),
                                  SliverPersistentHeader(
                                    pinned: true,
                                    delegate: SliverAppBarDelegate(
                                      minHeight: 44.w,
                                      maxHeight: 44.w,
                                      child: TabBar(
                                        labelColor: colorPrimary,
                                        labelStyle: googleFont.copyWith(
                                            fontSize: 14.w,
                                            fontWeight: FontWeight.w600),
                                        unselectedLabelColor: colorSubText,
                                        indicatorColor: colorPrimary,
                                        indicatorWeight: 2.w,
                                        tabs: [
                                          Tab(text: LocaleKeys.tabPosts.tr()),
                                          Tab(text: LocaleKeys.tabHistory.tr()),
                                          Tab(
                                              text:
                                                  LocaleKeys.tabDesigned.tr()),
                                        ],
                                      ),
                                    ),
                                  )
                                ];
                              },
                              body: const TabBarView(
                                children: [
                                  TabProfilePost(),
                                  HistoryPage(),
                                  DesignedPage()
                                ],
                              ),
                            )),
                      ),
                    ),
                  ),
      ),
    );
  }

  Widget _buildProfileInfoHeaderSliverAppBarFlex(TabProfileState state) =>
      BlocBuilder<TabProfileCubit, TabProfileState>(
          bloc: _bloc,
          builder: (BuildContext context, state) {
            return ProfileInfoWidget(
                profileModel: state.model!,
                onPressEditProfile: () => _bloc.didPressEditProfile(context));
          });
}
