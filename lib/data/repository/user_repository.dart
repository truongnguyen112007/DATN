import 'package:base_bloc/data/model/create_import_param.dart';
import 'package:dio/dio.dart';
import 'package:base_bloc/config/constant.dart';
import 'package:base_bloc/data/repository/base_service.dart';
import '../globals.dart' as globals;
import '../model/create_export_param.dart';
import 'api_result.dart';

class UserRepository extends BaseService {
  static UserRepository instance = UserRepository._init();

  factory UserRepository() {
    return instance;
  }

  UserRepository._init() {
    initProvider();
  }

  Future<ApiResult> login(String phone, String pass) async =>
      await POST('auth/login', {ApiKey.phone: phone, ApiKey.password: pass},
          isFromData: true);

  Future<ApiResult> logout() async => await POST('auth/logout', null);

  Future<ApiResult> register(String phone, String pass, String name) async =>
      await POST("auth/register",
          {ApiKey.phone: phone, ApiKey.password: pass, ApiKey.name: name},
          isFromData: true);

  Future<ApiResult> getAllProduct() async => await GET('product');

  Future<ApiResult> createProduct(
          String name,
          String sku,
          String upcCode,
          String description,
          String price,
          String inStock,
          String image,
          String unit,
          String status,
          String catId) async =>
      await POST(
          'product',
          {
            ApiKey.name: name,
            ApiKey.sku: sku,
            ApiKey.upcCode: upcCode,
            ApiKey.description: description,
            ApiKey.price: price,
            ApiKey.inStock: inStock,
            ApiKey.image: image,
            ApiKey.unit: unit,
            ApiKey.status: status,
            ApiKey.categoryId: catId
          },
          isFromData: true);

  Future<ApiResult> getProductDetail(int id) async => await GET('product/$id');

  Future<ApiResult> getAllBill() async => await GET('customer');

  Future<ApiResult> createExport(CreateExportParam param) async =>
      await POST('export', param.toJson());


  Future<ApiResult> createImport(CreateImportParam param) async =>
      await POST('import', param.toJson());
}
