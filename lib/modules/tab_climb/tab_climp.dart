import 'package:base_bloc/components/app_scalford.dart';
import 'package:base_bloc/components/app_text.dart';
import 'package:flutter/cupertino.dart';

class TabClimb extends StatefulWidget {
  const TabClimb({Key? key}) : super(key: key);

  @override
  State<TabClimb> createState() => _TabClimbState();
}

class _TabClimbState extends State<TabClimb> {
  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
        body: Center(
      child: AppText('TAB CLIM'),
    ));
  }
}
