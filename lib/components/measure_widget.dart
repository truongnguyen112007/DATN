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

class MeasureWidget extends StatefulWidget {
  // final ScrollController controller;
  final int row;
  final double sizeHoldSet;
  double scale;
  int dy;

  MeasureWidget(
      {Key? key,
      required this.row,
      // required this.controller,
      required this.sizeHoldSet,
      required this.scale,
      this.dy = 1})
      : super(key: key);

  @override
  State<MeasureWidget> createState() => _MeaSureWidgetState();
}

class _MeaSureWidgetState extends State<MeasureWidget> {
  StreamSubscription<ScaleEvent>? _scaleStream;
  double scale = 1;
  double sizePadding = 0.0;

  @override
  void initState() {
    scale = widget.scale;
    _scaleStream =
        Utils.eventBus.on<ScaleEvent>().listen((event) => setState(() {
              scale = event.scale;
              // logE("TAG SCALE: $scale FONT SIZE: ${6.sp / scale})}");
            }));
    super.initState();
  }

  @override
  void dispose() {
    _scaleStream?.cancel();
    super.dispose();
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
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppText(' ${index + 1}',
                    style: typoW600.copyWith(
                        fontSize: 8.sp,
                        color: (index == 3 || index % 3 == 0)
                            ? colorText0.withOpacity(0.8)
                            : Colors.transparent)),
                Container(
                  margin: const EdgeInsets.only(left: 3),
                  width: 3,
                  height: 1,
                  color: HexColor('5E5E5E'),
                )
              ],
            )));
  }
}
