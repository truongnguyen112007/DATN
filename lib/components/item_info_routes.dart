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
import 'app_text.dart';

class ItemInfoRoutes extends StatelessWidget {
  final BuildContext context;
  final RoutesModel model;
  final Function(RoutesModel model) callBack;
  final Function(RoutesModel action) detailCallBack;
  final Function(RoutesModel model)? onLongPress;
  final Function(RoutesModel model)? removeSelectCallBack;
  final int index;

  const ItemInfoRoutes(
      {Key? key,
      required this.context,
      required this.model,
      required this.callBack,
      required this.index,
      required this.detailCallBack,
      this.onLongPress,
      this.removeSelectCallBack})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          Container(
            height: 88.h,
            color: colorBlack20,
            key: Key('$index'),
            padding: const EdgeInsets.only(bottom: 10),
            child: GestureDetector(
              onLongPress: () => onLongPress?.call(model),
              onTap: () => detailCallBack.call(model)/*showActionDialog(
                  model, (action) => actionCallBack.call(action))*/,
              child: Container(
                padding: EdgeInsets.only(
                    left: contentPadding + 10, right: contentPadding + 10),
                height: 75.h,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: LinearGradient(
                        colors: getBackgroundColor(model.grade))),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    model.status == null
                        ? AppText(
                            model.grade,
                            style: typoLargeTextRegular.copyWith(
                                color: colorText0, fontSize: 33.sp),
                            textAlign: TextAlign.end,
                          )
                        : Stack(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(bottom: 5.h),
                                child: AppText(
                                  model.grade,
                                  style: typoLargeTextRegular.copyWith(
                                      color: colorText0, fontSize: 33.sp),
                                  textAlign: TextAlign.end,
                                ),
                              ),
                              Positioned.fill(
                                  child: Container(
                                alignment: Alignment.bottomCenter,
                                child: AppText(
                                  model.status ?? '',
                                  textAlign: TextAlign.center,
                                  style: typoSuperSmallText300.copyWith(
                                      color: colorText0),
                                ),
                              ))
                            ],
                          ),
                    SizedBox(
                      width: 22.w,
                    ),
                    Expanded(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AppText(
                          model.name,
                          style: typoLargeTextRegular.copyWith(
                              color: colorText0, fontSize: 23.sp),
                          maxLine: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Row(
                          children: [
                            AppText(
                              '${AppLocalizations.of(context)!.routes} ${model.height}m ',
                              style:
                                  typoSmallText300.copyWith(color: colorText0),
                            ),
                            const Icon(
                              Icons.ac_unit_rounded,
                              size: 6,
                              color: colorWhite,
                            ),
                            Expanded(
                                child: AppText(
                              " ${model.author}",
                              overflow: TextOverflow.ellipsis,
                              maxLine: 1,
                              style:
                                  typoSmallText300.copyWith(color: colorText0),
                            ))
                          ],
                        )
                      ],
                    ))
                  ],
                ),
              ),
            ),
          ),
          model.isSelect
              ? Container(
                  height: 88.h,
                  padding: const EdgeInsets.only(bottom: 10),
                  width: MediaQuery.of(context).size.width,
                  child: InkWell(
                    onTap: () => removeSelectCallBack?.call(model),
                    child: Container(
                      alignment: Alignment.bottomRight,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.grey.withOpacity(0.8)),
                      child: Container(
                        margin: EdgeInsets.only(
                            right: contentPadding, bottom: contentPadding),
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(color: colorWhite)),
                        child: const Icon(
                          Icons.check,
                          size: 17,
                          color: colorWhite,
                        ),
                      ),
                    ),
                  ),
                )
              : const SizedBox()
        ],
      );

  List<Color> getBackgroundColor(String value) {
    switch (value) {
      case '4':
        return [colorGreen70, colorGreen70];
      case '5A':
        return [
          colorOrange80,
          colorGreen70,
          colorGreen70,
          colorGreen70,
          colorGreen70
        ];
      case '5C':
        return [colorOrange80, colorGreen70, colorGreen70];
      case '6A':
        return [colorOrange80, colorGreen70, colorGreen70];
      case '7B':
        return [colorRed80, colorOrange80, colorOrange80];
      case '8A':
        return [colorRed100, colorRed90, colorOrange110];
      case '5B':
        return [colorOrange110, colorGreen50, colorGreen55];
      default:
        return [
          colorRed100,
          colorRed100,
        ];
    }
  }

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
