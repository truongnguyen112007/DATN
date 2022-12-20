library app.globals;

import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../gen/assets.gen.dart';
import 'model/hold_set_model.dart';

String accessToken = '';
String refreshToken = '';
String lang = '';
String avatar = '';
String deviceId = '';
int userId = 0;
String deviceName = '';
String deviceModel = '';
String userName = '';
String playlistId = '';
String languageCode = '';

var lHoldSet=<HoldSetModel>[];
bool isLogin = false;
bool isTokenExpired = false;
int timePackageRemaining = 0;
int timeOut = 30;

double contentPadding = 8.w;


List<String> lHoldSetName = [
  'A',
  'B',
  'C',
  'D',
  'E',
  'F',
  'G',
  'H',
  'I',
  'J',
  'K',
  'L'
];
