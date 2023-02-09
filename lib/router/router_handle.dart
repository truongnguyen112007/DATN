import 'package:base_bloc/config/constant.dart';
import 'package:base_bloc/data/model/address_model.dart';
import 'package:base_bloc/data/model/bill_model.dart';
import 'package:base_bloc/data/model/goods_model.dart';
import 'package:base_bloc/data/model/places_model.dart';
import 'package:base_bloc/data/model/reservation_model.dart';
import 'package:base_bloc/data/model/routes_model.dart';
import 'package:base_bloc/modules/confirm_create_reservation/confirm_create_reservation_page.dart';
import 'package:base_bloc/modules/create_reservation/create_reservation_page.dart';
import 'package:base_bloc/modules/create_reservation_success/create_reservation_success_page.dart';
import 'package:base_bloc/modules/create_routes/create_routes_page.dart';
import 'package:base_bloc/modules/filter_address/filter_address_page.dart';
import 'package:base_bloc/modules/home/home_page.dart';
import 'package:base_bloc/modules/register/register.dart';
import 'package:base_bloc/modules/reservation_detail/reservation_detail_page.dart';
import 'package:base_bloc/modules/routes_page/routes_page.dart';
import 'package:base_bloc/modules/splash/splash_page.dart';
import 'package:fluro/fluro.dart';
import '../modules/add_products/add_products.dart';
import '../modules/bill_detail/bill_detail.dart';
import '../modules/login/login.dart';
import '../modules/products_detail/products_detail.dart';
import '../modules/routers_detail/routes_detail_page.dart';
import '../modules/supplier_page/supplier_page.dart';
import '../modules/tab_goods/tab_goods.dart';
import '../modules/tab_more/tab_more.dart';
import '../modules/tab_notification/tab_notification.dart';
import '../modules/tab_overview/tab_overview.dart';
import '../modules/tab_receipt/tab_receipt.dart';

var routeRoutesDetail = Handler(
    handlerFunc: (c, p) => RoutesDetailPage(
          index: (c!.settings!.arguments as List)[0] as int,
          model: (c.settings!.arguments as List)[1] as RoutesModel,
        ));

var routeLogin = Handler(handlerFunc: (c, p) => const Login());

var routeOtp = Handler(handlerFunc: (c, p) => const Register());

var routeSplash = Handler(handlerFunc: (c, p) => const SplashPage());

var routeHome = Handler(handlerFunc: (c, p) => const HomePage());

var routeTabOverView = Handler(handlerFunc: (c, p) => const TabOverView());

var routeAddProducts = Handler(
    handlerFunc: (c, p) => AddProducts(
          routePage: c!.settings!.arguments as int,
        ));

var routeBillDetail = Handler(
    handlerFunc: (c, p) => BillDetail(
          routePage: (c!.settings!.arguments as List)[0] as int,
          model: (c.settings!.arguments as List)[1] as BillModel,
        ));

var routeProductsDetail = Handler(
    handlerFunc: (c, p) => ProductsDetail(
          routePage: (c!.settings!.arguments as List)[0] as int,
          model: (c.settings!.arguments as List)[1] as ProductModel,
        ));

var routeSupplierPage = Handler(
    handlerFunc: (c, p) => SupplierPage(
          routePage: c!.settings!.arguments as int,
        ));

var routeTabGoods = Handler(handlerFunc: (c, p) => const TabGoods());

var routeTabMore = Handler(handlerFunc: (c, p) => const TabMore());

var routeTabNotification =
    Handler(handlerFunc: (c, p) => const TabNotification());

var routeTabRoutes = Handler(handlerFunc: (c, p) => const TabReceipt());

var routeReservationDetail = Handler(
    handlerFunc: (c, p) => ReservationDetailPage(
          index: (c!.settings!.arguments as List)[0] as int,
          model: (c.settings!.arguments as List)[1] as ReservationModel,
        ));
var routeCreateReservationPage = Handler(
  handlerFunc: (c, p) => CreateReservationPage(
    index: c!.settings!.arguments as int,
  ),
);
var routeFilterAddress =
    Handler(handlerFunc: (c, p) => const FilterAddressPage());
var routeConfirmCreateReservation = Handler(
    handlerFunc: (c, p) => ConfirmCreateReservationPage(
          addressModel: (c!.settings!.arguments as List)[0] as AddressModel,
          placesModel: (c.settings!.arguments as List)[1] as PlacesModel,
          dateTime: (c.settings!.arguments as List)[2] as DateTime,
        ));
var routeCreateReservationSuccess =
    Handler(handlerFunc: (c, p) => const CreateReservationSuccessPage());
var routeCreateRoutes =
    Handler(handlerFunc: (c, p) => const CreateRoutesPage());

var routeSearchRoute = Handler(
    handlerFunc: (c, p) => RoutesPage(index: c!.settings!.arguments as int));
