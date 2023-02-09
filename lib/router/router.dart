import 'package:base_bloc/router/router_handle.dart';
import 'package:base_bloc/utils/log_utils.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';

class Routers {
  static String root = "/";
  static String home = "/home";
  static String login = "/login";
  static String otp = "/otp";

  static void configureRoutes(FluroRouter router) {
    router.notFoundHandler = Handler(handlerFunc:
        (BuildContext? context, Map<String, List<String>>? params) {
      logE("ROUTE WAS NOT FOUND !!!");
    });
    router.define(root, handler: routeSplash);
    router.define(home, handler: routeHome);
    router.define(login, handler: routeLogin);
    router.define(otp, handler: routeOtp);
  }
}

class OverViewRouters {
  static String root = '/';
  static String login = '/login';
  static String search = '/search_home';
  static String reservation = '/reservation';
  static String notifications = '/notifications';
  static String placeDetail = '/placeDetail';
  static String routesCreateReservationPage = '/createReservationPage';

  static configureMainRoutes(FluroRouter router) {
    router.notFoundHandler = Handler(handlerFunc: (c, p) {
      logE("ROUTE WAS NOT FOUND !!!");
    });
    router.define(root, handler: routeTabOverView);
    router.define(reservation, handler: routeReservationDetail);
    router.define(routesCreateReservationPage,
        handler: routeCreateReservationPage);
  }
}

class ReceiptRouters {
  static String root = '/';
  static String search = '/search';
  static String login = '/login';
  static String placeDetail = '/placeDetail';
  static String notifications = '/notifications';
  static String routesDetail = '/routesDetail';
  static String createRoutes = '/createRoutes';
  static String routesCreateReservationPage = '/createReservationPage';
  static String routesBillDetail = "/routeBillDetail";

  static configureRouter(FluroRouter router) {
    router.notFoundHandler = Handler(handlerFunc: (c, x) {
      logE("ROUTE WAS NOT FOUND !!!");
    });
    router.define(root, handler: routeTabRoutes);
    router.define(routesDetail, handler: routeRoutesDetail);
    router.define(createRoutes, handler: routeCreateRoutes);
    router.define(routesCreateReservationPage,
        handler: routeCreateReservationPage);
    router.define(routesBillDetail, handler: routeBillDetail);
  }
}

class GoodsRouters {
  static String root = '/';
  static String login = '/login';
  static String search = '/search';
  static String notifications = '/notifications';
  static String placeDetail = '/placeDetail';
  static String routesCreateReservationPage = '/createReservationPage';
  static String routesProductsDetail = "/routesProductsDetail";
  static String routesAddProducts = 'routesAddProducts';

  static configureRouter(FluroRouter router) {
    router.notFoundHandler = Handler(handlerFunc: (c, x) {
      logE("ROUTE WAS NOT FOUND !!!");
    });
    router.define(root, handler: routeTabGoods);
    router.define(routesCreateReservationPage,
        handler: routeCreateReservationPage);
    router.define(routesProductsDetail, handler: routeProductsDetail);
    router.define(routesAddProducts, handler: routeAddProducts);
  }
}

class NotificationRouters {
  static String root = '/';
  static String login = '/login';
  static String search = '/search';
  static String notifications = '/notifications';
  static String placeDetail = '/placeDetail';
  static String routesReservationDetail = '/reservationDetail';
  static String routesCreateReservationPage = '/createReservationPage';
  static String routesFilterAddress = '/routesFilterCity';
  static String routesFindPlace = '/routeFindPlace';
  static String routesConfirmCreateReservation =
      '/routesConfirmCreateReservation';
  static String routesCreateReservationSuccess =
      'routesCreateReservationSuccess';

  static configureRouter(FluroRouter router) {
    router.notFoundHandler = Handler(handlerFunc: (c, x) {
      logE("ROUTE WAS NOT FOUND !!!");
    });
    router.define(root, handler: routeTabNotification);
    router.define(routesReservationDetail, handler: routeReservationDetail);
    router.define(routesCreateReservationPage,
        handler: routeCreateReservationPage);
    router.define(routesFilterAddress, handler: routeFilterAddress);
    router.define(routesConfirmCreateReservation,
        handler: routeConfirmCreateReservation);
    router.define(routesCreateReservationSuccess,
        handler: routeCreateReservationSuccess);
  }
}

class ProfileRouters {
  static String root = '/';
  static String login = '/login';
  static String search = '/search';
  static String notifications = '/notifications';
  static String placeDetail = '/placeDetail';
  static String routesCreateReservationPage = '/createReservationPage';
  static String routesSupplierPage = 'routesSupplierPage';

  static configureProfileRouter(FluroRouter router) {
    router.notFoundHandler = Handler(handlerFunc: (c, x) {
      logE('ROUTE WAS NOT FOUND !!!');
    });
    router.define(root, handler: routeTabMore);
    router.define(routesCreateReservationPage,
        handler: routeCreateReservationPage);
    router.define(routesSupplierPage, handler: routeSupplierPage);
  }
}
