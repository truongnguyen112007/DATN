import 'package:flutter/cupertino.dart';

import '../../components/app_scalford.dart';
import '../../components/app_text.dart';

class TabRoutes extends StatefulWidget {
  const TabRoutes({Key? key}) : super(key: key);

  @override
  State<TabRoutes> createState() => _TabRoutesState();
}

class _TabRoutesState extends State<TabRoutes> {
  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
        body: Center(
      child: AppText('TAB ROUTERS'),
    ));
  }
}
