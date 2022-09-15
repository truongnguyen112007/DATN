import 'package:base_bloc/components/app_text.dart';
import 'package:base_bloc/theme/app_styles.dart';
import 'package:base_bloc/theme/colors.dart';
import 'package:flutter/cupertino.dart';

class DesignedPage extends StatefulWidget {
  const DesignedPage({Key? key}) : super(key: key);

  @override
  State<DesignedPage> createState() => _DesignedPageState();
}

class _DesignedPageState extends State<DesignedPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: AppText(
        'Design PAGE',
        style: typoSmallTextRegular.copyWith(color: colorText0),
      ),
    );
  }
}
