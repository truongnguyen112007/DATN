import 'package:flutter/cupertino.dart';

import '../../components/app_scalford.dart';
import '../../components/app_text.dart';

class TabProfile extends StatefulWidget {
  const TabProfile({Key? key}) : super(key: key);

  @override
  State<TabProfile> createState() => _TabProfileState();
}

class _TabProfileState extends State<TabProfile> {
  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
        body: Center(
          child: AppText('TAB PROFILE'),
        ));
  }
}
