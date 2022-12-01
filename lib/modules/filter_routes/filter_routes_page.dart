import 'package:base_bloc/base/base_state.dart';
import 'package:base_bloc/base/hex_color.dart';
import 'package:base_bloc/components/app_button.dart';
import 'package:base_bloc/components/app_scalford.dart';
import 'package:base_bloc/components/app_slider.dart';
import 'package:base_bloc/data/globals.dart';
import 'package:base_bloc/localizations/app_localazations.dart';
import 'package:base_bloc/modules/filter_routes/filter_routes_page_state.dart';
import 'package:base_bloc/router/router_utils.dart';
import 'package:base_bloc/theme/app_styles.dart';
import 'package:base_bloc/utils/app_utils.dart';
import 'package:base_bloc/utils/log_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rxdart/rxdart.dart';

import '../../components/app_text.dart';
import '../../data/model/filter_param.dart';
import '../../theme/colors.dart';
import 'filter_routes_page_cubit.dart';

class FilterRoutesPage extends StatefulWidget {
  final bool isFilterFav;
  final Function(FilterParam) showResultButton;


  const FilterRoutesPage(
      {Key? key, this.isFilterFav = false, required this.showResultButton})
      : super(key: key);

  @override
  State<FilterRoutesPage> createState() => _FilterRoutesPageState();
}

final Map<String, int> status = {
  LocaleKeys.notTried: 0,
  LocaleKeys.ufUnfinished: 1,
  LocaleKeys.suSupported: 2,
  LocaleKeys.trTopRope: 3,
  LocaleKeys.rpRedPoint: 4,
  LocaleKeys.osOnSight: 5,
};

final Map<String, String> corners = {
  LocaleKeys.withCorner: "T",
  LocaleKeys.withoutCorners: "F"
};

final Map<String, String> designs = {
  LocaleKeys.routeSetter: "T",
  LocaleKeys.friends: "F"
};

class _FilterRoutesPageState extends State<FilterRoutesPage> {
  late FilterRoutesPageCubit _bloc;

  final gradeChange = BehaviorSubject<List<dynamic>>();

  @override
  void initState() {
    _bloc = FilterRoutesPageCubit();

    gradeChange
        .debounceTime(const Duration(seconds: 1))
        .listen((value) => _bloc.getFavorite());

    super.initState();
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
          padding: EdgeInsets.only(left: contentPadding, right: contentPadding),
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
                        visible: !widget.isFilterFav,
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
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 17.0, horizontal: 16)),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: contentPadding),
                              child: AppText(
                                " ${LocaleKeys.author}  ",
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
                      itemTitle(LocaleKeys.status),
                      itemSpace(height: 9),
                      statusWidget(),
                      itemSpace(),
                      itemTitle(LocaleKeys.corners),
                      itemSpace(height: 9),
                      filterWidget(
                          corners,
                          state.filter!.conner,
                          (value) => _bloc.setCorner(value),
                          state.currentConnerIndex),
                      itemSpace(),
                      itemTitle(LocaleKeys.authorsGrade),
                      rangeWidget(state.filter!.authorGradeFrom,
                          state.filter!.authorGradeTo, (values) {
                        gradeChange.add(values);
                        _bloc.setAuthorGrade(values[0], values[1]);
                      }),
                      itemTitle(LocaleKeys.userGrade),
                      rangeWidget(
                          state.filter!.userGradeFrom, state.filter!.userGradeTo,
                          (values) {
                            gradeChange.add(values);
                        _bloc.setUserGrade(values[0], values[1]);
                      }),
                      itemTitle(LocaleKeys.designedBy),
                      itemSpace(height: 9),
                      filterWidget(
                          designs,
                          state.filter!.designBy,
                          (value) => _bloc.setDesignBy(value),
                          state.currentDesignBy),
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
                      '${LocaleKeys.showResult}' +
                          " : " +
                          state.lPlayList!.length.toString(),
                      style:
                          typoW600.copyWith(color: colorText0, fontSize: 13.sp),
                    ),
                  ),
                  onTap: () {
                    widget.showResultButton(state.filter!);
                    RouterUtils.pop(context);
                  }),
              itemSpace()
            ],
          ),
        );
      }

    );
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
          Container(
            height: MediaQuery.of(context).size.height,
            alignment: Alignment.center,
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () {
                RouterUtils.pop(context);
              },
              child: AppText(
                LocaleKeys.removeFilter,
                style: typoW600.copyWith(
                    color: HexColor('FF5A00'), fontSize: 13.sp),
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

  Widget filterWidget(Map nameList, String currentValue,
      Function(List<dynamic>) onCallBackSelect, int currentIndex) {
    return SizedBox(
      height: 27.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: nameList.keys.length,
        itemBuilder: (context, index) {
          return itemListView(
              alignment: Alignment.center,
              itemOnclick: () => onCallBackSelect(
                  [nameList[nameList.keys.elementAt(index)], index]),
              index: index,
              text: nameList.keys.elementAt(index),
              selectIndex: currentIndex);
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

  Widget statusWidget() =>
      BlocBuilder<FilterRoutesPageCubit, FilterRoutesPageState>(
        bloc: _bloc,
        builder: (c, state) => Tags(
            columns: 2,
            itemCount: status.keys.length,
            alignment: WrapAlignment.start,
            itemBuilder: (int index) => itemListView(
                itemOnclick: () {
                  _bloc.setStatus(index);
                },
                index: index,
                text: status.keys.elementAt(index),
                selectIndex: state.filter!.status)),
      );

  @override
  bool get isNewPage => true;
}
