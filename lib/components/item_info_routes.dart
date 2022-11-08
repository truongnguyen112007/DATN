import 'package:base_bloc/utils/log_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../data/globals.dart';
import '../data/model/routes_model.dart';
import '../localizations/app_localazations.dart';
import '../modules/playlist/playlist_cubit.dart';
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
  Widget build(BuildContext context) => Stack(
        children: [
          Container(
            height: 72.h,
            color: colorGreyBackground,
            key: Key('$index'),
            padding: const EdgeInsets.only(bottom: 10),
            child: InkWell(
                onLongPress: () => onLongPress?.call(model),
                onTap: () => detailCallBack.call(model),
                // showActionDialog(model, (action) => () {}/*actionCallBack.call(action)*/),
                child: Row(
                  children: [
                    isShowSelect
                        ? InkWell(
                            child: Padding(
                              padding: EdgeInsets.only(right: 10.w),
                              child: model.isSelect
                                  ? Icon(Icons.radio_button_checked,
                                      color: colorPrimary20)
                                  : const Icon(
                                      Icons.circle_outlined,
                                      color: colorWhite,
                                    ),
                            ),
                            onTap: () => filterOnclick?.call(),
                          )
                        : const SizedBox(),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(
                            left: contentPadding * 3,
                            right: contentPadding + 10),
                        height: 72.h,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            gradient: LinearGradient(
                                colors: Utils.getBackgroundColor(
                                    model.authorRate.toString()))),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            model.modified == null
                                ? AppText(model.authorRate.toString(),
                                    style: googleFont.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: colorText0,
                                        fontSize: 31.sp))
                                : AppText(
                                    "${model.authorRate}",
                                    style: googleFont.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: colorText0,
                                        fontSize: 31.sp),
                                    textAlign: TextAlign.center,
                                  ),
                            SizedBox(width: contentPadding * 3),
                            Expanded(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AppText(
                                  model.name ?? '',
                                  style: googleFont.copyWith(
                                      color: colorText0.withOpacity(0.87),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20.5.sp),
                                  maxLine: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    AppText(
                                      '${AppLocalizations.of(context)!.routes} ${model.height}m ',
                                      style: googleFont.copyWith(
                                          color: colorText0.withOpacity(0.6),
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
                                                color:
                                                    colorText0.withOpacity(0.6),
                                                fontSize: 13.sp)))
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

  void showActionDialog(RoutesModel model, Function(ItemAction) callBack) {
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (x) => Wrap(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFF212121),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: contentPadding,
                      ),
                      itemAction(
                          Icons.thumb_up_alt,
                          AppLocalizations.of(context)!.moveToPlaylist,
                          model,
                          ItemAction.MOVE_TO_TOP,
                          () => callBack.call(ItemAction.MOVE_TO_TOP)),
                      itemAction(
                          Icons.account_balance_rounded,
                          AppLocalizations.of(context)!.addToPlaylist,
                          model,
                          ItemAction.ADD_TO_PLAYLIST,
                          () => callBack.call(ItemAction.ADD_TO_PLAYLIST)),
                      itemAction(
                          Icons.add,
                          AppLocalizations.of(context)!.removeFromPlaylist,
                          model,
                          ItemAction.REMOVE_FROM_PLAYLIST,
                          () => callBack.call(ItemAction.REMOVE_FROM_PLAYLIST)),
                      itemAction(
                          Icons.favorite,
                          AppLocalizations.of(context)!.addToFavourite,
                          model,
                          ItemAction.ADD_TO_FAVOURITE,
                          () => callBack.call(ItemAction.ADD_TO_FAVOURITE)),
                      itemAction(
                          Icons.remove_circle_outline,
                          AppLocalizations.of(context)!.removeFromFavorite,
                          model,
                          ItemAction.REMOVE_FROM_PLAYLIST,
                          () => callBack.call(ItemAction.REMOVE_FROM_PLAYLIST)),
                      itemAction(
                          Icons.share,
                          AppLocalizations.of(context)!.share,
                          model,
                          ItemAction.SHARE,
                          () => callBack.call(ItemAction.SHARE)),
                      itemAction(
                          Icons.copy,
                          AppLocalizations.of(context)!.copy,
                          model,
                          ItemAction.COPY,
                          () => callBack.call(ItemAction.COPY)),
                      itemAction(
                          Icons.edit,
                          AppLocalizations.of(context)!.edit,
                          model,
                          ItemAction.EDIT,
                          () => callBack.call(ItemAction.EDIT)),
                      itemAction(
                          Icons.delete,
                          AppLocalizations.of(context)!.delete,
                          model,
                          ItemAction.DELETE,
                          () => callBack.call(ItemAction.DELETE)),
                    ],
                  ),
                )
              ],
            ));
  }

  Widget itemAction(IconData icon, String text, RoutesModel model,
      ItemAction action, VoidCallback filterCallBack) {
    return InkWell(
      child: Padding(
        padding: EdgeInsets.all(contentPadding),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.white,
            ),
            SizedBox(
              width: 40.w,
            ),
            AppText(
              text,
              style: typoSuperSmallTextRegular.copyWith(color: colorText0),
            )
          ],
        ),
      ),
      onTap: () => filterCallBack.call(),
    );
  }
}
