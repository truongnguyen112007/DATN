import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../localizations/app_localazations.dart';
import '../modules/tab_home/tab_home_cubit.dart';
import '../theme/app_styles.dart';
import '../theme/colors.dart';
import '../utils/app_utils.dart';
import 'app_text.dart';
import 'gradient_button.dart';

class CheckLogin extends StatefulWidget {
  const CheckLogin({Key? key}) : super(key: key);

  @override
  State<CheckLogin> createState() => _CheckLoginState();
}

class _CheckLoginState extends State<CheckLogin> {
  late final TabHomeCubit _bloc;

  @override
  void initState() {
    _bloc = TabHomeCubit();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppText(
            LocaleKeys.youNeedLogin,
            style: googleFont.copyWith(
                color: colorWhite, fontSize: 25.sp),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 20.h,
          ),
          GradientButton(
            height: 40.h,
            width: 200.w,
            decoration: BoxDecoration(
                gradient: Utils.backgroundGradientOrangeButton(),
                borderRadius: BorderRadius.circular(30)),
            onTap: () {
              _bloc.onClickLogin(context);
            },
            widget: Center(
              child: AppText(
                LocaleKeys.login,
                style: googleFont.copyWith(
                    color: colorWhite, fontSize: 15.sp),
              ),
            ),
            borderRadius: BorderRadius.circular(30),
          ),
        ],
      ),
    );
  }
}
