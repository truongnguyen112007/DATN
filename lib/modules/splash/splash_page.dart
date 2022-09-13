import 'package:base_bloc/components/app_scalford.dart';
import 'package:base_bloc/components/app_text.dart';
import 'package:base_bloc/localizations/app_localazations.dart';
import 'package:base_bloc/modules/splash/splash_cubit.dart';
import 'package:base_bloc/utils/log_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final _bloc = SplashCubit();

  @override
  void initState() {
    _bloc.openHomePage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: _bloc,
      listener: (c, s) {
        logE("TAG NEW STATE");
      },
      child: AppScaffold(
          body: Center(
        child: TextButton(
          child: AppText(AppLocalizations.of(context)!.appTitle),
          onPressed: (){},
        ),
      )),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }
}
