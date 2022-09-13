import 'package:base_bloc/router/router_handle.dart';
import 'package:base_bloc/utils/log_utils.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';

class Routers {
  static String root = "/";
  static String home = "/home";

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

class MainRouters {
  static String root = '/';
  static String test = "/test";
  static String test2 = "/test2";

  static configureMainRoutes(FluroRouter router) {
    router.notFoundHandler = Handler(handlerFunc: (c, p) {
      logE("ROUTE WAS NOT FOUND !!!");
    });
    // router.define(root, handler: routeTabMain);
  }
}

class SecondRouters {
  static String root = '/';
  static String test = "/test";
  static String test2 = "/test2";

  static configureSecondRouters(FluroRouter router) {
    router.notFoundHandler = Handler(handlerFunc: (c, p) {
      logE("ROUTE WAS NOT FOUND !!!");
    });
    // router.define(root, handler: routeTabSecond);
  }
}
