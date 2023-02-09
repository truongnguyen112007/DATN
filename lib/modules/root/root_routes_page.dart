import 'package:base_bloc/router/application.dart';
import 'package:base_bloc/router/router.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';

class RootRoutesPage extends StatefulWidget {
  const RootRoutesPage({Key? key}) : super(key: key);

  @override
  State<RootRoutesPage> createState() => _RootRoutesPageState();
}

class _RootRoutesPageState extends State<RootRoutesPage> {
  final _navigatorKey = GlobalKey<NavigatorState>(debugLabel: 'RootRoutes');

  @override
  void initState() {
    configRouter();
    super.initState();
  }

  void configRouter() {
    var router = FluroRouter();
    RoutesRouters.configureRouter(router);
    Application.routesRouter = router;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Navigator(key: _navigatorKey,onGenerateRoute: Application.routesRouter.generator,),
        onWillPop: () async => _navigatorKey.currentState!.canPop());
  }
}
