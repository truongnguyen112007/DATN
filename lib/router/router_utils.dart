import 'package:base_bloc/utils/app_utils.dart';
import 'package:base_bloc/utils/log_utils.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../data/eventbus/new_page_event.dart';
import 'application.dart';

class RouterUtils {
  static push<T>(
      {required BuildContext context,
      required String route,
      dynamic argument,
      bool isRemove = false}) async {
    T result = await Application.router.navigateTo(context, route,
        transition: TransitionType.inFromRight,
        clearStack: isRemove,
        routeSettings: RouteSettings(arguments: argument));
    return result;
  }

  static pushHome<T>(
      {required BuildContext context,
      required String route,
      dynamic argument,
      bool isRemove = false}) async {
    T result = await Application.homeRouter.navigateTo(context, route,
        transition: TransitionType.inFromRight,
        clearStack: isRemove,
        routeSettings: RouteSettings(arguments: argument));
    return result;
  }

  static pushRoutes<T>(
      {required BuildContext context,
      required String route,
      dynamic argument,
      bool isRemove = false}) async {
    T result = await Application.routesRouter.navigateTo(context, route,
        transition: TransitionType.inFromRight,
        clearStack: isRemove,
        routeSettings: RouteSettings(arguments: argument));
    return result;
  }

  static pushClimb<T>(
      {required BuildContext context,
      required String route,
      dynamic argument,
      bool isRemove = false}) async {
    T result = await Application.climbRouter.navigateTo(context, route,
        transition: TransitionType.inFromRight,
        clearStack: isRemove,
        routeSettings: RouteSettings(arguments: argument));
    return result;
  }

  static pushReservations<T>(
      {required BuildContext context,
      required String route,
      dynamic argument,
      bool isRemove = false}) async {
    T result = await Application.reservationsRouter.navigateTo(context, route,
        transition: TransitionType.inFromRight,
        clearStack: isRemove,
        routeSettings: RouteSettings(arguments: argument));
    return result;
  }

  static pushProfile<T>(
      {required BuildContext context,
      required String route,
      dynamic argument,
      bool isRemove = false}) async {
    T result = await Application.profileRouter.navigateTo(context, route,
        transition: TransitionType.inFromRight,
        clearStack: isRemove,
        routeSettings: RouteSettings(arguments: argument));
    return result;
  }

  static void pop(BuildContext context,
          {dynamic result, bool isHideBottomBar = false}) =>
      Navigator.pop(context, result);

  static dynamic openNewPage(Widget newPage, BuildContext? context,
      {NewPageType? type, bool isReplace = false}) async {
    Utils.fireEvent(NewPageEvent(newPage, type: type, isReplace: isReplace));
  }

  static Future<dynamic> pushTo(BuildContext context, Widget newPage,
      {bool isReplace = false}) async {
    if (isReplace) {
      return await Navigator.of(context).pushAndRemoveUntil<void>(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => newPage,
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.ease;
              var tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            },
          ),
          (Route<dynamic> route) => false);
    }
    return await Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => newPage,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.ease;
          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }
}
