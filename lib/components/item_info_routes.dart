import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../data/globals.dart';
import '../data/model/routes_model.dart';
import '../localization/locale_keys.dart';
import '../theme/app_styles.dart';
import '../theme/colors.dart';
import '../utils/app_utils.dart';
import 'app_text.dart';

class ItemInfoRoutes extends StatelessWidget {
  final BuildContext context;
  final RoutesModel model;
  final bool isShowSelect;
  final Function(RoutesModel model) callBack;
  final Function(RoutesModel action) detailCallBack;
  final Function(RoutesModel model)? onLongPress;
  final Function(RoutesModel model)? removeSelectCallBack;
  final VoidCallback? filterOnclick;
  final int index;

  const ItemInfoRoutes(
      {Key? key,
      required this.context,
      required this.model,
      required this.callBack,
      required this.index,
      required this.detailCallBack,
      this.filterOnclick,
      this.onLongPress,
      this.removeSelectCallBack,
      this.isShowSelect = false})
      : super(key: key);

  @override
  Widget build(BuildContext context){
    var infoBackground = Utils.getBackgroundColor(model.authorGrade ?? 0);
    return Stack(
      children: [
        Container(
          height: 72.h,
          color: colorGreyBackground,
          key: Key('$index'),
          padding: const EdgeInsets.only(bottom: 10),
          child: InkWell(
              onLongPress: () => onLongPress?.call(model),
              onTap: () => isShowSelect
                  ? filterOnclick?.call()
                  : detailCallBack.call(model),
              // showActionDialog(model, (action) => () {}/*actionCallBack.call(action)*/),
              child: Row(
                children: [
                  isShowSelect
                      ? InkWell(
                      child: Padding(
                        padding: EdgeInsets.only(right: 10.w),
                        child: model.isSelect
                            ? Icon(
                          Icons.radio_button_checked,
                          color: colorPrimary20,
                        )
                            : const Icon(
                          Icons.circle_outlined,
                          color: colorWhite,
                        ),
                      ),
                      onTap: () => filterOnclick?.call())
                      : const SizedBox(),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(
                          left: contentPadding, right: contentPadding + 10),
                      height: 72.h,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          gradient: LinearGradient(
                              stops:  infoBackground.stops,
                              colors: infoBackground.colors)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 3,
                            child: model.hasConner == false
                                ? Center(
                              child: AppText(
                                        Utils.getGrade(model.authorGrade ?? 0),
                                        style: googleFont.copyWith(
                                            fontWeight: FontWeight.w700,
                                      color: colorText0,
                                      fontSize: 31.sp)),
                            )
                                : Center(
                              child: Column(
                                children: [
                                  AppText(
                                    Utils.getGrade(
                                        model.authorGrade ?? 0),
                                    style: googleFont.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: colorText0,
                                  fontSize: 31.sp),
                                      textAlign: TextAlign.end,
                                    ),
                                  AppText(
                                      " ${LocaleKeys.corner.tr()}",
                                      textAlign: TextAlign.start,
                                      style: typoW400.copyWith(
                                          color: colorWhite
                                              .withOpacity(0.87)),
                                    ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                              flex: 8,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: AppText(
                                          model.name ?? '',
                                          style: googleFont.copyWith(
                                              color: colorText0
                                                  .withOpacity(0.87),
                                              fontWeight: FontWeight.w600,
                                              fontSize: 20.5.sp),
                                          maxLine: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      SizedBox(width: 10.w,),
                                      Expanded(
                                        flex: 2,
                                        child: AppText(
                                          Utils.convertTimeStampToYYYYMMYY(
                                              model.created ?? 0),
                                          maxLine: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: googleFont.copyWith(
                                              color: colorWhite,
                                              fontSize: 20.sp,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      AppText(
                                        '${LocaleKeys.routes.tr()} ${model.height}m ',
                                        style: googleFont.copyWith(
                                            color:
                                            colorText0.withOpacity(0.6),
                                            fontSize: 13.sp),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 5.w, right: 5.w),
                                        child: const Icon(
                                          Icons.circle_sharp,
                                          size: 6,
                                          color: colorWhite,
                                        ),
                                      ),
                                      Expanded(
                                          child: AppText(" ${model.name}",
                                              overflow: TextOverflow.ellipsis,
                                              maxLine: 1,
                                              style: googleFont.copyWith(
                                                  color: colorText0
                                                      .withOpacity(0.6),
                                                  fontSize: 13.sp) ))
                                    ],
                                  )
                                ],
                              ))
                        ],
                      ),
                    ),
                  ),
                ],
              )),
        ),
      ],
    );
  }

}
