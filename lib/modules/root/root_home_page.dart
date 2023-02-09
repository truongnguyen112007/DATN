import 'package:base_bloc/router/application.dart';
import 'package:base_bloc/router/router.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';

class RootOverView extends StatefulWidget {
  const RootOverView({Key? key}) : super(key: key);

  @override
  State<RootOverView> createState() => _RootOverViewState();
}

class _RootOverViewState extends State<RootOverView> {
  final navigatorKey = GlobalKey<NavigatorState>(debugLabel: 'RootOverView');

  @override
  void initState() {
    configRouter();
    super.initState();
  }

  void configRouter() {
    var router = FluroRouter();
    OverViewRouters.configureMainRoutes(router);
    Application.overViewRouter = router;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Navigator(
          key: navigatorKey,
          onGenerateRoute: Application.overViewRouter.generator,
        ),
        onWillPop: () async => navigatorKey.currentState!.canPop());
  }
}
