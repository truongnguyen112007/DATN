import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../data/model/calender_param.dart';
import '../data/model/sort_param.dart';
import '../localization/locale_keys.dart';
import '../localizations/app_localazations.dart';
import '../modules/favourite/favourite_cubit.dart';
import '../theme/app_styles.dart';
import '../theme/colors.dart';
import 'app_text.dart';

class CalenderWidget extends StatefulWidget {
  final CalenderParam? model;

  final Function(CalenderParam) callBack;

  const CalenderWidget({Key? key, required this.callBack, required this.model})
      : super(key: key);

  @override
  State<CalenderWidget> createState() => _CalenderWidgetState();
}

class _CalenderWidgetState extends State<CalenderWidget> {
  late CalenderParam currentAction;

  @override
  void initState() {
    currentAction =
        widget.model ?? CalenderParam(name: "Hôm nay");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          decoration:  BoxDecoration(
            color: colorGreen50,
            borderRadius: BorderRadius.only(
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
              itemCalender(
                "Hôm nay",
                CalenderParam(name: "Hôm nay"),
                    (action) => widget.callBack.call(action),
              ),
              itemCalender(
               "Hôm qua",
                CalenderParam(name:  "Hôm qua"),
                    (action) => widget.callBack.call(action),
              ),
              itemCalender(
                "Tháng này",
                CalenderParam(
                    name: "Tháng này"),
                    (action) => widget.callBack.call(action),
              ),
              itemCalender(
                "Tháng trước",
                CalenderParam(
                    name: "Tháng trước"),
                    (action) => widget.callBack.call(action),
              ),
              itemCalender(
                "Toàn thời gian",
                CalenderParam(
                    name: "Toàn thời gian"),
                    (action) => widget.callBack.call(action),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget itemCalender(
      String text, CalenderParam action, Function(CalenderParam) itemSortCallBack) {
    return InkWell(
      child: Column(
        children: [
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
                            ? Colors.yellowAccent
                            : colorWhite,
                        width: 1.5),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Visibility(
                    visible: currentAction.name == action.name ? true : false,
                    child: const Center(
                      child: Icon(
                        Icons.check,
                        color: Colors.yellowAccent,
                        size: 15,
                      ),
                    ),
                  ),
                ),
                SizedBox(width:30.w,),
                Expanded(
                  child: AppText(
                    text,
                    style: typoW400.copyWith(
                        color: currentAction.name == action.name
                            ? Colors.yellowAccent
                            : colorWhite,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: colorBlack,
            height: 0.1.h,
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
