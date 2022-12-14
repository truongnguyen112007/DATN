import 'dart:async';
import 'dart:math';

import 'package:base_bloc/base/base_state.dart';
import 'package:base_bloc/base/hex_color.dart';
import 'package:base_bloc/components/app_scalford.dart';
import 'package:base_bloc/components/app_text_field.dart';
import 'package:base_bloc/components/appbar_widget.dart';
import 'package:base_bloc/data/globals.dart';
import 'package:base_bloc/modules/create_reservation/create_reservation_cubit.dart';
import 'package:base_bloc/modules/create_reservation/create_reservation_state.dart';
import 'package:base_bloc/utils/app_utils.dart';
import 'package:base_bloc/utils/log_utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../components/app_slider.dart';
import '../../components/app_text.dart';
import '../../data/model/places_model.dart';
import '../../localization/locale_keys.dart';
import '../../theme/app_styles.dart';
import '../../theme/colors.dart';

class CreateReservationPage extends StatefulWidget {
  final int index;
  const CreateReservationPage({Key? key, required this.index}) : super(key: key);

  @override
  State<CreateReservationPage> createState() => _CreateReservationPageState();
}

class _CreateReservationPageState extends BasePopState<CreateReservationPage> {
  var lowerAuthorGradeValue = 6.0;
  var upperAuthorGradeValue = 24.0;
  late CreateReservationCubit _bloc;
  late TextEditingController _cityController, _placeController;
  StreamSubscription<PlacesModel>? _getPlaceStream;
  @override
  void initState() {
    _getPlaceStream = Utils.eventBus
        .on<PlacesModel>()
        .listen((model) => _bloc.setPlace(model));
    _cityController = TextEditingController();
    _placeController = TextEditingController();
    _bloc = CreateReservationCubit();
    super.initState();
  }
@override
  void dispose() {
    _getPlaceStream?.cancel();
    super.dispose();
  }
  @override
  Widget buildWidget(BuildContext context) {
    return AppScaffold(
        isTabToHideKeyBoard: true,
        padding: EdgeInsets.all(contentPadding),
        backgroundColor: colorGreyBackground,
        appbar:
            appBarWidget(context: context, titleStr: LocaleKeys.newReservation.tr()),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder<CreateReservationCubit, CreateReservationState>(
                  bloc: _bloc,
                  builder: (c, state) {
                    _cityController.text = state.addressModel?.city ?? '';
                    return textFieldWidget(_cityController, context,
                        LocaleKeys.city.tr(), () => _bloc.addressOnclick(context));
                  }),
              itemSpace(),
              BlocBuilder<CreateReservationCubit, CreateReservationState>(
                  bloc: _bloc,
                  builder: (c, state) {
                    _placeController.text = state.placesModel?.namePlace ?? '';
                    return textFieldWidget(_placeController, context,
                        LocaleKeys.place.tr(), () => _bloc.placeOnclick(context));
                  }),
              itemSpace(),
              itemSpace(),
              AppText(
                LocaleKeys.hours.tr(),
                style: typoW400.copyWith(
                    color: colorText0.withOpacity(0.87), fontSize: 14.5.sp),
              ),
              BlocBuilder<CreateReservationCubit, CreateReservationState>(
                  bloc: _bloc,
                  builder: (c, state) => rangeWidget(state.startTime,
                      state.endTime, (p0) => _bloc.setTime(p0[0], p0[1]))),
              itemSpace(),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () => logE("TAG ONTAB"),
                    child: const Padding(
                      padding: EdgeInsets.only(top: 5, right: 5, bottom: 5),
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: colorWhite,
                        size: 18,
                      ),
                    ),
                  ),
                  Expanded(
                      child: Row(
                    children: [
                      Expanded(
                          child: calendarWidget(context, LocaleKeys.today.tr())),
                      Expanded(
                          child: calendarWidget(context, LocaleKeys.tomorrow.tr())),
                      Expanded(
                          child: calendarWidget(context, LocaleKeys.friday.tr()))
                    ],
                  )),
                  InkWell(
                    child: const Padding(
                      padding: EdgeInsets.only(left: 5, bottom: 5, top: 5),
                      child: Icon(
                        Icons.arrow_forward_ios_outlined,
                        color: colorWhite,
                        size: 18,
                      ),
                    ),
                    onTap: () => logE("TAG ON TAB"),
                  ),
                ],
              )
            ],
          ),
        ));
  }

  Widget dayWidget(String title) => Column(
        children: [
          AppText(
            title,
            style: typoW400.copyWith(
                fontSize: 14.5.sp, color: colorText0.withOpacity(0.87)),
          ),
          AppText('20 jun',
              style: typoW400.copyWith(
                  fontSize: 11.sp, color: colorText0.withOpacity(0.87)))
        ],
      );

  Widget calendarWidget(BuildContext context, String title) =>
      ListView.separated(
        padding: EdgeInsets.only(left: contentPadding, right: contentPadding),
        shrinkWrap: true,
        primary: false,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (c, i) =>
            i == 0 ? dayWidget(title) : itemCalendar(context, i),
        itemCount: 10,
        separatorBuilder: (BuildContext context, int index) => const SizedBox(
          height: 5,
        ),
      );

  Widget itemCalendar(BuildContext context, int index) {
    var dateTime = DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day, Random().nextInt(24), Random().nextInt(60));
    return InkWell(
      child: Container(
        margin: EdgeInsets.only(left: 10.w, right: 10.w),
        height: 30.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: index % 2 == 0 ? HexColor('121212') : Colors.transparent,
            borderRadius: BorderRadius.circular(30)),
        child: AppText(
          Utils.convertTimeToYYHHFromDateTime(dateTime),
          style: typoSmallTextRegular.copyWith(
              color: index % 2 == 0 ? colorText0 : colorText0.withOpacity(0.38),
              decoration: index % 2 == 0
                  ? TextDecoration.none
                  : TextDecoration.lineThrough),
        ),
      ),
      onTap: () => _bloc.timeOnclick(context, dateTime),
    );
  }

  Widget itemSpace() => const SizedBox(
        height: 16,
      );

  Widget textFieldWidget(TextEditingController controller, BuildContext context,
          String title, VoidCallback onTap) =>
      Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 9.h),
            child: AppTextField(
              controller: controller,
              onTap: () => onTap.call(),
              isShowErrorText: false,
              textStyle: typoW400.copyWith(
                  color: colorText0.withOpacity(0.87), fontSize: 14.5.sp),
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
          Container(
            color: colorBlack30,
            margin: EdgeInsets.only(left: contentPadding),
            padding: const EdgeInsets.only(left: 3, right: 7),
            child: AppText(
              title,
              style: typoW400.copyWith(
                  fontSize: 12.sp, color: colorText0.withOpacity(0.6)),
            ),
          ),
        ],
      );

  Widget rangeWidget(double lowerValue, double upperValue,
          Function(List<double>) callback) =>
      Column(
        children: [
          AppText(
            '$lowerValue - $upperValue',
            style: typoW400.copyWith(
                fontSize: 12.5.sp, color: colorText0.withOpacity(0.87)),
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
              max: 24,
              step: AppSliderStep(step: 0.1),
              min: 0,
              onDragging: (handlerIndex, lowerValue, upperValue) =>
                  callback([lowerValue, upperValue]))
        ],
      );

  @override
  int get tabIndex => widget.index;
}
