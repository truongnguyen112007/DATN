import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';

import '../../router/application.dart';
import '../../router/router.dart';

class RootGoods extends StatefulWidget {
  const RootGoods({Key? key}) : super(key: key);

  @override
  State<RootGoods> createState() => _RootGoodsState();
}

class _RootGoodsState extends State<RootGoods> {
  final navigatorKey = GlobalKey<NavigatorState>(debugLabel: 'RootClimb');

  @override
  void initState() {
    configRouter();
    super.initState();
  }

  void configRouter() {
    final router = FluroRouter();
    GoodsRouters.configureRouter(router);
    Application.climbRouter = router;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Navigator(
          key: navigatorKey,
          onGenerateRoute: Application.climbRouter.generator,
        ),
        onWillPop: () async {
          return !navigatorKey.currentState!.canPop();
        });
  }
}
