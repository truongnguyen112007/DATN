import 'package:base_bloc/base/base_state.dart';
import 'package:base_bloc/components/app_scalford.dart';
import 'package:base_bloc/components/appbar_widget.dart';
import 'package:base_bloc/config/constant.dart';
import 'package:base_bloc/localizations/app_localazations.dart';
import 'package:base_bloc/theme/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:babylonjs_viewer/babylonjs_viewer.dart';

import '../../gen/assets.gen.dart';

class HoldSetDetailPage extends StatefulWidget {
  const HoldSetDetailPage({Key? key}) : super(key: key);

  @override
  State<HoldSetDetailPage> createState() => _HoldSetDetailPageState();
}

class _HoldSetDetailPageState extends BasePopState<HoldSetDetailPage> {
  @override
  Widget buildWidget(BuildContext context) {
    return AppScaffold(
      backgroundColor: colorBlack,
      body: BabylonJSViewer(
        src: Assets.td.boombox,
      ),
      appbar: appBarWidget(context: context, titleStr: LocaleKeys.td),
    );
  }

  @override
  int get tabIndex => BottomNavigationConstant.TAB_ROUTES;
}
