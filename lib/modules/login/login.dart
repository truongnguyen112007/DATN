import 'package:base_bloc/components/app_scalford.dart';
import 'package:base_bloc/components/app_text.dart';
import 'package:base_bloc/components/gradient_button.dart';
import 'package:base_bloc/modules/login/login_cubit.dart';
import 'package:base_bloc/theme/app_styles.dart';
import 'package:base_bloc/theme/colors.dart';
import 'package:base_bloc/utils/app_utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../base/base_state.dart';
import '../../localization/locale_keys.dart';
import 'login_state.dart';

class LoginPage extends StatefulWidget {
  final int index;
  final bool isGoBack;

  const LoginPage({Key? key, required this.index, this.isGoBack = false})
      : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends BasePopState<LoginPage> with TickerProviderStateMixin {
  bool _obscureText = true;
  final emailController = TextEditingController();
  final passWordController = TextEditingController();
  late LoginCubit _bloc;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  void initState() {
    _bloc = LoginCubit(widget.isGoBack);
    super.initState();
  }

  @override
  Widget buildWidget(BuildContext context) {
    return AppScaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: colorGreyBackground,
      appbar: AppBar(
        backgroundColor: colorBlack,
        title: AppText(
          LocaleKeys.login.tr(),
          style: googleFont.copyWith(color: colorWhite,fontSize: 21.sp),
        ),
      ),
      body: 
      Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            BlocBuilder<LoginCubit, LoginState>(
              bloc: _bloc,
              builder: (c, s) => textField(
                errorText: s.errorEmail,
                labelText: 'E-mail address',
                controller: emailController,
                obText: false,
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            BlocBuilder<LoginCubit, LoginState>(
              bloc: _bloc,
              builder: (c, s) => textField(
                  errorText: s.errorPassword,
                  labelText: 'Password',
                  icon: Icons.remove_red_eye,
                  controller: passWordController,
                  voidCallback: _toggle,
                  obText: _obscureText),
            ),
            SizedBox(
              height: 30.h,
            ),
            GradientButton(
              height: 36.h,
              decoration: BoxDecoration(
                  gradient: Utils.backgroundGradientOrangeButton(),
                  borderRadius: BorderRadius.circular(30)),
              onTap: () {
                _bloc.onClickLogin(
                    emailController.text, passWordController.text, context);
              },
              widget: Center(
                child: AppText(
                LocaleKeys.login.tr(),
                style: googleFont.copyWith(color: colorWhite, fontSize: 17.sp),
              )),
              borderRadius: BorderRadius.circular(30),
            ),
            SizedBox(
              height: 25.h,
            ),
            AppText(
              LocaleKeys.forgotPassword.tr(),
              style: googleFont.copyWith(color: colorPrimaryOrange100,fontSize: 15.5.sp),
            )
          ],
        ),
      ),
    );
  }

  Widget textField(
      {required String labelText,
      IconData? icon,
      String errorText = '',
      required TextEditingController controller,
      required bool obText,
      VoidCallback? voidCallback}) {
    return TextFormField(
      obscureText: obText,
      style: googleFont.copyWith(color: colorWhite),
      controller: controller,
      cursorColor: colorOrange90,
      decoration: InputDecoration(
          errorText: errorText.isEmpty ? null : errorText,
          labelText: labelText,
          labelStyle: googleFont.copyWith(color: errorText.isEmpty ? colorSubText: colorSemanticRed100,fontSize: 18.sp),
          suffixIcon: InkWell(
            splashColor: colorTransparent,
            hoverColor: colorTransparent,
            onTap: voidCallback,
            child: Icon(
              icon,
              color: colorGrey35,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: colorSemanticRed100),
            borderRadius: BorderRadius.circular(5),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: colorGrey35),
            borderRadius: BorderRadius.circular(5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: colorSemanticRed100),
            borderRadius: BorderRadius.circular(5),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: colorGrey35),
            borderRadius: BorderRadius.circular(5),
          ),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: colorGrey35),
            borderRadius: BorderRadius.circular(5),
          )),
    );
  }

  @override
  int get tabIndex => widget.index;
}
