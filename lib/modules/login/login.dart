import 'package:base_bloc/components/app_scalford.dart';
import 'package:base_bloc/components/gradient_button.dart';
import 'package:base_bloc/modules/login/login_cubit.dart';
import 'package:base_bloc/modules/login/login_state.dart';
import 'package:base_bloc/router/router_utils.dart';
import 'package:base_bloc/theme/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../components/app_text.dart';
import '../../gen/assets.gen.dart';
import '../../theme/app_styles.dart';
import '../../utils/log_utils.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _obscureText = true;
  late LoginCubit _bloc;
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  void initState() {
    _bloc = LoginCubit();
    test();
    super.initState();
  }

  void test() {
    phoneController.text = '0327551805';
    passwordController.text = 'Lehuy1920';
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      fullStatusBar: true,
      resizeToAvoidBottomInset: false,
      backgroundColor: colorWhite,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              SizedBox(
                height: 10.h,
              ),
              FittedBox(
                child: Container(
                  height: 180,
                  child: Image.asset(Assets.png.logosplash.path),
                ),
              ),
              AppText(
                "BoBo Management",
                style: googleFont.copyWith(
                    color: colorGreen60,
                    fontWeight: FontWeight.w600,
                    fontSize: 16.sp),
              ),
              SizedBox(
                height: 30.h,
              ),
              SizedBox(
                height: 20.h,
              ),
              Container(
                padding: EdgeInsets.only(
                    right: 10.w, left: 10.w, top: 20.h, bottom: 20.h),
                decoration: BoxDecoration(boxShadow: const [
                  BoxShadow(
                    color: colorGreen60,
                    spreadRadius: 0.1,
                    blurRadius: 1.2,
                  ),
                ], color: colorWhite, borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: [
                    BlocBuilder<LoginCubit, LoginState>(
                      bloc: _bloc,
                      builder: (c, s) => textField(
                          labelText: "Số điện thoại",
                          obText: false,
                          errorText: s.errorPhone,
                          controller: phoneController),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    BlocBuilder<LoginCubit, LoginState>(
                      bloc: _bloc,
                      builder: (c, s) => textField(
                          labelText: "Mật khẩu",
                          errorText: s.errorPassword,
                          obText: true,
                          icon: Icons.remove_red_eye_rounded,
                          controller: passwordController),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              BlocBuilder<LoginCubit, LoginState>(
                bloc: _bloc,
                builder: (c, state) => GradientButton(
                  height: 50,
                  borderRadius: BorderRadius.circular(20),
                  decoration: BoxDecoration(
                    color: colorGreen60,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  onTap: () {
                    _bloc.loginOnclick(
                        phoneController.text, passwordController.text, context);
                  },
                  widget: Text(
                    "Đăng nhập",
                    style: googleFont.copyWith(
                        color: colorYellow70, fontWeight: FontWeight.w600),
                  ),
                  isCenter: true,
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppText(
                    "Bạn chưa có tài khoản? ",
                    style: googleFont.copyWith(color: colorBlack),
                  ),
                  BlocBuilder<LoginCubit, LoginState>(
                    bloc: _bloc,
                    builder: (c, s) => InkWell(
                      onTap: () {
                        _bloc.openRegister(context);
                      },
                      child: AppText("Đăng ký",
                          style: googleFont.copyWith(
                              color: colorBlue40, fontWeight: FontWeight.w600)),
                    ),
                  )
                ],
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppText("Tổng đài hỗ trợ",
                      style: googleFont.copyWith(
                          color: colorBlack, fontSize: 16.sp)),
                  SizedBox(
                    width: 10.w,
                  ),
                  AppText(
                    "1900 2007",
                    style: googleFont.copyWith(
                        color: colorBlue40, fontSize: 16.sp),
                  ),
                ],
              )
            ],
          ),
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
      autofocus: false,
      obscureText: obText,
      style: googleFont.copyWith(color: colorBlack),
      controller: controller,
      cursorColor: colorGreen60,
      decoration: InputDecoration(
        errorText: errorText.isEmpty ? null : errorText,
        labelText: labelText,
        labelStyle: googleFont.copyWith(
            color: errorText.isEmpty ? colorGreen60 : colorSemanticRed100),
        suffixIcon: InkWell(
          splashColor: colorTransparent,
          hoverColor: colorTransparent,
          onTap: voidCallback,
          child: Icon(
            icon,
            color: colorGreen60,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: colorSemanticRed100),
          borderRadius: BorderRadius.circular(5),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: colorGreen60),
          borderRadius: BorderRadius.circular(5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: colorSemanticRed100),
          borderRadius: BorderRadius.circular(5),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: colorGreen60),
          borderRadius: BorderRadius.circular(5),
        ),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: colorGreen60),
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }
}
