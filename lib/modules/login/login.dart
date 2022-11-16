import 'package:base_bloc/components/app_scalford.dart';
import 'package:base_bloc/components/app_text.dart';
import 'package:base_bloc/components/app_text_field.dart';
import 'package:base_bloc/components/gradient_button.dart';
import 'package:base_bloc/data/globals.dart';
import 'package:base_bloc/localizations/app_localazations.dart';
import 'package:base_bloc/modules/home/home_page.dart';
import 'package:base_bloc/modules/login/login_cubit.dart';
import 'package:base_bloc/theme/app_styles.dart';
import 'package:base_bloc/theme/colors.dart';
import 'package:base_bloc/utils/app_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../base/base_state.dart';
import 'login_state.dart';

class Login extends StatefulWidget {
  final int index;

  const Login({Key? key, required this.index}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends BasePopState<Login> with TickerProviderStateMixin {
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
    _bloc = LoginCubit();
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
          LocaleKeys.login,
          style: googleFont.copyWith(color: colorWhite),
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
                  LocaleKeys.login,
                  style:
                      googleFont.copyWith(color: colorWhite, fontSize: 15.sp),
                ),
              ),
              borderRadius: BorderRadius.circular(30),
            ),
            SizedBox(
              height: 25.h,
            ),
            AppText(
              'Forgot your password?',
              style: googleFont.copyWith(color: colorOrange90),
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
          labelStyle: googleFont.copyWith(color: colorSubText),
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
            borderSide: const BorderSide(color: colorGrey35),
            borderRadius: BorderRadius.circular(5),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: colorGrey35),
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
