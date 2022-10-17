import 'package:base_bloc/components/app_text.dart';
import 'package:base_bloc/theme/app_styles.dart';
import 'package:base_bloc/theme/colors.dart';
import 'package:flutter/cupertino.dart';

class MessageTabRoutes extends StatelessWidget {
  const MessageTabRoutes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(child: AppText('No matching results',style: googleFont.copyWith(color: colorWhite),)
    );
  }
}
