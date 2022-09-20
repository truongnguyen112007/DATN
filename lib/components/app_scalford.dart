import 'package:flutter/material.dart';

import '../theme/colors.dart';
import '../utils/app_utils.dart';

class AppScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appbar;
  final Color? backgroundColor;
  final EdgeInsets padding;
  final Widget? bottomNavigationBar;
  final bool fullStatusBar;
  final bool? resizeToAvoidBottomInset;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final bool isTabToHideKeyBoard;

  const AppScaffold(
      {Key? key,
        required this.body,
        this.appbar,
        this.backgroundColor,
        this.padding = const EdgeInsets.only(left: 0, right: 0),
        this.bottomNavigationBar,
        this.fullStatusBar = false,
        this.floatingActionButton,
        this.floatingActionButtonLocation,
        this.resizeToAvoidBottomInset = true,
        this.isTabToHideKeyBoard = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isTabToHideKeyBoard) {
      return MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
        child: Scaffold(
          backgroundColor: backgroundColor ?? colorBackgroundColor,
          resizeToAvoidBottomInset: resizeToAvoidBottomInset ?? true,
          appBar: appbar,
          floatingActionButton: floatingActionButton,
          floatingActionButtonLocation: floatingActionButtonLocation,
          body: GestureDetector(child: fullStatusBar
              ? body
              : SafeArea(
            minimum: padding,
            child: body,
          ),  onTap: () => Utils.hideKeyboard(context),),
          bottomNavigationBar: bottomNavigationBar,
        ),
      );
    }
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
      child: Scaffold(
        backgroundColor: backgroundColor ?? colorBackgroundColor,
        resizeToAvoidBottomInset: resizeToAvoidBottomInset ?? true,
        appBar: appbar,
        floatingActionButton: floatingActionButton,
        floatingActionButtonLocation: floatingActionButtonLocation,
        body: fullStatusBar
            ? body
            : SafeArea(
          minimum: padding,
          child: body,
        ),
        bottomNavigationBar: bottomNavigationBar,
      ),
    );
  }
}
