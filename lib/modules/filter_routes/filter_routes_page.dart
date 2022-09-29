import 'package:base_bloc/base/base_state.dart';
import 'package:base_bloc/components/app_button.dart';
import 'package:base_bloc/components/app_scalford.dart';
import 'package:base_bloc/components/app_slider.dart';
import 'package:base_bloc/data/globals.dart';
import 'package:base_bloc/localizations/app_localazations.dart';
import 'package:base_bloc/router/router_utils.dart';
import 'package:base_bloc/theme/app_styles.dart';
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

  @override
  Widget buildWidget(BuildContext context) {
    return AppScaffold(
        resizeToAvoidBottomInset: false,
        isTabToHideKeyBoard: false,
        padding: EdgeInsets.only(left: contentPadding, right: contentPadding),
        appbar: appbar(context),
        backgroundColor: colorBackgroundColor,
        body: Column(
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
                            vertical: 20.0, horizontal: 16)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: AppText(
                    "  ${AppLocalizations.of(context)!.author} ",
                    style: typoSmallTextRegular.copyWith(
                        color: colorText70,
                        backgroundColor: colorBackgroundColor),
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
            listFilterDialog(corners, selectedCorner, (index) {
              selectedCorner = index;
              setState(() {});
            }),
            itemSpace(),
            itemTitle(AppLocalizations.of(context)!.authorsGrade),
            rangeWidget(lowerAuthorGradeValue, upperAuthorGradeValue, (values) {
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
            listFilterDialog(designs, selectedDesign, (index) {
              selectedDesign = index;
              setState(() {});
            }),
            const Spacer(),
            line(),
            AppButton(
              backgroundColor: Colors.deepOrange,
              height: 40.h,
              shapeBorder: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(30),
                ),
              ),
              onPress: () => RouterUtils.pop(context),
              titleWidget: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppText(
                    '${AppLocalizations.of(context)!.showResult}:',
                    style: typoSmallTextRegular.copyWith(color: colorText0),
                  ),
                  SizedBox(
                    width: 5.w,
                  ),
                  AppText(
                    '25',
                    style: typoSmallTextRegular.copyWith(color: colorText0),
                  ),
                ],
              ),
            ),
            itemSpace()
          ],
        ));
  }

  Widget rangeWidget(double lowerValue, double upperValue,
          Function(List<double>) callback) =>
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppText(
            '4 - 8C+',
            style: typoSmallTextRegular.copyWith(color: colorText45),
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
        backgroundColor: colorBackgroundColor,
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
                style: typoSmallTextRegular.copyWith(color: colorOrange100),
              ),
            ),
          ),
          SizedBox(
            width: contentPadding,
          )
        ],
      );

  Widget textFilter(String text) {
    return Padding(
      padding: EdgeInsets.only(left: contentPadding),
      child: AppText(
        text,
        style: TextStyle(color: Colors.white60, fontSize: 20),
      ),
    );
  }

  Widget itemTitle(String text) => AppText(
        text,
        style: typoNormalTextRegular.copyWith(color: colorText50),
      );

  Widget listFilterDialog(
      List nameList, int selectIndex, Function(int) onCallBackSelect) {
    return SizedBox(
      height: 30.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: nameList.length,
        itemBuilder: (context, index) {
          return itemCorners(
              onCallBackSelect: (index) {
                selectIndex = index;
                setState(() {});
              },
              content: nameList[index],
              index: index,
              selectIndex: selectIndex);
        },
        separatorBuilder: (BuildContext context, int index) => const SizedBox(
          width: 12,
        ),
      ),
    );
  }

  Widget statusWidget() => Tags(
        columns: 2,
        itemCount: status.length,
        alignment: WrapAlignment.start,
        itemBuilder: (int index) => InkWell(
          child: Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: selectedStatus == index
                ? BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.orange, Colors.red],
                    ),
                  )
                : BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: colorBlack10),
            padding: const EdgeInsets.all(10),
            child: AppText(
              status[index],
              style: typoSmallTextRegular.copyWith(color: colorText45),
            ),
          ),
          onTap: () {
            selectedStatus = index;
            setState(() {});
          },
        ),
      );

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
