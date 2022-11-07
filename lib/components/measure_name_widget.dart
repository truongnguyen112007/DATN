import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_styles.dart';
import '../theme/colors.dart';
import 'app_text.dart';

class MeasureNameBoxWidget extends StatelessWidget {
  final List<String> lBox;
  final double sizeHoldSet;

  const MeasureNameBoxWidget(
      {Key? key, required this.lBox, required this.sizeHoldSet})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: colorBlack,
        child: ListView.builder(
            itemCount: lBox.length,
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (c, i) => Container(
                alignment: Alignment.bottomCenter,
                width: sizeHoldSet,
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AppText(lBox[i],
                          style: typoW600.copyWith(
                              fontSize: 2.5.sp,
                          color: colorWhite.withOpacity(0.87))),
                  Container(height: 0.5, width: 0.2, color: colorGrey70)
                ]))));
  }
}
