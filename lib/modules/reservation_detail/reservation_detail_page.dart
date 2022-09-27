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
            itemWidget(Icons.calendar_month,
                Utils.convertDateTimeToEEEDDMMM(widget.model.calendar),
                content2: "${widget.model.startTime}-${widget.model.endTime}"),
            itemSpace(),
            itemWidget(Icons.location_on, widget.model.address),
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
        textStyle: typoSmallTextRegular.copyWith(color: colorGrey45),
        shapeBorder: RoundedRectangleBorder(
            side: const BorderSide(color: colorGrey50),
            borderRadius: BorderRadius.circular(20)),
        onPress: () => _bloc.cancelOnClick(context),
        width: MediaQuery.of(context).size.width / 3.2,
      );

  Widget itemSpace() => SizedBox(
        height: contentPadding + 8,
      );

  Widget itemWidget(IconData icon, String content1, {String? content2}) =>
      Padding(
        padding: EdgeInsets.only(left: contentPadding, right: contentPadding),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: colorGrey45,
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
                  style: typoSmallTextRegular.copyWith(color: colorGrey45),
                ),
                Visibility(
                    visible: content2 != null,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: AppText(
                        content2 ?? '',
                        style:
                            typoSmallTextRegular.copyWith(color: colorGrey45),
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
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.search,
              color: colorGrey45,
            ),
          ),
          SizedBox(
            width: 15.w,
          ),
          SizedBox(
            child: Badge(
              padding: const EdgeInsets.all(2),
              position: BadgePosition.topEnd(top: 13.h, end: -2.h),
              toAnimate: false,
              badgeContent: const Text('1'),
              child: const Icon(
                Icons.notifications_none_sharp,
                color: colorGrey45,
              ),
            ),
          ),
          SizedBox(
            width: 20.w,
          ),
        ],
      );

  @override
  int get tabIndex => widget.index;
}
