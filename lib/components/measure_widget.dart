import 'dart:async';

import 'package:base_bloc/data/eventbus/scale_event.dart';
import 'package:base_bloc/theme/colors.dart';
import 'package:base_bloc/utils/app_utils.dart';
import 'package:base_bloc/utils/log_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../base/hex_color.dart';
import '../theme/app_styles.dart';
import 'app_text.dart';

class MeasureWidget extends StatelessWidget {
  final int row;
  final double sizeHoldSet;
  double scale;
  int dy;

  MeasureWidget(
      {Key? key,
      required this.row,
      required this.sizeHoldSet,
      required this.scale,
      this.dy = 1})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        reverse: true,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: row,
        itemBuilder: (BuildContext context, int index) => Container(
            height: sizeHoldSet,
            alignment: Alignment.centerRight,
            child: Stack(
              children: [
                Positioned.fill(
                    child: Center(
                        child: Container(
                            width: 3, height: 0.3, color: colorGrey70))),
                SizedBox(
                    width: 6.5.w,
                    child: AppText(
                        (index + 1).toString().length == 1
                            ? '  ${(index + 1)}'
                            : '${index + 1}',
                        style: typoW600.copyWith(
                            backgroundColor: colorBlack,
                            fontSize: 2.sp,
                            color: colorText0.withOpacity(0.8))))
              ],
            )));
  }
}
