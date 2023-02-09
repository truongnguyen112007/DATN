import 'package:base_bloc/components/app_scalford.dart';
import 'package:base_bloc/modules/register/register_cubit.dart';
import 'package:base_bloc/modules/register/register_state.dart';
import 'package:base_bloc/theme/colors.dart';
import 'package:base_bloc/utils/toast_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../components/app_text.dart';
import '../../components/gradient_button.dart';
import '../../gen/assets.gen.dart';
import '../../theme/app_styles.dart';
import '../login/login.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  late  RegisterCubit _bloc;
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void initState() {
    _bloc = RegisterCubit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: colorWhite,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.arrow_back,
                  color: colorGreen60,
                  size: 25,
                )),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FittedBox(
                child: SizedBox(
                  height: 140.h,
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
              Container(
                padding: EdgeInsets.only(
                    right: 10.w, left: 10.w, top: 20.h, bottom: 10.h),
                margin: EdgeInsets.only(
                    top: 10.h, bottom: 20.h, left: 10.w, right: 10.w),
                decoration: BoxDecoration(boxShadow: const [
                  BoxShadow(
                    color: colorGreen60,
                    spreadRadius: 0.1,
                    blurRadius: 1.2,
                  ),
                ], color: colorWhite, borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: [
                    BlocBuilder<RegisterCubit, RegisterState>(
                      bloc: _bloc,
                      builder: (c, s) => textField(
                          labelText: "Họ và tên",
                          errorText: s.errorName,
                          obText: false,
                          controller: nameController),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    BlocBuilder<RegisterCubit, RegisterState>(
                      bloc: _bloc,
                      builder: (c, s) => textField(
                          errorText: s.errorPhone,
                          labelText: "Số điện thoại",
                          obText: false,
                          controller: phoneController),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    BlocBuilder<RegisterCubit, RegisterState>(
                      bloc: _bloc,
                      builder: (c, s) => textField(
                          errorText: s.errorPassword,
                          labelText: "Mật khẩu",
                          obText: true,
                          icon: Icons.remove_red_eye_rounded,
                          controller: passwordController),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    BlocBuilder<RegisterCubit, RegisterState>(
                      bloc: _bloc,
                      builder: (c, s) => textField(
                          errorText: s.errorCfPassword,
                          labelText: "Xác nhận mật khẩu",
                          obText: true,
                          icon: Icons.remove_red_eye,
                          controller: confirmPasswordController),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GradientButton(
                  height: 50,
                  borderRadius: BorderRadius.circular(20),
                  decoration: BoxDecoration(
                    color: colorGreen60,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Login()));
                    toast("Đăng ký thành công");
                  },
                  widget: Text(
                    "Đăng ký",
                    style: googleFont.copyWith(
                        color: colorYellow70, fontWeight: FontWeight.w600),
                  ),
                  isCenter: true,
                ),
              ),
            ],
          )
        ],
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
