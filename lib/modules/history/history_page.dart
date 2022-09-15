import 'package:base_bloc/components/app_text.dart';
import 'package:base_bloc/theme/app_styles.dart';
import 'package:base_bloc/theme/colors.dart';
import 'package:flutter/cupertino.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: AppText(
        'History PAGE',
        style: typoSmallTextRegular.copyWith(color: colorText0),
      ),
    );
  }
}
