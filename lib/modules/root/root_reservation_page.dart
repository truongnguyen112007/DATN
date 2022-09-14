import 'package:base_bloc/router/application.dart';
import 'package:base_bloc/router/router.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';

class RootReservationPage extends StatefulWidget {
  const RootReservationPage({Key? key}) : super(key: key);

  @override
  State<RootReservationPage> createState() => _RootReservationPageState();
}

class _RootReservationPageState extends State<RootReservationPage> {
  final _navigatorKey = GlobalKey<NavigatorState>(debugLabel: 'RootReservation');

  @override
  void initState() {
    configRouter();
    super.initState();
  }

  void configRouter() {
    var router = FluroRouter();
    ReservationRouters.configureRouter(router);
    Application.reservationsRouter = router;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Navigator(
          key: _navigatorKey,
          onGenerateRoute: Application.reservationsRouter.generator,
        ),
        onWillPop: () async => _navigatorKey.currentState!.canPop());
  }
}
