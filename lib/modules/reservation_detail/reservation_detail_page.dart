import 'package:badges/badges.dart';
import 'package:base_bloc/components/app_button.dart';
import 'package:base_bloc/components/app_scalford.dart';
import 'package:base_bloc/components/appbar_widget.dart';
import 'package:base_bloc/data/globals.dart';
import 'package:base_bloc/data/model/reservation_model.dart';
import 'package:base_bloc/localizations/app_localazations.dart';
import 'package:base_bloc/modules/reservation_detail/reservation_detail_cubit.dart';
import 'package:base_bloc/theme/app_styles.dart';
import 'package:base_bloc/theme/colors.dart';
import 'package:base_bloc/utils/app_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../base/base_state.dart';
import '../../components/app_text.dart';
import '../../gen/assets.gen.dart';

class ReservationDetailPage extends StatefulWidget {
  final int index;
  final ReservationModel model;

  const ReservationDetailPage(
      {Key? key, required this.index, required this.model})
      : super(key: key);

  @override
  State<ReservationDetailPage> createState() => _ReservationDetailPageState();
}

class _ReservationDetailPageState extends BasePopState<ReservationDetailPage> {
  late ReservationDetailCubit _bloc;

  @override
  void initState() {
    _bloc = ReservationDetailCubit();
    super.initState();
  }

  @override
  Widget buildWidget(BuildContext context) {
    return AppScaffold(
      backgroundColor: colorGrey90,
      appbar: appbar(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 18 / 12,
              child: Image.asset(
                Assets.png.test.path,
                fit: BoxFit.cover,
              ),
            ),
            itemSpace(),
            itemWidget(Assets.svg.calendar1, 20,
                Utils.convertDateTimeToEEEDDMMM(widget.model.calendar),
                content2: "${widget.model.startTime}-${widget.model.endTime}"),
            itemSpace(),
            itemWidget(Assets.svg.location, 23, widget.model.address),
            itemSpace(),
            itemSpace(),
            cancelWidget(context)
          ],
        ),
      ),
    );
  }

  Widget cancelWidget(BuildContext context) => AppButton(
        title: AppLocalizations.of(context)!.cancelYourReservation,
        backgroundColor: colorGrey90,
        textStyle: typoW400.copyWith(
            fontSize: 13.sp, color: colorText0.withOpacity(0.87)),
        shapeBorder: RoundedRectangleBorder(
            side: const BorderSide(color: colorGrey50,width: 2),
            borderRadius: BorderRadius.circular(30)),
        onPress: () => _bloc.cancelOnClick(context),
        width: MediaQuery.of(context).size.width / 3.2,
      );

  Widget itemSpace() => SizedBox(
        height: contentPadding + 8,
      );

  Widget itemWidget(String icon, double size, String content1,
          {String? content2}) =>
      Padding(
        padding: EdgeInsets.only(left: contentPadding, right: contentPadding),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: size,
              height: size,
              child: SvgPicture.asset(
                icon,
                color: colorWhite.withOpacity(0.6),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  content1,
                  style: typoW400.copyWith(
                      fontSize: 14.5.sp, color: colorText0.withOpacity(0.87)),
                ),
                Visibility(
                    visible: content2 != null,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: AppText(
                        content2 ?? '',
                        style: typoW400.copyWith(
                            fontSize: 14.5.sp, color: colorText0.withOpacity(0.87)),
                      ),
                    ))
              ],
            ))
          ],
        ),
      );

  PreferredSizeWidget appbar(BuildContext context) => appBarWidget(
        context: context,
        titleStr: AppLocalizations.of(context)!.tomorrow,
        action: [
          Container(
            margin: EdgeInsets.only(left: 10, right: contentPadding),
            child: Badge(
              gradient: LinearGradient(colors: [
                colorYellow70,
                colorPrimary,
                colorPrimary.withOpacity(0.65),
              ]),
              padding: const EdgeInsets.all(2),
              position: BadgePosition.topEnd(top: 13.h, end: 1.h),
              toAnimate: false,
              badgeContent: AppText(
                '1',
                style: typoSmallTextRegular.copyWith(
                    fontSize: 9.sp, color: colorWhite),
              ),
              child: SvgPicture.asset(
                Assets.svg.notification,
                color: colorSurfaceMediumEmphasis,
              ),
            ),
          ),
        ],
      );

  @override
  int get tabIndex => widget.index;
}
