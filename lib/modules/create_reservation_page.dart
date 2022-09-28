import 'package:badges/badges.dart';
import 'package:base_bloc/base/base_state.dart';
import 'package:base_bloc/components/app_scalford.dart';
import 'package:base_bloc/components/app_text_field.dart';
import 'package:base_bloc/components/appbar_widget.dart';
import 'package:base_bloc/config/constant.dart';
import 'package:base_bloc/data/globals.dart';
import 'package:base_bloc/localizations/app_localazations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../components/app_slider.dart';
import '../components/app_text.dart';
import '../components/calendar/weekly_date_picker.dart';
import '../theme/app_styles.dart';
import '../theme/colors.dart';

class CreateReservationPage extends StatefulWidget {
  const CreateReservationPage({Key? key}) : super(key: key);

  @override
  State<CreateReservationPage> createState() => _CreateReservationPageState();
}

class _CreateReservationPageState extends BasePopState<CreateReservationPage> {
  var lowerAuthorGradeValue = 2.0;
  var upperAuthorGradeValue = 5.0;

  @override
  Widget buildWidget(BuildContext context) {
    return AppScaffold(
        padding: EdgeInsets.all(contentPadding),
        backgroundColor: colorBlack30,
        appbar: appBarWidget(
            context: context,
            titleStr: AppLocalizations.of(context)!.newReservation),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            textFieldWidget(context, AppLocalizations.of(context)!.city),
            itemSpace(),
            textFieldWidget(context, AppLocalizations.of(context)!.place),
            itemSpace(),
            AppText(
              AppLocalizations.of(context)!.hours,
              style: typoSmallTextRegular.copyWith(color: colorText40),
            ),
            itemSpace(),
            rangeWidget(lowerAuthorGradeValue, upperAuthorGradeValue, (p0) {}),
            WeeklyDatePicker(
              changeDay: (dateTime) {},
              callBackJumpToNextPage: (dateTime) {},
              callbackIndex: (int index) {},
              selectedDay: DateTime.now(),
              pageController: (PageController controller) {},
            )
          ],
        ));
  }

  Widget itemSpace() => const SizedBox(
        height: 15,
      );

  Widget textFieldWidget(BuildContext context, String title) => Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 9.h),
            child: AppTextField(
              isShowErrorText: false,
              textStyle: typoSmallTextRegular.copyWith(
                color: colorText0,
              ),
              cursorColor: Colors.white60,
              decoration: decorTextField.copyWith(
                  suffixIcon: Padding(
                    padding: EdgeInsets.only(left: 15.w),
                    child: const Icon(
                      Icons.arrow_drop_down_outlined,
                      color: colorGrey32,
                    ),
                  ),
                  fillColor: Colors.transparent,
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 16)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: AppText(
              "  $title ",
              style: typoSmallTextRegular.copyWith(
                  color: colorText62, backgroundColor: colorBlack30),
            ),
          ),
        ],
      );

  Widget rangeWidget(double lowerValue, double upperValue,
          Function(List<double>) callback) =>
      Column(
        children: [
          AppText(
            '6:00 - 22:00',
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
                  inactiveTrackBar: BoxDecoration(color: colorGrey85),
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

  @override
  int get tabIndex => BottomNavigationConstant.TAB_RESERVATIONS;
}
