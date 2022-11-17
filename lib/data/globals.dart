library app.globals;

import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../gen/assets.gen.dart';

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

bool isLogin = false;
bool isTokenExpired = false;
int timePackageRemaining = 0;
int timeOut = 30;

double contentPadding = 8.w;

final List<String> lHoldSet = [
  Assets.svg.holdset1,
  Assets.svg.holdset2,
  Assets.svg.holdset3,
  Assets.svg.holdset4,
  Assets.svg.holdset5
];
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
