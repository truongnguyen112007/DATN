import 'dart:convert';
import 'package:base_bloc/utils/log_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import '../../localizations/app_localazations.dart';
import '../../utils/connection_utils.dart';
import '../globals.dart' as globals;
import '../globals.dart';
import 'api_result.dart';

class BaseService {
  var baseUrl = '';

  void initProvider() {
    baseUrl = 'http://83.171.249.207/api/v1/';
  }

  // ignore: non_constant_identifier_names
  Future<ApiResult> GET(String url,
      {Map<String, dynamic>? queryParam, bool isNewFormat = false}) async {
    if (await ConnectionUtils.isConnect() == false) {
      return ApiResult(error: LocaleKeys.network_error);
    }
    print('============================================================');
    print('[GET] ${baseUrl}$url');
    print("Bearer ${globals.accessToken}");

    try {
      final response = await Dio().get(
        baseUrl + url,
        queryParameters: queryParam,
        options: Options(headers: {
                'Authorization': 'Bearer ${globals.accessToken}',
                // 'Content-Type': 'application/json',
              },sendTimeout: timeOut,),
      ).timeout(Duration(seconds: timeOut));
      Logger().d(response.data);
      if ((response.statusCode == 200 || response.statusCode == 201) &&
          response.data != null) {
        var result = response.data;
        return ApiResult<dynamic>(
            message: response.data['meta']['message'] ?? '',
            data: result['data']);
      } else {
        Logger().e('Error ${response.statusCode} - ${response.statusMessage}');
        var result = response.data;
        return ApiResult<dynamic>(
            error: isNewFormat
                ? ''
                : result["meta"] ??
                    (result["meta"]["message"] ?? response.statusMessage),
            data: result['data'],
            statusCode: response.statusCode);
      }
    } on DioError catch (exception) {
      Logger().e('[EXCEPTION] ' + exception.response.toString());
      print('============================================================');
      try {
        return ApiResult<dynamic>(
            error: exception.response?.data['meta']['message'] ?? LocaleKeys.network_error,
            statusCode: exception.response?.statusCode);
      } catch (e) {
        return ApiResult<dynamic>(error: LocaleKeys.network_error);
      }
    } catch (error) {
      Logger().e('[EXCEPTION] $error');
      Logger().e('[ERROR] $error');
      print('============================================================');
      return ApiResult<dynamic>(error: LocaleKeys.network_error);
    }
  }

  Future<ApiResult> PATCH(String url, dynamic body) async {
    if (await ConnectionUtils.isConnect() == false) {
      return ApiResult(error: LocaleKeys.network_error);
    }
    print('============================================================');
    print('[PATCH] ${baseUrl}$url');
    print('[PARAMS] $body');
    print("Bearer ${globals.accessToken}");

    try {
      final response = await Dio()
          .patch(
            baseUrl + url,
            data: body,
        options: Options(sendTimeout: timeOut,
          headers: {
            'Authorization': 'Bearer ${globals.accessToken}',
            'lang': globals.lang,
              'Content-Type': 'application/json'
          },
        ),
      ).timeout(Duration(seconds: timeOut));
      if (response.data != null) {
        var result = response.data;
        Logger().d(result);
        return ApiResult<dynamic>(
            data: result['data'],
            statusCode: response.statusCode,
            message: response.data['meta']['message'] ?? '');
      } else {
        Logger().e('Error ${response.statusCode} - ${response.statusMessage}');
        var result = response.data;
        return ApiResult<dynamic>(
          error: result["meta"]["message"] ?? response.statusMessage ?? '',
            data: result);
      }
    } on DioError catch (exception) {
      Logger().e('[EXCEPTION] ' + exception.response.toString());
      print('============================================================');
      try {
        return ApiResult<dynamic>(
            error: exception.response?.data['meta']['message'] ?? LocaleKeys.network_error,
            statusCode: exception.response?.statusCode);
      } catch (e) {
        return ApiResult<dynamic>(error: LocaleKeys.network_error);
      }
    } catch (error) {
      Logger().e('[ERROR] ' + error.toString());
      print('============================================================');
      return ApiResult<dynamic>(error: LocaleKeys.network_error);
    }
  }

