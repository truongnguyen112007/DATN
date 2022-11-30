import 'package:base_bloc/config/constant.dart';
import 'package:base_bloc/data/repository/base_service.dart';

import '../globals.dart' as globals;
import 'api_result.dart';

class UserRepository extends BaseService{
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

  Future<ApiResult> addToPlaylist(String playlistId,List<String> lRoute) async =>
      await POST('playlistdetail/$playlistId',{
        ApiKey.route_ids : lRoute
      });

  Future<ApiResult> moveToTop(String playlistId, String routeId) async =>
      await PUT('playlistdetail/$playlistId', body: {ApiKey.route_id: routeId});

  Future<ApiResult> getFavorite(int userId,int nextPage) async =>
      await GET("favourite?start=$nextPage&count=${ApiKey.limit_offset}");

  Future<ApiResult> removeFromFavorite(String routeIds) async =>
      await DELETE('favourite?ids=$routeIds',/*body: {ApiKey.route_ids: routeId}*/);

  Future<ApiResult> addToFavorite(int userId, List<String> routeIds) async =>
      await POST('favourite', {
        ApiKey.route_ids: routeIds
      });

  Future<ApiResult> removeFromPlaylist(
      String playlistId, String routeId) async =>
      await DELETE('playlistdetail/$playlistId?ids=$routeId');

  Future<ApiResult> createRoute(
          {required String name,
          int height = 12,
          required List<int> lHold,
          required bool hasCorner,
          required int authorGrade,
          bool published = true,
          int visibility = 0}) async =>
      await POST('route', {
        ApiKey.name: name,
        ApiKey.height: height,
        ApiKey.holds: lHold,
        ApiKey.has_conner: hasCorner,
        ApiKey.author_grade: authorGrade,
        ApiKey.published: published,
        ApiKey.visibility: visibility
      });

  Future<ApiResult> editRoute(
      {
        required String routeId,
        required String name,
        int height = 12,
        required List<int> lHold,
        required bool hasCorner,
        required int authorGrade,
        bool published = true,
        int visibility = 0}) async =>
      await PUT('route/$routeId',body: {
        ApiKey.name: name,
        ApiKey.height: height,
        ApiKey.holds: lHold,
        ApiKey.has_conner: hasCorner,
        ApiKey.author_grade: authorGrade,
        ApiKey.published: published,
        ApiKey.visibility: visibility
      });
}
