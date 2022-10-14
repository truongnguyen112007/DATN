import 'package:base_bloc/base/base_state.dart';
import 'package:base_bloc/components/app_scalford.dart';
import 'package:base_bloc/components/app_text.dart';
import 'package:base_bloc/config/constant.dart';
import 'package:base_bloc/data/globals.dart';
import 'package:base_bloc/localizations/app_localazations.dart';
import 'package:base_bloc/theme/app_styles.dart';
import 'package:base_bloc/theme/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../components/appbar_widget.dart';
import '../../gen/assets.gen.dart';

class CreateReservationSuccessPage extends StatefulWidget {
  const CreateReservationSuccessPage({Key? key}) : super(key: key);

  @override
  State<CreateReservationSuccessPage> createState() =>
      _CreateReservationSuccessPageState();
}

class _CreateReservationSuccessPageState
    extends BasePopState<CreateReservationSuccessPage> {
  @override
  Widget buildWidget(BuildContext context) {
    return AppScaffold(
      padding: EdgeInsets.all(contentPadding),
      appbar: appbar(context),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            itemPlace(height: 20),
            SvgPicture.asset(
              Assets.svg.message,
              width: 36.w,
            ),
            itemPlace(height: 20),
            AppText(
              LocaleKeys.check_your_email,
              style: typoW700.copyWith(fontSize: 29.sp),
            ),
            itemPlace(),
            AppText(
              LocaleKeys.it_is_not_reservation,
              style: typoW400.copyWith(fontSize: 14.sp),
              textAlign: TextAlign.center,
            ),
            itemPlace(height: 20),
            AppText(
              LocaleKeys.please_check_mail,
              style: typoW400.copyWith(fontSize: 14.sp),
            )
          ],
        ),
      ),
    );
  }

  SizedBox itemPlace({double? height}) => SizedBox(height: height ?? 10);

  PreferredSizeWidget appbar(BuildContext context) =>
      appBarWidget(context: context, titleStr: LocaleKeys.newReservation);

  @override
  int get tabIndex => BottomNavigationConstant.TAB_RESERVATIONS;
}
