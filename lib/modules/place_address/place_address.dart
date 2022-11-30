import 'package:base_bloc/base/base_state.dart';
import 'package:base_bloc/components/app_scalford.dart';
import 'package:base_bloc/data/model/places_model.dart';
import 'package:base_bloc/modules/place_address/photos/photos.dart';
import 'package:base_bloc/modules/place_address/schedule/schedule.dart';
import 'package:base_bloc/theme/app_styles.dart';
import 'package:base_bloc/theme/colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../components/app_text.dart';
import '../../gen/assets.gen.dart';
import '../../localization/locale_keys.dart';
import '../../utils/log_utils.dart';
import 'address/address.dart';

class PlaceAddress extends StatefulWidget {
  final int index;
  final PlacesModel model;

  const PlaceAddress({Key? key, required this.index, required this.model})
      : super(key: key);

  @override
  State<PlaceAddress> createState() => _PlaceAddressState();
}

class _PlaceAddressState extends BasePopState<PlaceAddress>
    with AnimationEagerListenerMixin, SingleTickerProviderStateMixin {
  final PageController controller = PageController();
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(() {
      controller.jumpToPage(tabController.index);
      logE("${tabController.index}");
    });
    super.initState();
  }

  @override
  Widget buildWidget(BuildContext context) {
    return AppScaffold(
      backgroundColor: colorGreyBackground,
      appbar: AppBar(
        backgroundColor: colorBlack,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Image.asset(
                  Assets.png.mural.path,
                  width: 45,
                ),
                SizedBox(
                  width: 10.w,
                ),
                Expanded(
                    child: AppText(
                      "Center Wspinaczkowe Murall",
                      style: googleFont.copyWith(
                          color: colorWhite,
                          fontSize: 25.sp,
                          fontWeight: FontWeight.w600),
                    ))
              ],
            ),
          ),
          Container(
            color: colorBlack.withOpacity(0.5),
            height: 0.7.h,
          ),
          Stack(
              children: [
                Positioned.fill(
                    child: Align(alignment:Alignment.bottomCenter,
                        child: Container(color: colorGrey60, height: 3,))),
                TabBar(
                  labelPadding: EdgeInsets.only(top: 7.h, bottom: 7.h),
                  controller: tabController,
                  labelColor: colorPrimary,
                  labelStyle: googleFont.copyWith(
                      fontSize: 14.w, fontWeight: FontWeight.w600),
                  unselectedLabelColor: colorSubText,
                  indicatorColor: colorPrimary,
                  indicatorWeight: 2.5.w,
                  tabs: [
                    Tab(text: LocaleKeys.address.tr()),
                    Tab(text: LocaleKeys.schedule.tr()),
                    Tab(text: LocaleKeys.photos.tr()),
                  ],
                ),
              ]
          ),
          Expanded(
            child: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: controller,
              children: [
                Address(
                  model: widget.model, index: widget.index,
                ),
                const Schedule(),
                const Photos()
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  int get tabIndex => widget.index;
}
