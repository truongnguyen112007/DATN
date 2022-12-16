import 'package:base_bloc/config/constant.dart';
import 'package:base_bloc/data/repository/base_service.dart';
import 'package:base_bloc/modules/favourite/favourite_state.dart';

import '../../modules/routes_page/routes_page_state.dart';
import '../../utils/log_utils.dart';
import '../globals.dart' as globals;
import 'api_result.dart';

class UserRepository extends BaseService {
  static UserRepository instance = UserRepository._init();

  factory UserRepository() {
    return instance;
  }

  UserRepository._init() {
    initProvider();
  }

  Future<ApiResult> login(String email, String pass) async =>
      await POST('auth/login', {
        ApiKey.email: email,
        ApiKey.password: pass,
        ApiKey.device_id: globals.deviceId,
        ApiKey.device_name: globals.deviceName,
        ApiKey.device_model: globals.deviceModel,
      });

  Future<ApiResult> createPlaylist(String name, int userId) async =>
      await POST('playlist', {ApiKey.name: '', ApiKey.user_id: userId});

  Future<ApiResult> getPlaylists() async =>
      await GET('playlist?start=1&count=${ApiKey.limit_offset}');

  Future<ApiResult> getPlaylistById(String id, {int nextPage = 0}) async =>
      await GET('playlist/$id?start=$nextPage&count=${ApiKey.limit_offset}');

  Future<ApiResult> getRoute({int nextPage = 0}) async =>
      await GET('route?start=$nextPage&count=${ApiKey.limit_offset}');

  Future<ApiResult> deleteRoute(String routeId) async =>
      await DELETE('route/$routeId');

  Future<ApiResult> addToPlaylist(
      String playlistId, List<String> lRoute) async =>
      await POST('playlistdetail/$playlistId', {ApiKey.route_ids: lRoute});

  Future<ApiResult> removeFromPlaylist(
      String playlistId, String routeId) async =>
      await DELETE('playlistdetail/$playlistId?ids=$routeId');

  Future<ApiResult> moveToTop(String playlistId, String routeId) async =>
      await PUT('playlistdetail/$playlistId', body: {ApiKey.route_id: routeId});

  Future<ApiResult> getFavorite(
      {FavType? type,
        int? userId,
        int? nextPage,
        int? orderType,
        int? orderValue,
        double? authorGradeFrom,
        double? authorGradeTo,
        double? userGradeFrom,
        double? userGardeTo,
        String? hasConner,
        int? status,
        String? setter}) async {
    {
      logE(type.toString());
      switch (type) {
        case FavType.Sort:
          return (orderType == null && orderValue == null)
              ? await GET(
              "favourite?start=$nextPage&count=${ApiKey.limit_offset}")
              : await GET(
              "favourite?start=$nextPage&count=${ApiKey.limit_offset}&order_type=$orderType&order_value=$orderValue");
        case FavType.Filter:
          return await GET(
              "favourite?start=$nextPage&count=${ApiKey.limit_offset}&author_grade_from=${authorGradeFrom?.toInt()}&author_grade_to=${authorGradeTo?.toInt()}&user_grade_from=${userGradeFrom?.toInt()}&user_grade_to=${userGardeTo?.toInt()}${status != null ? "&status=$status" : ""}${hasConner != null ? "&has_conner=$hasConner" : ""}${setter != null ? "&setter=$setter" : ""}");
        default:
          return await GET(
              "favourite?start=$nextPage&count=${ApiKey.limit_offset}");
      }
    }
  }

  Future<ApiResult> removeFromFavorite(String routeIds) async => await DELETE(
    'favourite?ids=$routeIds', /*body: {ApiKey.route_ids: routeId}*/
  );

  Future<ApiResult> addToFavorite(int userId, List<String> routeIds) async =>
      await POST('favourite', {ApiKey.route_ids: routeIds});

  Future<ApiResult> createRoute(
      {required String name,
        int height = 12,
        required List<int> lHold,
        required bool hasCorner,
        required int authorGrade,
        bool published = true,
        int visibility = 0}) async =>
      await POST('route',{
        ApiKey.name: name,
        ApiKey.height: height,
        ApiKey.holds: lHold,
        ApiKey.has_conner: hasCorner,
        ApiKey.author_grade: authorGrade,
        ApiKey.published: published,
        ApiKey.visibility: visibility
      });

  Future<ApiResult> editRoute(
      {required String routeId,
        required String name,
        int height = 12,
        required List<int> lHold,
        required bool hasCorner,
        required int authorGrade,
        bool published = true,
        int visibility = 0}) async =>
      await PUT('route/$routeId', body: {
        ApiKey.name: name,
        ApiKey.height: height,
        ApiKey.holds: lHold,
        ApiKey.has_conner: hasCorner,
        ApiKey.author_grade: authorGrade,
        ApiKey.published: published,
        ApiKey.visibility: visibility
      });

  Future<ApiResult> searchRoute(
      {String? value,
        int? nextPage,
        SearchRouteType? type,
        int? orderType,
        int? orderValue,
        double? authorGradeFrom,
        double? authorGradeTo,
        double? userGradeFrom,
        double? userGardeTo,
        String? hasConner,
        int? status,
        String? setter}) async {
    switch (type) {
      case SearchRouteType.Sort:
        return (orderType == null && orderValue == null)
            ? await POST(
            "search/service/search?from=0&size=${ApiKey.limit_offset}&q=$value",
            null,isXSub: true)
            : await POST(
            "search/service/search?from=0&size=${ApiKey.limit_offset}&order_type=$orderType&order_value=$orderValue&q=$value",
            null,isXSub: true);
      case SearchRouteType.Filter:
        return await POST(
            "search/service/search?from=0&size=${ApiKey.limit_offset}${value != null ? "&q=$value" : "" }&author_grade_from=${authorGradeFrom?.toInt()}&author_grade_to=${authorGradeTo?.toInt()}&user_grade_from=${userGradeFrom?.toInt()}&user_grade_to=${userGardeTo?.toInt()}${status != null ? "&status=$status" : ""}${hasConner != null ? "&has_conner=$hasConner" : ""}${setter != null ? "&setter=$setter" : ""}",
            null,isXSub: true);
      default:
        return await POST(
            "search/service/search?from=0&size=${ApiKey.limit_offset}&q=$value",
            null,isXSub: true);
    }
  }
}
