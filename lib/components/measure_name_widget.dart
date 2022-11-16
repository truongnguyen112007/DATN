import 'package:base_bloc/utils/log_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_styles.dart';
import '../theme/colors.dart';
import 'app_text.dart';

class MeasureNameBoxController {
  void Function(double value)? _getScale;

  MeasureNameBoxController();

  set setScale(double value) {
    _getScale!(value);
  }
}

class MeasureNameBoxWidget extends StatefulWidget {
  final List<String> lBox;
  final double sizeHoldSet;
  final MeasureNameBoxController controller;

  const MeasureNameBoxWidget(
      {Key? key,
      required this.lBox,
      required this.sizeHoldSet,
      required this.controller})
      : super(key: key);

  @override
  State<MeasureNameBoxWidget> createState() => _MeasureNameBoxWidgetState();
}

class _MeasureNameBoxWidgetState extends State<MeasureNameBoxWidget> {
  var fontText = 2.5.sp;

  @override
  void initState() {
    widget.controller._getScale = (value) {
      var scale = value.toInt();
      setState(() => fontText = (scale == 4)
          ? 2.5.sp
          : (scale == 3 ? 2.5.sp : (scale == 2 ? 4.sp : 5.sp)));
    };
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: colorBlack,
        child: ListView.builder(
            itemCount: widget.lBox.length,
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (c, i) => Container(
                alignment: Alignment.bottomCenter,
                width: widget.sizeHoldSet,
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AppText(widget.lBox[i],
                          style: typoW600.copyWith(
                              fontSize: fontText /* 2.5.sp*/,
                              color: colorWhite.withOpacity(0.87))),
                      Container(height: 0.5, width: 0.2, color: colorGrey70)
                    ]))));
  }
}
