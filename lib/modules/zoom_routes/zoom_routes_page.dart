import 'dart:async';

import 'package:base_bloc/components/app_scalford.dart';
import 'package:base_bloc/components/measure_name_widget.dart';
import 'package:base_bloc/components/zoomer.dart';
import 'package:base_bloc/data/model/routes_model.dart';
import 'package:base_bloc/modules/zoom_routes/zoom_routes_cubit.dart';
import 'package:base_bloc/modules/zoom_routes/zoom_routes_state.dart';
import 'package:base_bloc/utils/log_utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../base/hex_color.dart';
import '../../components/app_button.dart';
import '../../components/app_circle_loading.dart';
import '../../components/app_text.dart';
import '../../components/appbar_widget.dart';
import '../../components/measure_widget.dart';
import '../../data/eventbus/hold_set_event.dart';
import '../../data/globals.dart' as globals;
import '../../data/model/hold_set_model.dart';
import '../../data/model/info_route_model.dart';
import '../../gen/assets.gen.dart';
import '../../localization/locale_keys.dart';
import '../../router/router_utils.dart';
import '../../theme/app_styles.dart';
import '../../theme/colors.dart';
import '../../utils/app_utils.dart';
import '../persons_page/persons_page_state.dart';

class ZoomRoutesPage extends StatefulWidget {
  final int heightOfRoute;
  final int row;
  final int column;
  final double sizeHoldSet;
  final List<HoldSetModel> lRoutes;
  final int currentIndex;
  final double heightOffScreen;
  final bool isEdit;
  final RoutesModel? model;
  final InfoRouteModel? infoRouteModel;

  const ZoomRoutesPage(
      {Key? key,
      this.infoRouteModel,
      required this.heightOfRoute,
      required this.currentIndex,
      this.isEdit = false,
      this.model,
      required this.row,
      required this.lRoutes,
      required this.column,
      required this.sizeHoldSet,
      required this.heightOffScreen})
      : super(key: key);

  @override
  State<ZoomRoutesPage> createState() => _ZoomRoutesPageState();
}

class _ZoomRoutesPageState extends State<ZoomRoutesPage> {
  late ZoomRoutesCubit _bloc;
  late ZoomerController _zoomController;
  late ZoomerController _zoomMeasureNameController;
  late ZoomerController _zoomMeasureController;
  late MeasureNameBoxController _measureNameBoxController;
  late MeasureHeightController _measureHeightController;
  var _scale =4.0;
  late double sizeHoldSet;
  late int row;
  late int column;
  Offset? offset;
  StreamSubscription<HoldSetEvent>? _holdSetStream;
  late ScrollController _lBoxController;
  var dxMeasureHeight =-10.5;
  var dyMeasureBoxName =-9.0;

  @override
  void initState() {
    logE("TAG SIZE HOLDSET: ${widget.sizeHoldSet}");
    logE("TAG HEIGHT OF ROUTE: ${widget.heightOfRoute}");
    _bloc = ZoomRoutesCubit();
    _zoomController = ZoomerController(initialScale: 4.0);
    _zoomMeasureNameController = ZoomerController(initialScale: 4.0);
    _zoomMeasureController = ZoomerController(initialScale: 4.0);
    _measureNameBoxController = MeasureNameBoxController();
    _measureHeightController = MeasureHeightController();
    sizeHoldSet = widget.sizeHoldSet;
    row = widget.row;
    column = widget.column;
    _zoomController.onZoomUpdate(() {
      _zoomMeasureController.setOffset =
          Offset(dxMeasureHeight, _zoomController.offset.dy);
      _zoomMeasureNameController.setOffset =
          Offset(_zoomController.offset.dx, dyMeasureBoxName);
    });
      super.initState();
  }

  void setScale(double scale) {
    _scale = scale;
    _zoomController.setScale = scale;
    _zoomController.setOffset = const Offset(0.0, 0.0);
    _zoomMeasureNameController.setOffset = const Offset(0, -9);
    _measureNameBoxController.setScale = scale;
    _measureHeightController.setScale = scale;
    _zoomMeasureController.setScale = scale;
      _zoomMeasureNameController.setScale = scale;
    dxMeasureHeight =
        scale == 1.0 ? -10 : (scale == 2 ? -8 : (scale == 3 ? -9 : -10.5));
    _zoomMeasureController.setOffset = Offset(dxMeasureHeight, 0);
  }

  @override
  void dispose() {
    _holdSetStream?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
