import 'package:base_bloc/config/constant.dart';
import 'package:base_bloc/data/model/address_model.dart';
import 'package:base_bloc/data/model/places_model.dart';
import 'package:base_bloc/data/model/reservation_model.dart';
import 'package:base_bloc/data/model/routes_model.dart';
import 'package:base_bloc/data/model/user_profile_model.dart';
import 'package:base_bloc/data/model/wall_model.dart';
import 'package:base_bloc/modules/confirm_create_reservation/confirm_create_reservation_page.dart';
import 'package:base_bloc/modules/create_reservation/create_reservation_page.dart';
import 'package:base_bloc/modules/create_reservation_success/create_reservation_success_page.dart';
import 'package:base_bloc/modules/create_routes/create_routes_page.dart';
import 'package:base_bloc/modules/filter_address/filter_address_page.dart';
import 'package:base_bloc/modules/find_place/find_place_page.dart';
import 'package:base_bloc/modules/home/home_page.dart';
import 'package:base_bloc/modules/notifications_page/notifications_page.dart';
import 'package:base_bloc/modules/place_address/place_address.dart';
import 'package:base_bloc/modules/reservation_detail/reservation_detail_page.dart';
import 'package:base_bloc/modules/routes_page/routes_page.dart';
import 'package:base_bloc/modules/splash/splash_page.dart';
import 'package:base_bloc/modules/tab_climb/tab_climb.dart';
import 'package:base_bloc/modules/tab_home/tab_home.dart';
import 'package:base_bloc/modules/tab_profile/edit_settings/edit_settings_state.dart';
import 'package:base_bloc/modules/tab_profile/edit_settings/general_settings/general_settings_page.dart';
import 'package:base_bloc/modules/tab_profile/tab_profile.dart';
import 'package:base_bloc/modules/tab_reservation/tab_reservation.dart';
import 'package:base_bloc/modules/tab_routes/tab_routes.dart';
import 'package:fluro/fluro.dart';

import '../modules/login/login.dart';
import '../modules/login_to_wall/login_to_wall.dart';
import '../modules/search/search_page.dart';

import '../modules/routers_detail/routes_detail_page.dart';
import '../modules/tab_profile/edit_settings/edit_account/edit_account_page.dart';
import '../modules/tab_profile/edit_settings/edit_settings_page.dart';
import '../modules/tab_profile/edit_settings/notifications_settings/notifications_settings_page.dart';
import '../modules/tab_profile/edit_settings/privacy_settings/privacy_settings_page.dart';

var routeRoutesDetail = Handler(
    handlerFunc: (c, p) => RoutesDetailPage(
          index: (c!.settings!.arguments as List)[0] as int,
          model: (c.settings!.arguments as List)[1] as RoutesModel,
        ));
var routeSplash = Handler(handlerFunc: (c, p) => const SplashPage());
var routeHome = Handler(handlerFunc: (c, p) => const HomePage());
var routeTabHome = Handler(handlerFunc: (c, p) => const TabHome());
var routeSearchHome = Handler(
    handlerFunc: (c, p) => SearchPage(index: c!.settings!.arguments as int));
var routeNotifications =
    Handler(handlerFunc: (c, p) => const NotificationsPage());
var routeLogin = Handler(
    handlerFunc: (c, p) => LoginPage(
          index: c!.settings!.arguments as int,
        ));
var routeTabClimb = Handler(handlerFunc: (c, p) => const TabClimb());
var routeTabProfile = Handler(handlerFunc: (c, p) => const TabProfile());
var routeTabReservation =
    Handler(handlerFunc: (c, p) => const TabReservation());
var routeTabRoutes = Handler(handlerFunc: (c, p) => const TabRoutes());
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

var routeEditSetting = Handler(handlerFunc: (c,p) => EditSettingsPage(editSettingCallBack: () {}, routePage: (c!.settings!.arguments as int),));

var routeNotification = Handler(handlerFunc: (c,p) => NotificationsSettingsPage(routePage: (c!.settings!.arguments as int),));

var routePrivacy = Handler(handlerFunc: (c,p) => PrivacySettingsPage(routePage: c!.settings!.arguments as int));

var routeGeneral = Handler(handlerFunc: (c,p) => GeneralSettingsPage(routePage: c!.settings!.arguments as int));

var routerAccount = Handler(handlerFunc: (c,p)=> EditAccountPage(model: (c!.settings!.arguments as List)[0] as UserProfileModel , routePage: (c.settings!.arguments as List)[1] as int,));

var routeLoginToWall = Handler(
    handlerFunc: (c, p) => LoginToWall(
          routePage: (c!.settings!.arguments as List)[0] as int,
          model: (c.settings!.arguments as List)[1] as WallModel,
          currentIndex: (c.settings!.arguments as List)[2] as String,
        ));

var routeFilterAddress =
    Handler(handlerFunc: (c, p) => const FilterAddressPage());
var routeFindPlace = Handler(handlerFunc: (c, p) => const FindPlacePage());
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
var routePlaceDetail = Handler(
    handlerFunc: (c, p) => PlaceAddress(
          index: (c!.settings!.arguments as List)[0] as int,
          model: (c.settings!.arguments as List)[1] as PlacesModel,
        ));
var routeSearchRoute = Handler(
    handlerFunc: (c, p) => RoutesPage(index: c!.settings!.arguments as int));
