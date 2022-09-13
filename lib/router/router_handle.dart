import 'package:base_bloc/modules/home/home_page.dart';
import 'package:base_bloc/modules/splash/splash_page.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';

var routeSplash = Handler(handlerFunc: (c,p)=>SplashPage());
var routeHome = Handler(handlerFunc: (c,p)=>HomePage());
// var routeHome = Handler(handlerFunc: (c, p) => HomePage());
/*var routeTest = Handler(
    handlerFunc: (context, p) => TestPage(
          tabIndex: context!.settings!.arguments as int,
        ));

var routeTabMain = Handler(handlerFunc: (c, p) => TabMain());

var routeTabSecond = Handler(handlerFunc: (c, p) => TabSecond());
var routeTest2 = Handler(
    handlerFunc: (c, p) => Test2Page(tabIndex: c!.settings!.arguments as int));*/
