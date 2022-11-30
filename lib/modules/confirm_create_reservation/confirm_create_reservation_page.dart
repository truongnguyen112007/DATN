import 'dart:async';

import 'package:base_bloc/base/base_state.dart';
import 'package:base_bloc/base/hex_color.dart';
import 'package:base_bloc/components/app_scalford.dart';
import 'package:base_bloc/components/app_text_field.dart';
import 'package:base_bloc/components/appbar_widget.dart';
import 'package:base_bloc/config/constant.dart';
import 'package:base_bloc/data/globals.dart';
import 'package:base_bloc/data/model/address_model.dart';
import 'package:base_bloc/data/model/places_model.dart';
import 'package:base_bloc/modules/confirm_create_reservation/confirm_create_reservation_cubit.dart';
import 'package:base_bloc/modules/confirm_create_reservation/confirm_create_reservation_state.dart';
import 'package:base_bloc/theme/app_styles.dart';
import 'package:base_bloc/theme/colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../components/app_text.dart';
import '../../localization/locale_keys.dart';
import '../../utils/app_utils.dart';

class ConfirmCreateReservationPage extends StatefulWidget {
  final PlacesModel placesModel;
  final AddressModel addressModel;
  final DateTime dateTime;

  const ConfirmCreateReservationPage(
      {Key? key,
      required this.placesModel,
      required this.addressModel,
      required this.dateTime})
      : super(key: key);

  @override
  State<ConfirmCreateReservationPage> createState() =>
      _ConfirmCreateReservationPageState();
}

class _ConfirmCreateReservationPageState
    extends BasePopState<ConfirmCreateReservationPage> {
  late TextEditingController placeController, wallController;
  late ConfirmCreateReservationCubit _bloc;
  StreamSubscription<PlacesModel>? _getPlaceStream;

  @override
  void initState() {
    _bloc = ConfirmCreateReservationCubit();
    _bloc.setData(widget.addressModel, widget.placesModel, widget.dateTime);
    _getPlaceStream = Utils.eventBus
        .on<PlacesModel>()
        .listen((model) => _bloc.setPlace(model));
    placeController = TextEditingController();
    wallController = TextEditingController();
    placeController.text = widget.placesModel.namePlace;
    wallController.text = widget.addressModel.city;
    super.initState();
  }

  @override
  Widget buildWidget(BuildContext context) {
    return AppScaffold(
        isTabToHideKeyBoard: true,
        backgroundColor: colorGreyBackground,
        padding: EdgeInsets.all(contentPadding),
        appbar: appbar(context),
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              calendarWidget(context),
              itemSpace(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 2),
                    child: Icon(
                      Icons.location_on,
                      color: colorText45,
                      size: 28,
                    ),
                  ),
                  SizedBox(
                    width: contentPadding,
                  ),
                  Expanded(
                      child: Column(
                    children: [
                      BlocBuilder<ConfirmCreateReservationCubit,
                          ConfirmCreateReservationState>(
                        builder: (c, state) {
                          placeController.text =
                              state.placesModel?.namePlace ?? '';
                          return textFieldWidget(
                              3,
                              placeController,
                              context,
                              LocaleKeys.place.tr(),
                              () => _bloc.placeOnclick(context));
                        },
                        bloc: _bloc,
                      ),
                      itemSpace(),
                      BlocBuilder<ConfirmCreateReservationCubit,
                          ConfirmCreateReservationState>(
                        builder: (c, state) {
                          wallController.text = state.addressModel?.city ?? '';
                          return textFieldWidget(
                              1,
                              wallController,
                              context,
                              LocaleKeys.wall.tr(),
                              () => _bloc.addressOnclick(context));
                        },
                        bloc: _bloc,
                      )
                    ],
                  ))
                ],
              ),
              itemSpace(height: 30),
              InkWell(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.center,
                  height: 37.h,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [HexColor('FF9300'), HexColor('FF5A00')],
                      )),
                  child: AppText(
                    LocaleKeys.confirm_information.tr(),
                    style:
                        typoW600.copyWith(fontSize: 14.sp, color: colorText0),
                  ),
                ),
                onTap: () => _bloc.confirmOnclick(context),
              )
            ],
          ),
        ));
  }

  PreferredSizeWidget appbar(BuildContext context) =>
      appBarWidget(context: context, titleStr: LocaleKeys.newReservation.tr());

  Widget calendarWidget(BuildContext context) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.calendar_month,
            color: colorText45,
            size: 26,
          ),
          SizedBox(
            width: contentPadding,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                'Thues day,9 june',
                style: typoW400.copyWith(
                    color: colorText0.withOpacity(0.87), fontSize: 14.5.sp),
              ),
              itemSpace(height: 7),
              AppText(
                '9:30 - 10:00',
                style: typoW400.copyWith(
                    color: colorText0.withOpacity(0.87), fontSize: 14.5.sp),
              )
            ],
          ),
        ],
      );

  Widget itemSpace({double? height}) => SizedBox(
        height: height ?? 10,
      );

  Widget textFieldWidget(int maxLine, TextEditingController controller,
          BuildContext context, String title, VoidCallback onTap) =>
      Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 9.h),
            child: AppTextField(
              maxLine: maxLine,
              controller: controller,
              onTap: () => onTap.call(),
              isShowErrorText: false,
              textStyle: typoW400.copyWith(
                  fontSize: 14.5.sp, color: colorText0.withOpacity(0.87)),
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
            color: colorGreyBackground,
            margin: EdgeInsets.only(left: contentPadding),
            padding: const EdgeInsets.only(left: 3, right: 7),
            child: AppText(
              title,
              style: typoW400.copyWith(
                  fontSize: 13.sp,
                  backgroundColor: colorGreyBackground,
                  color: colorText0.withOpacity(0.6)),
            ),
          ),
        ],
      );

  @override
  int get tabIndex => BottomNavigationConstant.TAB_RESERVATIONS;
}
