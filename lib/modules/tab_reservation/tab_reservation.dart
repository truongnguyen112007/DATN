
import 'package:flutter/cupertino.dart';

import '../../components/app_scalford.dart';
import '../../components/app_text.dart';

class TabReservation extends StatefulWidget {
  const TabReservation({Key? key}) : super(key: key);

  @override
  State<TabReservation> createState() => _TabReservationState();
}

class _TabReservationState extends State<TabReservation> {
  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
        body: Center(
          child: AppText('TAB RESERVATION'),
        ));
  }
}
