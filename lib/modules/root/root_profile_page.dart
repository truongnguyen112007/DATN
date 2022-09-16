import 'package:base_bloc/router/application.dart';
import 'package:base_bloc/router/router.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';

class RootProfilePage extends StatefulWidget {
  const RootProfilePage({Key? key}) : super(key: key);

  @override
  State<RootProfilePage> createState() => _RootProfilePageState();
}

class _RootProfilePageState extends State<RootProfilePage> {
  final navigatorKey = GlobalKey<NavigatorState>(debugLabel: 'RootProfile');

  @override
  void initState() {
    configRouter();
    super.initState();
  }

  void configRouter() {
    var router = FluroRouter();
    ProfileRouters.configureProfileRouter(router);
    Application.profileRouter = router;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Navigator(
            key: navigatorKey,
            onGenerateRoute: Application.profileRouter.generator),
        onWillPop: () async => navigatorKey.currentState!.canPop());
  }
}
