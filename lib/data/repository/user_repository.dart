import 'package:dio/dio.dart';
import 'package:base_bloc/config/constant.dart';
import 'package:base_bloc/data/repository/base_service.dart';
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

  Future<ApiResult> register(String phone, String pass, String name) async =>
      await POST(
          "auth/register",
          FormData.fromMap(
              {ApiKey.phone: phone, ApiKey.password: pass, ApiKey.name: name}),
          isFromData: true);
}
