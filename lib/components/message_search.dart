import 'package:base_bloc/components/app_text.dart';
import 'package:flutter/cupertino.dart';

import '../theme/app_styles.dart';
import '../theme/colors.dart';

class MessageSearch extends StatelessWidget {
  const MessageSearch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: AppText('This feature is under construction',
            style: googleFont.copyWith(color: colorWhite)));

  }
}