  // ignore: non_constant_identifier_names
  Future<ApiResult> POST(String url, dynamic body,
      {bool isMultipart = false, bool isNewFormat = false}) async {
    if (await ConnectionUtils.isConnect() == false) {
      return ApiResult(error: LocaleKeys.network_error);
    }
    print('============================================================');
    print('[POST] ' + baseUrl + url);
    print("Bearer " + globals.accessToken);
    print('[PARAMS] ' + (!isMultipart ? json.encode(body) : body.toString()));
    try {
      var headers = {
        'Authorization': 'Bearer ${globals.accessToken}',
        'Host': 'auth.com',
        'lang': globals.lang,
        'Content-Type': 'application/json',
      };
      final response = await Dio().post(baseUrl + url,
          data: isMultipart ? body : jsonEncode(body),
          options: Options(headers: headers,sendTimeout: timeOut,)).timeout(Duration(seconds: timeOut));
      Logger().d(response.data.toString());
      if (response.data != null) {
        var result = response.data;
        return ApiResult<dynamic>(
            data: result['data'],
            statusCode: response.statusCode,
            message: response.data['meta']['message'] ?? '');
      } else {
        Logger().e(
            'Error ${response.statusCode} - ${response.statusMessage} - ${response.data}');
        var result = response.data;
        return ApiResult<dynamic>(
            error: result["meta"]["message"] ?? response.statusMessage ?? '',
            data: result);
      }
    } on DioError  catch (exception) {
      Logger().e('[EXCEPTION] ' + exception.response.toString());
      print('============================================================');
      try {
        return ApiResult<dynamic>(
            error: exception.response?.data['meta']['message'] ?? LocaleKeys.network_error,
            statusCode: exception.response?.statusCode);
      } catch (e) {
        return ApiResult<dynamic>(error: LocaleKeys.network_error);
      }
    } catch (error) {
      Logger().e('[ERROR] ' + error.toString());
      print('============================================================');
      return ApiResult<dynamic>(error: LocaleKeys.network_error);
    }
  }

  // ignore: non_constant_identifier_names
  Future<ApiResult> PUT(String url,
      {dynamic body, bool isNewFormat = false}) async {
    if (await ConnectionUtils.isConnect() == false) {
      return ApiResult(error: LocaleKeys.network_error);
    }
    print('============================================================');
    print('[PUT] ' + baseUrl + url);
    print('[PARAMS] ' + body.toString());
    try {
      final response = await Dio().put(baseUrl + url,
          data: body,
          options: Options(sendTimeout: timeOut,
            headers: {
              'Authorization': 'Bearer ${globals.accessToken}',
              'Content-Type': 'application/json',
              'lang': globals.lang /*
          'Host': 'auth.com'*/
                },
              ))
          .timeout(Duration(seconds: timeOut));
      Logger().d(response.data);
      if (response.data != null) {
        var result = response.data;
        return ApiResult<dynamic>(
            data: result['data'],
            statusCode: response.statusCode,
            message: response.data["meta"]['message'] ?? '');
      } else {
        Logger().e('Error ${response.statusCode} - ${response.statusMessage}');
        var result = response.data;
        return ApiResult<dynamic>(
            error: result["meta"]["message"] ?? response.statusMessage ?? '',
            data: result);
      }
    } on DioError catch (exception) {
      Logger().e('[EXCEPTION] ' + exception.response.toString());
      print('============================================================');
      try {
        return ApiResult<dynamic>(
            error: exception.response?.data['meta']['message'] ?? LocaleKeys.network_error,
            statusCode: exception.response?.statusCode);
      } catch (e) {
        return ApiResult<dynamic>(error: LocaleKeys.network_error);
      }
    } catch (error) {
      Logger().e('[ERROR] $error');
      print('============================================================');
      return ApiResult<dynamic>(error: LocaleKeys.network_error);
    }
  }

  // ignore: non_constant_identifier_names
  Future<ApiResult> DELETE(String url) async {
    if (await ConnectionUtils.isConnect() == false) {
      return ApiResult(error: LocaleKeys.network_error);
    }
    print('============================================================');
    print('[DELETE] ${baseUrl}$url');
    print("Bearer " + globals.accessToken);

    try {
      final response = await Dio()
          .delete(baseUrl + url,
              options: Options(headers: {
                  'Authorization': 'Bearer ${globals.accessToken}',
                  // 'Content-Type': 'application/json'
                },sendTimeout: timeOut,)).timeout(Duration(seconds: timeOut));
      Logger().d(response.data);
      if (response.data != null) {
        var result = response.data;
        return ApiResult<dynamic>(
            data: result['data'],
            statusCode: response.statusCode,
            message: response.data["meta"]['message'] ?? '');
      } else {
        Logger().e('Error ${response.statusCode} - ${response.statusMessage}');
        var result = response.data;
        return ApiResult<dynamic>(
            error: result["meta"]["message"] ?? response.statusMessage ?? '',
            data: result);
      }
    } on DioError catch (exception) {
      Logger().e('[EXCEPTION] ' + exception.response.toString());
      print('============================================================');
      try {
        return ApiResult<dynamic>(
            error: exception.response?.data['meta']['message'] ??
                LocaleKeys.network_error,
            statusCode: exception.response?.statusCode);
      } catch (e) {
        return ApiResult<dynamic>(error: LocaleKeys.network_error);
      }
    } catch (error) {
      Logger().e('[ERROR] $error');
      print('============================================================');
      return ApiResult<dynamic>(error: LocaleKeys.network_error);
    }
  }
}
