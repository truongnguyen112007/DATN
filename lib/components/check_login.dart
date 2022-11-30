import 'package:base_bloc/components/app_scalford.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../localization/locale_keys.dart';
import '../theme/app_styles.dart';
import '../theme/colors.dart';
import '../utils/app_utils.dart';
import 'app_text.dart';
import 'gradient_button.dart';

class CheckLogin extends StatefulWidget {
  final VoidCallback loginCallBack;
  const CheckLogin({Key? key, required this.loginCallBack}) : super(key: key);

  @override
  State<CheckLogin> createState() => _CheckLoginState();
}

class _CheckLoginState extends State<CheckLogin> {

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      backgroundColor: colorGreyBackground,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppText(
              LocaleKeys.youNeedLogin.tr(),
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
              onTap: widget.loginCallBack,
              widget: Center(
                child: AppText(
                  LocaleKeys.login.tr(),
                  style: googleFont.copyWith(
                      color: colorWhite, fontSize: 15.sp),
                ),
              ),
              borderRadius: BorderRadius.circular(30),
            ),
          ],
        ),
      ),
    );
  }
}
