import 'package:base_bloc/theme/app_styles.dart';
import 'package:base_bloc/theme/colors.dart';
import 'package:flutter/cupertino.dart';

import '../../../components/app_scalford.dart';

class Schedule extends StatefulWidget {
  const Schedule({Key? key}) : super(key: key);

  @override
  State<Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      backgroundColor: colorGreyBackground,
        body: Center(
      child: Text(
        "Schedule",
        style: googleFont.copyWith(color: colorWhite),
      ),
    ));
  }
}
