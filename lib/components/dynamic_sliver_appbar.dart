
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class DynamicSliverAppBar extends StatefulWidget {
  Widget child;
  final double maxHeight;

  DynamicSliverAppBar({
    required this.child,
    required this.maxHeight,
    Key? key,
  }) : super(key: key);

  @override
  _DynamicSliverAppBarState createState() => _DynamicSliverAppBarState();
}

class _DynamicSliverAppBarState extends State<DynamicSliverAppBar> {
  final GlobalKey _childKey = GlobalKey();
  bool isHeightCalculated = false;
  double height = 0.0;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (!isHeightCalculated) {
        isHeightCalculated = true;
        setState(() {
          height = (_childKey.currentContext?.findRenderObject() as RenderBox?)
              ?.size
              ?.height ??
              0.0;
        });
      }
    });

    return SliverAppBar(
        elevation: 0.0,
        toolbarHeight: isHeightCalculated ? height : widget.maxHeight,
        floating: false,
        pinned: false,
        flexibleSpace: FlexibleSpaceBar(
          background: Column(
            children: [
              Container(
                key: _childKey,
                child: widget.child,
              ),
              const Expanded(child: SizedBox.shrink()),
            ],
          ),
        ));
  }
}

class SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => math.max(maxHeight, minHeight);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(
        child: Container(
          color: Colors.black,
          child: child,
        ));
  }

  @override
  bool shouldRebuild(SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}