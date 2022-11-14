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
      await GET('playlist?start=0&count=${ApiKey.limit_offset}');

  Future<ApiResult> getPlaylistById(String id, {int nextPage = 0}) async =>
      await GET('playlist/$id?start=$nextPage&count=${ApiKey.limit_offset}');

  Future<ApiResult> getFavorite(int userId) async =>
      await GET("favourite/$userId");

  Future<ApiResult> removeFromFavorite(int userId, String routeId) async =>
      await DELETE('favourite?ids=$routeId');

  Future<ApiResult> removeFromPlaylist(
          String playlistId, String routeId) async =>
      await DELETE('playlistdetail/$playlistId?ids=$routeId');

  Future<ApiResult> deleteRoute(String routeId) async =>
      await DELETE('route/$routeId');

  Future<ApiResult> addToFavorite(int userId, String routeId) async =>
      await POST('favourite', {
        ApiKey.route_ids: [routeId]
      });

  Future<ApiResult> addToPlaylist(String playlistId, String routeId) async =>
      await PUT('playlistdetail/$playlistId/$routeId');

  Future<ApiResult> moveToTop(String playlistId, String routeId) async =>
      await PUT('playlistdetail/$playlistId', body: {ApiKey.route_id: routeId});
}
