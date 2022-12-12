import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../data/model/sort_param.dart';
import '../localization/locale_keys.dart';
import '../localizations/app_localazations.dart';
import '../modules/favourite/favourite_cubit.dart';
import '../theme/app_styles.dart';
import '../theme/colors.dart';
import 'app_text.dart';

class SortWidget extends StatefulWidget {
  final SortParam? model;

  final Function(SortParam) callBack;

  const SortWidget({Key? key, required this.callBack, required this.model})
      : super(key: key);

  @override
  State<SortWidget> createState() => _SortWidgetState();
}

class _SortWidgetState extends State<SortWidget> {
  late SortParam currentAction;

  @override
  void initState() {
    currentAction =
        widget.model ?? SortParam(name: LocaleKeys.defaultArrangement.tr());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          decoration: BoxDecoration(
            color: colorShowActionDialog,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          ),
          child: Column(
            children: [
              SizedBox(
                height: 8.h,
              ),
              Container(
                width: 70.w,
                height: 2.h,
                color: colorWhite,
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
                child: AppText(
                  LocaleKeys.sortBy.tr(),
                  style: typoW600.copyWith(
                      color: colorWhite,
                      fontWeight: FontWeight.w600,
                      fontSize: 14.sp),
                ),
              ),
              itemSort(
                LocaleKeys.defaultArrangement.tr(),
                SortParam(name: LocaleKeys.defaultArrangement.tr()),
                (action) => widget.callBack.call(action),
              ),
              itemSort(
                LocaleKeys.theRouteName.tr(),
                SortParam(name: LocaleKeys.theRouteName.tr(), orderType: 1,orderValue: 1),
                (action) => widget.callBack.call(action),
              ),
              itemSort(
                LocaleKeys.authorDes.tr(),
                SortParam(
                    name: LocaleKeys.authorDes.tr(), orderValue: 0, orderType: 2),
                (action) => widget.callBack.call(action),
              ),
              itemSort(
                LocaleKeys.authorAsc.tr(),
                SortParam(
                    name: LocaleKeys.authorAsc.tr(), orderValue: 1, orderType: 2),
                (action) => widget.callBack.call(action),
              ),
              itemSort(
                LocaleKeys.userDes.tr(),
                SortParam(
                    name: LocaleKeys.userDes.tr(), orderType: 3, orderValue: 0),
                (action) => widget.callBack.call(action),
              ),
              itemSort(
                LocaleKeys.userAsc.tr(),
                SortParam(
                    name: LocaleKeys.userAsc.tr(), orderType: 3, orderValue: 1),
                (action) => widget.callBack.call(action),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget itemSort(
      String text, SortParam action, Function(SortParam) itemSortCallBack) {
    return InkWell(
      child: Column(
        children: [
          Container(
            color: colorWhite,
            height: 0.1.h,
          ),
          Padding(
            padding: EdgeInsets.only(left: 30.w, top: 18.h, bottom: 18.h),
            child: Row(
              children: [
                Container(
                  width: 20.w,
                  height: 20.w,
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: currentAction.name == action.name
                            ? colorOrange90
                            : colorGrey50,
                        width: 1.5),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Visibility(
                    visible: currentAction.name == action.name ? true : false,
                    child: const Center(
                      child: Icon(
                        Icons.check,
                        color: colorOrange90,
                        size: 15,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: AppText(
                    textAlign: TextAlign.center,
                    text,
                    style: typoW400.copyWith(
                        color: currentAction.name == action.name
                            ? colorOrange90
                            : colorWhite,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      onTap: () {
        setState(() {
          itemSortCallBack.call(action);
          currentAction = action;
        });
      },
    );
  }
}
