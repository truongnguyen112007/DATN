import 'package:base_bloc/router/application.dart';
import 'package:base_bloc/router/router.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';

class RootNotification extends StatefulWidget {
  const RootNotification({Key? key}) : super(key: key);

  @override
  State<RootNotification> createState() => _RootNotificationState();
}

class _RootNotificationState extends State<RootNotification> {
  final _navigatorKey = GlobalKey<NavigatorState>(debugLabel: 'RootReservation');

  @override
  void initState() {
    configRouter();
    super.initState();
  }

  void configRouter() {
    var router = FluroRouter();
    NotificationRouters.configureRouter(router);
    Application.notificationRouter = router;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Navigator(
          key: _navigatorKey,
          onGenerateRoute: Application.notificationRouter.generator,
        ),
        onWillPop: () async => _navigatorKey.currentState!.canPop());
  }
}
