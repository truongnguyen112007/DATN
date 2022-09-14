
import 'package:flutter/cupertino.dart';

import '../../components/app_scalford.dart';
import '../../components/app_text.dart';

class TabHome extends StatefulWidget {
  const TabHome({Key? key}) : super(key: key);

  @override
  State<TabHome> createState() => _TabHomeState();
}

class _TabHomeState extends State<TabHome> {
  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
        body: Center(
          child: AppText('TAB HOME'),
        ));
  }
}
