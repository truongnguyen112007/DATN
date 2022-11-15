import 'dart:async';
import 'dart:math';

import 'package:base_bloc/utils/log_utils.dart';
import 'package:flutter/material.dart';

class ZoomerController {
  double? _initScale;
  void Function(double value)? _setZoomerScale, _setZoomerAngle;
  double Function()? _getZoomerScale, _getZoomerAngle;
  void Function(Offset value)? _setZoomerOffset;
  Offset Function()? _getZoomerOffset;
  Function? _onZoomStart, _onZoomUpdate, _onZoomEnd;

  ///ZoomerController To Control Zoomer Widget
  ZoomerController({initialScale = 1.0}) {
    _initScale = initialScale;
  }

  void onZoomStart(Function zoom) {
    _onZoomStart = zoom;
  }

  void onZoomUpdate(Function zoom) {
    _onZoomUpdate = zoom;
  }

  void onZoomEnd(Function zoom) {
    _onZoomEnd = zoom;
  }

  double get scale {
    if (_getZoomerScale == null) {
      throw Exception("ZoomerController Not Attached To Any Zoomer");
    }
    return _getZoomerScale!();
  }

  set setScale(double value) {
    if (_getZoomerScale == null) {
      throw Exception("ZoomerController Not Attached To Any Zoomer");
    }
    _setZoomerScale!(value);
  }

  Offset get offset {
    if (_getZoomerScale == null) {
      throw Exception("ZoomerController Not Attached To Any Zoomer");
    }
    return _getZoomerOffset!();
  }

  set setOffset(Offset value) {
    if (_getZoomerScale == null) {
      throw Exception("ZoomerController Not Attached To Any Zoomer");
    }
    _setZoomerOffset!(value);
  }

  double get rotation {
    if (_getZoomerScale == null) {
      throw Exception("ZoomerController Not Attached To Any Zoomer");
    }
    return _getZoomerAngle!();
  }

  set setRotation(double value) {
    if (_getZoomerScale == null) {
      throw Exception("ZoomerController Not Attached To Any Zoomer");
    }
    _setZoomerAngle!(value);
  }
}

class Zoomer extends StatefulWidget {
  ///Zoomer widget to create interactive Zoomable widget
  final Offset? offset;
  final Widget child;
  final double height, width, minScale, maxScale;
  final BoxDecoration background;
  final bool enableRotation;
  final bool isLimitOffset;
  final bool clipRotation;
  final bool enableTranslation;
  final ZoomerController controller;
  final Function(double)? scaleCallBack;
  final bool isRoute;

  Zoomer(
      {required this.child,
      this.scaleCallBack,
      this.offset,
      this.isLimitOffset = false,
      required this.controller,
      required this.height,
      required this.width,
      required this.background,
      this.maxScale = 2.0,
      this.minScale = 0.5,
      this.enableTranslation = false,
      this.enableRotation = false,
      this.isRoute = false,
      this.clipRotation = true});

  @override
  _ZoomerState createState() => _ZoomerState();
}

class _ZoomerState extends State<Zoomer> {
  double _scale = -1.0;
  Offset _offset = Offset(0.0, 0.0);
  double _startScale = 1.0;
  late Offset _lastOffset;
  late Offset _startOffset;
  late Offset _limitOffset;
  double _angle = 0.0;
  double _startAngle = 0.0;

  double get getScale => -_scale;

  set setScale(double value) => setState(() {
        _scale = -value;
      });

  Offset get getOffset => _offset;

  set setOffset(Offset value) => setState(() {
        _offset = value;
      });

  double get getRotation => _angle;

  set setRotation(double value) => setState(() {
        _angle = value;
      });

  @override
  void initState() {
    _offset = widget.offset! ;/*?? const Offset(0.0, 0.0);*/
    double l = (1 + _scale);
    l = l < 0 ? (-_scale - 1) / 4 : l;
    _limitOffset = Offset(widget.width, widget.height) * l;
    if (widget.controller != null) {
      _scale = -widget.controller._initScale!;
      widget.controller._getZoomerScale = () => getScale;
      widget.controller._getZoomerAngle = () => getRotation;
      widget.controller._getZoomerOffset = () => getOffset;
      widget.controller._setZoomerScale = (value) {
        setScale = value;
      };
      widget.controller._setZoomerAngle = (value) {
        setRotation = value;
      };
      widget.controller._setZoomerOffset = (value) {
        setOffset = value;
      };
    }
    if (widget.isRoute) {
      _scaleEnd(ScaleEndDetails(
          velocity: const Velocity(pixelsPerSecond: Offset(0.0, 0.0)),
          pointerCount: 0));
    }
    super.initState();
  }

  void _scaleStart(ScaleStartDetails details) {
    if (widget.controller != null) {
      if (widget.controller._onZoomStart != null) {
        widget.controller._onZoomStart!();
      }
    }

    _lastOffset = details.focalPoint;
    _startScale = -_scale;
    _startOffset = _offset;
    _startAngle = _angle;
  }

  void _scaleEnd(ScaleEndDetails details) {
    if (widget.enableTranslation) {
      double l = (1 + _scale);
      l = l < 0 ? (-_scale - 1) / 4 : l;
      _limitOffset = Offset(widget.width, widget.height) * l;
    }

    if (widget.enableRotation) {
      if (widget.clipRotation) {
        double x = ((_angle % (2 * pi)) / (pi / 2));
        double angle =
            ((x - x.floor()) > 0.5 ? (x.floor() + 1) : x.floor()) * (pi / 2);
        setState(() {
          _angle = angle;
        });
      }
    }

    if (widget.controller != null) {
      if (widget.controller._onZoomEnd != null) {
        widget.controller._onZoomEnd!();
      }
    }
  }

  void _scaleUpdate(ScaleUpdateDetails details) async {
    double scale =
        (_startScale * details.scale).clamp(widget.minScale, widget.maxScale);
    Offset offset = details.focalPoint -
        ((_lastOffset - _startOffset) / _startScale) * scale;
    double angle = _startAngle + details.rotation;
    setState(() {
      _scale = -scale;
      if (widget.scaleCallBack != null) widget.scaleCallBack!(scale);
      if (widget.enableRotation) {
        _angle = angle;
      }

      if (details.scale == 1.0 && widget.enableTranslation) {
        //Todo set limit _offset to wrap content screen.
        if (widget.isLimitOffset) {
          _offset = Offset(
              offset.dx.clamp(
                  -_limitOffset.dx / (widget.height >= 800 ? 14 : 17),
                  _limitOffset.dx / (widget.height >= 800 ? 14 : 17)),
              offset.dy.clamp(-_limitOffset.dy / 3.77, _limitOffset.dy / 3.77));
        } else {
          _offset = Offset(offset.dx.clamp(-_limitOffset.dx, _limitOffset.dx),
              offset.dy.clamp(-_limitOffset.dy, _limitOffset.dy));
        }
      }
    });

    if (widget.controller != null) {
      if (widget.controller._onZoomUpdate != null) {
        widget.controller._onZoomUpdate!();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onScaleStart: _scaleStart,
      onScaleUpdate: _scaleUpdate,
      onScaleEnd: _scaleEnd,
        child: ClipRect(
            child: Container(
          decoration: widget.background,
          height: widget.height,
          width: widget.width,
          child: Transform(
              transform: Matrix4.identity()
                ..scale(-_scale, -_scale)
                ..translate(_offset.dx, _offset.dy)
                ..rotateZ(_angle),
              alignment: FractionalOffset.center,
              child: widget.child),
        )));
  }
}
