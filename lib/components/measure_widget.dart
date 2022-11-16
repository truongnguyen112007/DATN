import 'package:base_bloc/theme/colors.dart';
import 'package:base_bloc/utils/log_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_styles.dart';
import 'app_text.dart';

class MeasureHeightController {
  void Function(double value)? _getScale;

  MeasureHeightController();

  set setScale(double value) {
    _getScale!(value);
  }
}

// class MeasureNameBoxController extends StatelessWidget {
class MeasureHeightWidget extends StatefulWidget {
  final int row;
  final double sizeHoldSet;
  double scale;
  int dy;
  final MeasureHeightController controller;

  MeasureHeightWidget(
      {Key? key,
      required this.row,
      required this.sizeHoldSet,
      required this.scale,
      this.dy = 1,
      required this.controller})
      : super(key: key);

  @override
  State<MeasureHeightWidget> createState() => _MeasureHeightWidgetState();
}

class _MeasureHeightWidgetState extends State<MeasureHeightWidget> {
  double fontText = 2.0.sp;
  double heightLine = 0.1;
  double widthLine = 0.5;

  @override
  void initState() {
    widget.controller._getScale = (value) {
      var scale = value.toInt();
      widthLine = scale == 4
          ? 0.5
          : (scale == 3
          ? 0.6
          : scale == 2
          ? 0.7
          : 0.8);
      heightLine = scale == 4
          ? 0.2
          : (scale == 3
              ? 0.3
              : scale == 2
                  ? 0.3
                  : 0.3);
      fontText = scale == 4
          ? 2.0.sp
          : (scale == 3
              ? 2.5.sp
              : scale == 2
                  ? 4.sp
                  : 5.sp);
      setState(() {});
    };
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        reverse: true,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: widget.row,
        itemBuilder: (BuildContext context, int index) => Container(
            height: widget.sizeHoldSet,
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppText(
                    (index + 1).toString().length == 1
                        ? '  ${(index + 1)}'
                        : '${index + 1}',
                    style: typoW600.copyWith(
                        backgroundColor: colorBlack,
                        fontSize: fontText,
                        color: colorText0.withOpacity(0.8))),
                Container(
                    width: widthLine, color: colorGrey70, height: heightLine)
              ],
            )));
  }
}
