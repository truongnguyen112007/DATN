import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';

import 'application.dart';

class RouterUtils {
  static push<T>(
      {required BuildContext context,
      required String route,
      dynamic argument,
      bool isRemove = false}) async {
    T result = await Application.router.navigateTo(context, route,
        transition: TransitionType.inFromBottom,
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
}
