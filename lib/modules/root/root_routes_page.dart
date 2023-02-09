import 'package:base_bloc/router/application.dart';
import 'package:base_bloc/router/router.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';

class RootReceipt extends StatefulWidget {
  const RootReceipt({Key? key}) : super(key: key);

  @override
  State<RootReceipt> createState() => _RootReceiptState();
}

class _RootReceiptState extends State<RootReceipt> {
  final _navigatorKey = GlobalKey<NavigatorState>(debugLabel: 'RootRoutes');

  @override
  void initState() {
    configRouter();
    super.initState();
  }

  void configRouter() {
    var router = FluroRouter();
    ReceiptRouters.configureRouter(router);
    Application.routesRouter = router;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Navigator(key: _navigatorKey,onGenerateRoute: Application.routesRouter.generator,),
        onWillPop: () async => _navigatorKey.currentState!.canPop());
  }
}
