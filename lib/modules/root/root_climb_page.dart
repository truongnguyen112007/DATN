import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';

import '../../router/application.dart';
import '../../router/router.dart';

class RootClimbPage extends StatefulWidget {
  const RootClimbPage({Key? key}) : super(key: key);

  @override
  State<RootClimbPage> createState() => _RootClimbPageState();
}

class _RootClimbPageState extends State<RootClimbPage> {
  final navigatorKey = GlobalKey<NavigatorState>(debugLabel: 'RootClimb');

  @override
  void initState() {
    configRouter();
    super.initState();
  }

  void configRouter() {
    final router = FluroRouter();
    ClimbRouters.configureRouter(router);
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
