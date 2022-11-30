import 'package:base_bloc/components/app_circle_loading.dart';
import 'package:base_bloc/data/globals.dart';
import 'package:base_bloc/modules/designed/designed_cubit.dart';
import 'package:base_bloc/modules/designed/designed_state.dart';
import 'package:base_bloc/modules/tab_home/tab_home_state.dart';
import 'package:base_bloc/theme/colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import '../../components/app_not_data_widget.dart';
import '../../components/app_scalford.dart';
import '../../components/app_text.dart';
import '../../components/filter_widget.dart';
import '../../components/gradient_button.dart';
import '../../components/item_info_routes.dart';
import '../../data/model/routes_model.dart';
import '../../localization/locale_keys.dart';
import '../../theme/app_styles.dart';
import '../../utils/app_utils.dart';
import '../playlist/playlist_cubit.dart';

class DesignedPage extends StatefulWidget {
  const DesignedPage({Key? key}) : super(key: key);

  @override
  State<DesignedPage> createState() => _DesignedPageState();
}

class _DesignedPageState extends State<DesignedPage>
    with AutomaticKeepAliveClientMixin {
  late DesignedCubit _bloc;
  var scrollController = ScrollController();

  @override
  void initState() {
    _bloc = DesignedCubit();
    paging();
    super.initState();
  }

  @override
  void dispose() {
    _bloc.close();
    scrollController.dispose();
    super.dispose();
  }
  void paging() {
    scrollController.addListener(() {
      var maxScroll = scrollController.position.maxScrollExtent;
      var currentScroll = scrollController.position.pixels;
      if (maxScroll - currentScroll <= 200) {
        _bloc.getRoute(isPaging: true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      backgroundColor: colorGreyBackground,
      body: Stack(
        children: [
          Column(
            children: [
              FilterWidget(
                isSelect: true,
                selectCallBack: () {
                  _bloc.selectOnclick(false);
                },
                filterCallBack: () => _bloc.filterOnclick(context),
                sortCallBack: () {},
                unsSelectCallBack: () {
                  _bloc.selectOnclick(true);
                },
              ),
              Expanded(
                child: RefreshIndicator(
                  child: BlocBuilder<DesignedCubit, DesignedState>(
                      bloc: _bloc,
                      builder: (c, state) {
                        return (state.status == FeedStatus.initial ||
                            state.status == FeedStatus.refresh)
                            ? const Center(child: AppCircleLoading())
                            : (state.status == FeedStatus.failure ||
                            state.lRoutes.isEmpty
                            ? Center(
                            child: Stack(children: [
                              ListView(
                                physics:
                                const AlwaysScrollableScrollPhysics(),
                              ),
                              const AppNotDataWidget()
                            ]))
                            : playlistWidget(context, state));
                      }),
                  onRefresh: () async => _bloc.refresh(),
                ),
              ),
            ],
          ),
          addWidget(context),
          BlocBuilder<DesignedCubit, DesignedState>(
            bloc: _bloc,
            builder: (c, state) => Positioned.fill(
              left: 10.w,
              bottom: 10.h,
              right: 5.w,
              child: state.isShowActionButton
                  ? Align(
                alignment: Alignment.bottomRight,
                child: GradientButton(
                  height: 36.h,
                  isCenter: true,
                  width: 170.w,
                  decoration: BoxDecoration(
                    gradient: Utils.backgroundGradientOrangeButton(),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  onTap: () {
                    var lSelectRadioButton = <RoutesModel>[];
                    for (var element in state.lRoutes) {
                      if (element.isSelect == true)
                        lSelectRadioButton.add(element);
                    }
                    _bloc.itemOnLongClick(context, 0,
                        isMultiSelect: true);
                  },
                  widget: AppText(
                    LocaleKeys.action.tr(),
                    style: googleFont.copyWith(
                        color: colorWhite, fontSize: 15.sp),
                  ),
                  borderRadius: BorderRadius.circular(18),
                ),
              )
                  : const SizedBox(),
            ),
          ),
        ],
      ),
    );
  }

  Widget addWidget(BuildContext context) =>
      BlocBuilder<DesignedCubit, DesignedState>(
        bloc: _bloc,
        builder: (c, state) => Visibility(
          visible: state.isShowAdd,
          child: Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Align(
                alignment: Alignment.bottomRight,
                child: SpeedDial(
                  overlayColor: colorBlack,
                  overlayOpacity: 0.8,
                  gradientBoxShape: BoxShape.circle,
                  gradient: Utils.backgroundGradientOrangeButton(),
                  icon: Icons.add,
                  backgroundColor: colorOrange100,
                  activeBackgroundColor: colorWhite,
                  activeIcon: Icons.close,
                  activeChild: const Icon(
                    Icons.close,
                    color: colorBlack,
                  ),
                  spacing: 3,
                  childPadding: const EdgeInsets.all(5),
                  spaceBetweenChildren: 4,
                  dialRoot: null,
                  buttonSize: const Size(56.0, 56.0),
                  childrenButtonSize: const Size(56.0, 56.0),
                  direction: SpeedDialDirection.up,
                  renderOverlay: true,
                  useRotationAnimation: true,
                  animationCurve: Curves.elasticInOut,
                  isOpenOnStart: false,
                  animationDuration: const Duration(milliseconds: 300),
                  children: [
                    SpeedDialChild(
                      labelWidget: AppText(
                        LocaleKeys.find_routes.tr(),
                        style: typoW400.copyWith(
                            fontSize: 16, color: colorText0.withOpacity(0.87)),
                      ),
                      child: const Icon(
                        Icons.search,
                        color: colorBlack,
                      ),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.white,
                      onTap: () {},
                    ),
                    SpeedDialChild(
                      labelWidget: AppText(
                        LocaleKeys.create_routes.tr(),
                        style: typoW400.copyWith(
                            fontSize: 16, color: colorText0.withOpacity(0.87)),
                      ),
                      child: const Icon(
                        Icons.add,
                        color: colorBlack,
                      ),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.white,
                      onTap: () => _bloc.createRoutesOnClick(context),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

  Widget playlistWidget(BuildContext context, DesignedState state) =>
      ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: scrollController,
          padding: EdgeInsets.all(contentPadding),
          itemBuilder: (c, i) => i == state.lRoutes.length
              ? const Center(child: AppCircleLoading())
              : ItemInfoRoutes(
            isShowSelect: !state.isShowAdd,
            key: Key('$i'),
            context: context,
            model: state.lRoutes[i],
            callBack: (model) {},
            filterOnclick: () {
              _bloc.filterItemOnclick(i);
            },
            index: i,
            onLongPress: (model) =>
                _bloc.itemOnLongClick(context, i, model: model),
            detailCallBack: (RoutesModel action) =>
                _bloc.itemOnclick(context, state.lRoutes[i]),
          ),
          itemCount:
          !state.isReadEnd && state.lRoutes.isNotEmpty && state.isLoading
              ? state.lRoutes.length + 1
              : state.lRoutes.length);

  Widget itemAction(IconData icon, String text, ItemAction action,
      VoidCallback filterCallBack) {
    return InkWell(
      child: Padding(
        padding: EdgeInsets.all(contentPadding),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.white,
            ),
            SizedBox(
              width: 40.w,
            ),
            AppText(
              text,
              style: typoSuperSmallTextRegular.copyWith(color: colorText0),
            )
          ],
        ),
      ),
      onTap: () => filterCallBack.call(),
    );
  }


  @override
  bool get wantKeepAlive => true;
}
