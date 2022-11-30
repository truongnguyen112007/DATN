import 'dart:async';

import 'package:base_bloc/data/eventbus/refresh_event.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../data/globals.dart';
import '../localization/locale_keys.dart';
import '../theme/app_styles.dart';
import '../theme/colors.dart';
import '../utils/app_utils.dart';
import 'app_text.dart';

class FilterWidget extends StatefulWidget {
  final bool isSelect;
  final VoidCallback sortCallBack;
  final VoidCallback filterCallBack;
  final VoidCallback selectCallBack;
  final bool onClickSelect;
  final VoidCallback unsSelectCallBack;

  const FilterWidget({
    Key? key,
    this.isSelect = false,
    required this.sortCallBack,
    required this.filterCallBack,
    required this.selectCallBack,
    this.onClickSelect = false,
    required this.unsSelectCallBack,
  }) : super(key: key);

  @override
  State<FilterWidget> createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
  bool onClickSelect = false;
  StreamSubscription<RefreshEvent>? _isSelectStream;

  @override
  void initState() {
    _isSelectStream = Utils.eventBus.on<RefreshEvent>().listen((model) {
      if (model.type == RefreshType.FILTER) {
        if (mounted) {
          setState(() {
            onClickSelect = false;
          });
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: colorBlack,
      padding: EdgeInsets.only(
          left: contentPadding, right: contentPadding, top: 5, bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          itemFilterWidget(Icons.swap_vert, LocaleKeys.sort.tr(),
              colorWhite.withOpacity(0.87), () => widget.sortCallBack.call()),
          itemFilterWidget(
              Icons.filter_alt_outlined,
              LocaleKeys.filter.tr(),
              colorWhite.withOpacity(0.87),
              () => widget.filterCallBack.call()),
          itemFilterWidget(
            Icons.filter_alt_outlined,
            onClickSelect ? 'Unselect all' : LocaleKeys.select.tr(),
            Colors.transparent,
            isShow: widget.isSelect,
            () => setState(() {
              // onClickSelect = !onClickSelect;
              if (onClickSelect = !onClickSelect) {
                widget.selectCallBack.call();
              } else {
                widget.unsSelectCallBack.call();
              }
            }),
          ),
        ],
      ),
    );
  }

  Widget itemFilterWidget(
          IconData icon, String title, Color color, VoidCallback callback,
          {bool isShow = false}) =>
      InkWell(
        onTap: () => callback.call(),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isShow ? colorBlack : color,
              size: 20,
            ),
            const SizedBox(
              width: 2,
            ),
            AppText(
              title,
              style: typoW400.copyWith(color: colorText0.withOpacity(0.87)),
            )
          ],
        ),
      );
}
