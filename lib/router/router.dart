import 'dart:math';

import 'package:base_bloc/router/router_handle.dart';
import 'package:base_bloc/utils/log_utils.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';

class Routers {
  static String root = "/";
  static String home = "/home";
  static String video = '/video';

  static void configureRoutes(FluroRouter router) {
    router.notFoundHandler = Handler(handlerFunc:
        (BuildContext? context, Map<String, List<String>>? params) {
      logE("ROUTE WAS NOT FOUND !!!");
    });
    router.define(root, handler: routeSplash);
    router.define(home, handler: routeHome);
    // router.define(test, handler: routeTest);
  }
}

class HomeRouters {
  static String root = '/';

  static configureMainRoutes(FluroRouter router) {
    router.notFoundHandler = Handler(handlerFunc: (c, p) {
      logE("ROUTE WAS NOT FOUND !!!");
    });
    router.define(root, handler: routeTabHome);
  }
}

class RoutesRouters {
  static String root = '/';
  static String routesDetail = '/routesDetail';

  static configureRouter(FluroRouter router) {
    router.notFoundHandler = Handler(handlerFunc: (c, x) {
      logE("ROUTE WAS NOT FOUND !!!");
    });
    router.define(root, handler: routeTabRoutes);
    router.define(routesDetail, handler: routeRoutesDetail);
  }
}

class ClimbRouters {
  static String root = '/';

  static configureRouter(FluroRouter router) {
    router.notFoundHandler = Handler(handlerFunc: (c, x) {
      logE("ROUTE WAS NOT FOUND !!!");
    });
    router.define(root, handler: routeTabClimb);
  }
}

class ReservationRouters {
  static String root = '/';

  static configureRouter(FluroRouter router) {
    router.notFoundHandler = Handler(handlerFunc: (c, x) {
      logE("ROUTE WAS NOT FOUND !!!");
    });
    router.define(root, handler: routeTabReservation);
  }
}

class ProfileRouters {
  static String root = '/';

  static configureProfileRouter(FluroRouter router) {
    router.notFoundHandler = Handler(handlerFunc: (c, x) {
      logE('ROUTE WAS NOT FOUND !!!');
    });
    router.define(root, handler: routeTabProfile);
  }
}
