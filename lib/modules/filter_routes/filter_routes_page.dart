import 'package:base_bloc/base/base_state.dart';
import 'package:base_bloc/base/hex_color.dart';
import 'package:base_bloc/components/app_button.dart';
import 'package:base_bloc/components/app_scalford.dart';
import 'package:base_bloc/components/app_slider.dart';
import 'package:base_bloc/data/globals.dart';
import 'package:base_bloc/localizations/app_localazations.dart';
import 'package:base_bloc/router/router_utils.dart';
import 'package:base_bloc/theme/app_styles.dart';
import 'package:base_bloc/utils/app_utils.dart';
import 'package:base_bloc/utils/log_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tags/flutter_tags.dart';

import '../../components/app_text.dart';
import '../../theme/colors.dart';

class FilterRoutesPage extends StatefulWidget {
  final int index;

  const FilterRoutesPage({Key? key, required this.index}) : super(key: key);

  @override
  State<FilterRoutesPage> createState() => _FilterRoutesPageState();
}

final List<String> status = [
  'Not tried',
  'UF-Unfinished',
  'SU-Supported',
  'TR-Top-rope',
  'RP-Red Point',
  'OS-OnSight',
];

final List<String> corners = ['With corners', 'Without corners'];

final List<String> designs = ["Route setter", 'Friends'];

class _FilterRoutesPageState extends BasePopState<FilterRoutesPage> {
  int selectedStatus = 0;

  int selectedCorner = 0;

  int selectedDesign = 0;

  var lowerAuthorGradeValue = 2.0;
  var upperAuthorGradeValue = 5.0;
  var lowerUserGradeValue = 2.0;
  var upperUserGradeValue = 5.0;
  var backgroundColor = HexColor('212121');

  @override
  Widget buildWidget(BuildContext context) {
    return AppScaffold(
        resizeToAvoidBottomInset: false,
        isTabToHideKeyBoard: false,
        padding: EdgeInsets.only(left: contentPadding, right: contentPadding),
        appbar: appbar(context),
        backgroundColor: backgroundColor,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              itemSpace(),
              Stack(
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
                    padding: const EdgeInsets.only(left: 10),
                    child: AppText(
                      "  ${AppLocalizations.of(context)!.author} ",
                      style: typoW400.copyWith(
                          color: colorText0.withOpacity(0.6),
                          fontSize: 12,
                          backgroundColor: colorGreyBackground),
                    ),
                  )
                ],
              ),
              itemSpace(),
              itemTitle(AppLocalizations.of(context)!.status),
              itemSpace(height: 9),
              statusWidget(),
              itemSpace(),
              itemTitle(AppLocalizations.of(context)!.corners),
              itemSpace(height: 9),
              filterWidget(corners, selectedCorner,
                  (index) => setState(() => selectedCorner = index)),
              itemSpace(),
              itemTitle(AppLocalizations.of(context)!.authorsGrade),
              rangeWidget(lowerAuthorGradeValue, upperAuthorGradeValue,
                  (values) {
                lowerAuthorGradeValue = values[0];
                upperAuthorGradeValue = values[1];
                setState(() {});
              }),
              itemTitle(AppLocalizations.of(context)!.userGrade),
              rangeWidget(lowerUserGradeValue, upperUserGradeValue, (values) {
                lowerUserGradeValue = values[0];
                upperUserGradeValue = values[1];
                setState(() {});
              }),
              itemTitle(AppLocalizations.of(context)!.designedBy),
              itemSpace(height: 9),
              filterWidget(designs, selectedDesign,
                  (index) => setState(() => selectedDesign = index)),
              const SizedBox(height: 50),
              line(),
              InkWell(
                child: Container(
                  height: 40.h,
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [HexColor('FF9300'), HexColor('FF5A00')])),
                  child: AppText(
                    '${AppLocalizations.of(context)!.showResult}:  25',
                    style:
                        typoW600.copyWith(color: colorText0, fontSize: 13.sp),
                  ),
                ),
                onTap: () => RouterUtils.pop(context),
              ),
              itemSpace()
            ],
          ),
        ));
  }

  Widget rangeWidget(double lowerValue, double upperValue,
          Function(List<double>) callback) =>
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppText(
            '4 - 8C+',
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
              max: 10,
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
              onTap: () {},
              child: AppText(
                AppLocalizations.of(context)!.removeFilter,
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

  Widget filterWidget(
      List nameList, int selectIndex, Function(int) onCallBackSelect) {
    return SizedBox(
      height: 27.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: nameList.length,
        itemBuilder: (context, index) {
          return itemListView(
              alignment: Alignment.center,
              itemOnclick: () => onCallBackSelect(index),
              index: index,
              text: nameList[index],
              selectIndex: selectIndex);
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
        child: Container(
          alignment: alignment,
          margin: const EdgeInsets.only(right: 8),
          decoration: selectIndex == index
              ? BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: Utils.backgroundGradientOrangeButton(
                      begin: Alignment.centerLeft, end: Alignment.centerRight),
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

  Widget statusWidget() => Tags(
      columns: 2,
      itemCount: status.length,
      alignment: WrapAlignment.start,
      itemBuilder: (int index) => itemListView(
          itemOnclick: () => setState(() => selectedStatus = index),
          index: index,
          text: status[index],
          selectIndex: selectedStatus));

  Widget itemCorners(
          {required Function(int) onCallBackSelect,
          required String content,
          required int index,
          required int selectIndex}) =>
      GestureDetector(
        onTap: () {
          setState(() {
            onCallBackSelect(index);
          });
        },
        child: Container(
          padding: EdgeInsets.only(left: 17.w, right: 17.w),
          alignment: Alignment.center,
          decoration: selectIndex == index
              ? BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.orange, Colors.red],
                  ),
                )
              : BoxDecoration(
                  borderRadius: BorderRadius.circular(20), color: colorBlack10),
          child: Text(
            content,
            style: typoSmallTextRegular.copyWith(color: colorText45),
          ),
        ),
      );

  @override
  bool get isNewPage => true;

  @override
  int get tabIndex => widget.index;
}
