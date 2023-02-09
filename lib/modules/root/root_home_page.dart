import 'package:base_bloc/router/application.dart';
import 'package:base_bloc/router/router.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';

class RootHomePage extends StatefulWidget {
  const RootHomePage({Key? key}) : super(key: key);

  @override
  State<RootHomePage> createState() => _RootHomePageState();
}

class _RootHomePageState extends State<RootHomePage> {
  final navigatorKey = GlobalKey<NavigatorState>(debugLabel: 'RootHome');

  @override
  void initState() {
    configRouter();
    super.initState();
  }

  void configRouter() {
    var router = FluroRouter();
    HomeRouters.configureMainRoutes(router);
    Application.homeRouter = router;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Navigator(
          key: navigatorKey,
          onGenerateRoute: Application.homeRouter.generator,
        ),
        onWillPop: () async => navigatorKey.currentState!.canPop());
  }
}
