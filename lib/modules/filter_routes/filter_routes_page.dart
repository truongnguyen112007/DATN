import 'package:base_bloc/base/base_state.dart';
import 'package:base_bloc/base/hex_color.dart';
import 'package:base_bloc/components/app_button.dart';
import 'package:base_bloc/components/app_scalford.dart';
import 'package:base_bloc/components/app_slider.dart';
import 'package:base_bloc/data/eventbus/refresh_event.dart';
import 'package:base_bloc/data/globals.dart';
import 'package:base_bloc/localizations/app_localazations.dart';
import 'package:base_bloc/modules/filter_routes/filter_routes_page_state.dart';
import 'package:base_bloc/router/router_utils.dart';
import 'package:base_bloc/theme/app_styles.dart';
import 'package:base_bloc/utils/app_utils.dart';
import 'package:base_bloc/utils/log_utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rxdart/rxdart.dart';

import '../../components/app_text.dart';
import '../../components/item_filter_widget.dart';
import '../../data/model/filter_corner_model.dart';
import '../../data/model/filter_design_model.dart';
import '../../data/model/filter_status_model.dart';
import '../../data/model/filter_param.dart';
import '../../data/model/routes_model.dart';
import '../../localization/locale_keys.dart';
import '../../theme/colors.dart';
import 'filter_routes_page_cubit.dart';

enum FilterType { Favorite, Designed, SearchRoute }

class FilterRoutesPage extends StatefulWidget {
  FilterType type;
  final Function(FilterParam) showResultButton;
  final FilterParam? filter;
  final Function(FilterParam) removeFilterCallBack;
  final List<RoutesModel>? listRoute;
  FilterRoutesPage({
    Key? key,
    this.type = FilterType.Favorite,
    required this.showResultButton,
    required this.removeFilterCallBack,
    this.listRoute,
    this.filter,
  }) : super(key: key);

  @override
  State<FilterRoutesPage> createState() => _FilterRoutesPageState();
}

class _FilterRoutesPageState extends State<FilterRoutesPage> {
  late FilterRoutesPageCubit _bloc;

  final gradeChange = BehaviorSubject<List<dynamic>>();

  var status = [
    FilterStatusModel(value: {LocaleKeys.notTried.tr(): 0}),
    FilterStatusModel(value: {LocaleKeys.ufUnfinished.tr(): 1}),
    FilterStatusModel(value: {LocaleKeys.suSupported.tr(): 2}),
    FilterStatusModel(value: {LocaleKeys.trTopRope.tr(): 3}),
    FilterStatusModel(value: {LocaleKeys.rpRedPoint.tr(): 4}),
    FilterStatusModel(value: {LocaleKeys.osOnSight.tr(): 5}),
  ];

  var corners = [
    FilterCornerModel(value: {LocaleKeys.withCorner.tr(): "T"}),
    FilterCornerModel(value: {LocaleKeys.withoutCorners.tr(): "F"})
  ];

  var designs = [
    FilterDesignModel(value: {LocaleKeys.routeSetter.tr(): "T"})
    // LocaleKeys.friends.tr(): "F"
  ];

  @override
  void initState() {
    _bloc = FilterRoutesPageCubit(widget.type);
    checkDataStatus();
    logE(widget.listRoute!.length.toString());
    _bloc.setData(widget.filter,widget.listRoute);
    gradeChange
        .debounceTime(const Duration(seconds: 1))
        .listen((value) => _bloc.setType());

    super.initState();
  }

  void checkDataStatus() {
    if (widget.filter != null) {
      for (int j = 0; j < widget.filter!.status.length; j++) {
        for (int i = 0; i < status.length; i++) {
          if (status[i].value.keys.first ==
              widget.filter!.status[j].keys.first) {
            status[i].isSelect = true;
          }
        }
      }
      for (int j = 0; j < widget.filter!.corner.length; j++) {
        for (int i = 0; i < corners.length; i++) {
          if (corners[i].value.keys.first ==
              widget.filter!.corner[j].keys.first) {
            corners[i].isSelect = true;
          }
        }
      }
      for (int j = 0; j < widget.filter!.designBy.length; j++) {
        for (int i = 0; i < designs.length; i++) {
          if (designs[i].value.keys.first ==
              widget.filter!.designBy[j].keys.first) {
            designs[i].isSelect = true;
          }
        }
      }
    }
  }

