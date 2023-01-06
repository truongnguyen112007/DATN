import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../data/eventbus/refresh_event.dart';
import '../data/globals.dart';
import '../theme/app_styles.dart';
import '../theme/colors.dart';
import '../utils/app_utils.dart';
import '../utils/log_utils.dart';
import 'app_text.dart';

class ItemFilterWidget extends StatefulWidget {
  final Map<String, dynamic> data;
  final Function(bool) callback;
  final bool isSelect;
  final bool isLoginFilter;

  const ItemFilterWidget(
      {Key? key,
        required this.data,
        required this.callback,
        this.isSelect = false,required this.isLoginFilter})
      : super(key: key);

  @override
  State<ItemFilterWidget> createState() => _ItemFilterWidgetState();
}

class _ItemFilterWidgetState extends State<ItemFilterWidget> {
  var isSelect = false;
  StreamSubscription<RefreshEvent>? _refreshStream;

  @override
  void initState() {
    isSelect = widget.isSelect;
    _refreshStream = Utils.eventBus.on<RefreshEvent>().listen((event) {
      if (event.type == RefreshType.FILTER) {
        if (mounted)
          setState(() {
            isSelect = false;
          });
      }
    });
    /*   widget.filterController?._getSelect = (value) {
      setState(() {
        isSelect = value;
      });
    };*/
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        decoration: isSelect && widget.isLoginFilter == false
            ? BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: Utils.backgroundGradientOrangeButton(),
        )
            : BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: colorBlack10),
        padding:
        EdgeInsets.only(left: 11.w, right: 11.w, top: 5.h, bottom: 5.h),
        child: AppText(
          widget.data.keys.first,
          style: typoW600.copyWith(
              color: colorText0.withOpacity(0.87), fontSize: 13.2.sp),
        ),
      ),
      onTap: () => itemOnclick.call(),
    );
  }

  void itemOnclick() {
    setState(() {
      isSelect = !isSelect;
    });
    widget.callback(isSelect);
  }
}