  var backgroundColor = HexColor('212121');

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FilterRoutesPageCubit, FilterRoutesPageState>(
        bloc: _bloc,
        builder: (c, state) {
          return AppScaffold(
            resizeToAvoidBottomInset: false,
            isTabToHideKeyBoard: false,
            padding:
            EdgeInsets.only(left: contentPadding, right: contentPadding),
            appbar: appbar(context),
            backgroundColor: backgroundColor,
            body: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        itemSpace(),
                        Visibility(
                          visible: widget.type == FilterType.Favorite &&
                              widget.type == FilterType.SearchRoute,
                          child: Stack(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 9.h),
                                child: TextField(
                                  style: typoSmallTextRegular.copyWith(
                                    color: colorText0,
                                  ),
                                  cursorColor: Colors.white60,
                                  decoration: decorTextField.copyWith(
                                      fillColor: Colors.transparent,
                                      contentPadding:
                                      const EdgeInsets.symmetric(
                                          vertical: 17.0, horizontal: 16)),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: contentPadding),
                                child: AppText(
                                  " ${LocaleKeys.author.tr()}  ",
                                  style: typoW400.copyWith(
                                      color: colorText0.withOpacity(0.6),
                                      fontSize: 12,
                                      backgroundColor: backgroundColor),
                                ),
                              )
                            ],
                          ),
                        ),
                        itemSpace(),
                        itemTitle(LocaleKeys.status.tr()),
                        itemSpace(height: 9),
                        statusWidget(status),
                        itemSpace(),
                        itemTitle(LocaleKeys.corners.tr()),
                        itemSpace(height: 9),
                        filterConner(corners),
                        itemSpace(),
                        itemTitle(LocaleKeys.authorsGrade.tr()),
                        rangeWidget(state.filter!.authorGradeFrom,
                            state.filter!.authorGradeTo, (values) {
                              gradeChange.add(values);
                              _bloc.setAuthorGrade(values[0], values[1]);
                            }),
                        itemTitle(LocaleKeys.userGrade.tr()),
                        rangeWidget(state.filter!.userGradeFrom,
                            state.filter!.userGradeTo, (values) {
                              gradeChange.add(values);
                              _bloc.setUserGrade(values[0], values[1]);
                            }),
                        itemTitle(LocaleKeys.designedBy.tr()),
                        itemSpace(height: 9),
                        filterDesign(designs),
                        const SizedBox(height: 50),
                      ],
                    ),
                  ),
                ),
                line(),
                InkWell(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    child: Container(
                      height: 40.h,
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          gradient: Utils.backgroundGradientOrangeButton()),
                      child: AppText(
                        '${LocaleKeys.showResult.tr()}' +
                            " : " +
                            state.lPlayList!.length.toString(),
                        style: typoW600.copyWith(
                            color: colorText0, fontSize: 13.sp),
                      ),
                    ),
                    onTap: () {
                      widget.showResultButton(state.filter!);
                      Utils.hideKeyboard(context);
                      RouterUtils.pop(context);
                    }),
                itemSpace()
              ],
            ),
          );
        });
  }

  String getGrade(int value) {
    switch (value) {
      case 0:
        return '4';
      case 1:
        return "5A";
      case 2:
        return "5B";
      case 3:
        return "5C";
      case 4:
        return "6A";
      case 5:
        return "6A+";
      case 6:
        return "6B";
      case 7:
        return "6B+";
      case 8:
        return "6C";
      case 9:
        return "7A";
      case 10:
        return "7A+";
      case 11:
        return "7B";
      case 12:
        return "7B+";
      case 13:
        return "7C";
      case 14:
        return "7C+";
      case 15:
        return "8A";
      case 16:
        return "8A+";
      case 17:
        return "8B";
      case 18:
        return "8B+";
      case 19:
        return "8C";
      case 20:
        return "8C+";
    }
    return "0";
  }

  Widget rangeWidget(double lowerValue, double upperValue,
      Function(List<double>) callback) =>
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppText(
            '${getGrade(lowerValue.toInt())} - ${getGrade(upperValue.toInt())}',
            style: typoW400.copyWith(
                fontSize: 13.sp, color: colorText0.withOpacity(0.87)),
          ),
          AppSlider(
              rightHandler: AppSliderHandler(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: colorOrange90)),
              handler: AppSliderHandler(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: colorOrange90)),
              trackBar: const AppSliderTrackBar(
                  inactiveTrackBar: BoxDecoration(color: colorBlack5),
                  activeTrackBar: BoxDecoration(color: colorOrange90)),
              handlerWidth: 25,
              rangeSlider: true,
              values: [lowerValue, upperValue],
              max: 20,
              min: 0,
              onDragging: (handlerIndex, lowerValue, upperValue) =>
                  callback([lowerValue, upperValue]))
        ],
      );

  Widget line() => const Divider(
    thickness: 1,
    color: Colors.white24,
  );

  Widget itemSpace({double height = 15.0}) => SizedBox(
    height: height,
  );

  PreferredSizeWidget appbar(BuildContext context) => AppBar(
    automaticallyImplyLeading: true,
    leading: IconButton(
      onPressed: () => RouterUtils.pop(context),
      icon: const Icon(
        Icons.arrow_back_outlined,
        color: colorText45,
      ),
    ),
    backgroundColor: backgroundColor,
    flexibleSpace: Align(
      alignment: Alignment.bottomCenter,
      child: line(),
    ),
    toolbarHeight: 50.h,
    actions: [
      BlocBuilder<FilterRoutesPageCubit, FilterRoutesPageState>(
        bloc: _bloc,
        builder: (c, state) => Container(
          height: MediaQuery.of(context).size.height,
          alignment: Alignment.center,
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () {
              Utils.fireEvent(RefreshEvent(RefreshType.FILTER));
              _bloc.removeFilter(
                      (model) => widget.removeFilterCallBack.call(model));
            },
            child: AppText(
              LocaleKeys.removeFilter.tr(),
              style: typoW600.copyWith(
                  color: HexColor('FF5A00'), fontSize: 13.sp),
            ),
          ),
        ),
      ),
      SizedBox(
        width: contentPadding,
      )
    ],
  );

  Widget itemTitle(String text) => AppText(
    text,
    style: typoW400.copyWith(
        color: colorText0.withOpacity(0.87), fontSize: 14.5.sp),
  );

  Widget filterDesign(List<FilterDesignModel> nameList) {
    return SizedBox(
      height: 27.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: nameList.length,
        itemBuilder: (context, index) {
          return ItemFilterWidget(
            isSelect: nameList[index].isSelect,
            data: {
              nameList[index].value.keys.first:
              nameList[index].value[nameList[index].value.keys.first]
            },
            callback: (value) {
              _bloc.setDesignBy(nameList[index].value, value);
            },
          );
        },
        separatorBuilder: (BuildContext context, int index) => const SizedBox(
          width: 12,
        ),
      ),
    );
  }

  Widget filterConner(List<FilterCornerModel> nameList) {
    return SizedBox(
      height: 27.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: nameList.length,
        itemBuilder: (context, index) {
          return ItemFilterWidget(
            isSelect: nameList[index].isSelect,
            data: {
              nameList[index].value.keys.first:
              nameList[index].value[nameList[index].value.keys.first]
            },
            callback: (value) {
              _bloc.setCorner(nameList[index].value, value);
            },
          );
        },
        separatorBuilder: (BuildContext context, int index) => const SizedBox(
          width: 12,
        ),
      ),
    );
  }

  Widget itemListView(
      {required String text,
        required int selectIndex,
        required int index,
        required VoidCallback itemOnclick,
        AlignmentGeometry? alignment}) =>
      InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Container(
          alignment: alignment,
          margin: const EdgeInsets.only(right: 8),
          decoration: selectIndex == index
              ? BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: Utils.backgroundGradientOrangeButton(),
          )
              : BoxDecoration(
              borderRadius: BorderRadius.circular(20), color: colorBlack10),
          padding:
          EdgeInsets.only(left: 11.w, right: 11.w, top: 5.h, bottom: 5.h),
          child: AppText(
            text,
            style: typoW600.copyWith(
                color: colorText0.withOpacity(0.87), fontSize: 12.sp),
          ),
        ),
        onTap: () => itemOnclick.call(),
      );

  Widget statusWidget(List<FilterStatusModel> nameList) =>
      BlocBuilder<FilterRoutesPageCubit, FilterRoutesPageState>(
        bloc: _bloc,
        builder: (c, state) => Tags(
          columns: 2,
          itemCount: nameList.length,
          alignment: WrapAlignment.start,
          itemBuilder: (int index) => ItemFilterWidget(
            isSelect: nameList[index].isSelect,
            data: {
              nameList[index].value.keys.first:
              nameList[index].value[nameList[index].value.keys.first]
            },
            callback: (value) {
              _bloc.setStatus(nameList[index].value, value);
            },
          ),
        ),
      );

  @override
  bool get isNewPage => true;
}
