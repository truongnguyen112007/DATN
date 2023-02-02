import 'package:base_bloc/base/base_state.dart';
import 'package:base_bloc/components/app_text.dart';
import 'package:base_bloc/data/globals.dart';
import 'package:base_bloc/data/model/profile_model.dart';
import 'package:base_bloc/data/model/user_profile_model.dart';
import 'package:base_bloc/modules/tab_profile/edit_settings/edit_account/edit_account_state.dart';
import 'package:base_bloc/theme/app_styles.dart';
import 'package:base_bloc/theme/colors.dart';
import 'package:base_bloc/utils/log_utils.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rxdart/rxdart.dart';
import '../../../../components/app_scalford.dart';
import '../../../../components/appbar_widget.dart';
import '../../../../components/type_profile_widget.dart';
import '../../../../config/constant.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../localization/locale_keys.dart';
import '../../../../utils/app_utils.dart';
import 'edit_account_cubit.dart';

class EditAccountPage extends StatefulWidget {
  final UserProfileModel model;
  final int routePage;

  const EditAccountPage(
      {Key? key, required this.model, required this.routePage})
      : super(key: key);

  @override
  State<EditAccountPage> createState() => _EditAccountState();
}

class _EditAccountState extends BasePopState<EditAccountPage> {
  final _scrollController = ScrollController();
  late final EditAccountCubit _bloc;
  final nicknameController = TextEditingController();
  final nameController = TextEditingController();
  final surnameController = TextEditingController();
  final heightController = TextEditingController();
  final favoriteController = TextEditingController();
  final emailController = TextEditingController();
  final focusHeight = FocusNode();

  @override
  void initState() {
    var role = TypeProfile.USER;
    switch (widget.model.role) {
      case ApiKey.route_setter:
        role = TypeProfile.ROUTER_SETTER;
        break;
      case ApiKey.trainer:
        role = TypeProfile.TRAINER;
    }
    _bloc = EditAccountCubit(role);
    nicknameController.text = widget.model.username ?? "";
    nameController.text = widget.model.firstName ?? "";
    surnameController.text = widget.model.lastName ?? "";
    heightController.text = widget.model.height?? "" ;
    favoriteController.text = "5A+";
    emailController.text = widget.model.email ?? "";
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _bloc.close();
    super.dispose();
  }

  @override
  Widget buildWidget(BuildContext context) {
    return AppScaffold(
      isTabToHideKeyBoard: true,
      backgroundColor: colorGreyBackground,
      appbar: appBarWidget(
          onPressed: () {
            _bloc.askSaveInfo(context);
          },
          context: context,
          titleStr: LocaleKeys.settingsAccount.tr(),
          action: [
            BlocBuilder<EditAccountCubit, EditAccountState>(
              bloc: _bloc,
              builder: (c, s) =>
              s.isOnChangeInfo!
                  ? IconButton(
                onPressed: () {
                  _bloc.saveInfo(
                      c,
                      nameController.text,
                      surnameController.text,
                      heightController.text,
                      emailController.text);
                },
                icon: const Icon(Icons.check, size: 30),
                splashRadius: 20,
              )
                  : const SizedBox(),
            )
          ]),
      body: BlocBuilder<EditAccountCubit, EditAccountState>(
        bloc: _bloc,
        builder: (c, s) {
          return SingleChildScrollView(
            child: Column(
              children: [
                changeAvatarView(),
                SizedBox(
                  height: 10.h,
                ),
                textField(
                    LocaleKeys.account_nickname.tr(),
                    nicknameController,
                    widget.model.username,
                    Icons.public,
                    TextInputType.text,
                    null),
                textField(
                    LocaleKeys.account_name.tr(),
                    nameController,
                    widget.model.firstName,
                    Icons.people_alt_outlined,
                    TextInputType.text,
                    s.errorName != null && s.errorName!.isNotEmpty
                        ? s.errorName
                        : null),
                textField(
                    LocaleKeys.account_surname.tr(),
                    surnameController,
                    widget.model.lastName,
                    Icons.people_alt_outlined,
                    TextInputType.text,
                    s.errorSurname != null && s.errorSurname!.isNotEmpty
                        ? s.errorSurname
                        : null),
                typeProfile(),
                Stack(
                  children: [
                    textField(
                        LocaleKeys.account_height.tr(),
                        null,
                        widget.model.height ?? '0',
                        Icons.lock_outline,
                        TextInputType.number,
                        s.errorHeight != null && s.errorHeight!.isNotEmpty
                            ? s.errorHeight
                            : null,
                        isReadOnly: true, callback: () {
                      focusHeight.requestFocus();
                    }),
                    heightWidget(),
                  ],
                ),
                textField(
                    LocaleKeys.account_favorite_route_grade.tr(),
                    favoriteController,
                    "5A+",
                    Icons.lock_outline,
                    TextInputType.text,
                    null),
                textField(
                    LocaleKeys.account_email.tr(),
                    emailController,
                    widget.model.email,
                    Icons.lock_outline,
                    TextInputType.text,
                    s.errorEmail != null && s.errorEmail!.isNotEmpty
                        ? s.errorEmail
                        : null),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget changeAvatarView() {
    return BlocBuilder<EditAccountCubit, EditAccountState>(
      bloc: _bloc,
      builder: (c, s) => Padding(
        padding: EdgeInsets.only(top: 10.h, left: 10.w, bottom: 10.h),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Image.network(
                widget.model.photo ?? '',
                fit: BoxFit.cover,
                width: 80.w,
                height: 80.h,
              ),
            ),
            SizedBox(width: 2.0 * contentPadding),
            TextButton(
              style: TextButton.styleFrom(
                primary: colorMainText,
                onSurface: Colors.black,
                side: BorderSide(color: colorMainText, width: 1.w),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25.0))),
              ),
              onPressed: () {},
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                child: Text(LocaleKeys.account_change_photo.tr(),
                    style: googleFont.copyWith(
                        fontSize: 14.w,
                        fontWeight: FontWeight.w400,
                        color: colorMainText)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget heightWidget() {
    return Positioned.fill(
        left: 15.w,
        child: Align(
          alignment: Alignment.centerLeft,
          child: IntrinsicWidth(
            child: TextField(
                controller: heightController,
                onChanged: (text) {
                  _bloc.onChangeInfo(
                      nameController.text,
                      surnameController.text,
                      heightController.text,
                      emailController.text);
                },
                focusNode: focusHeight,
                maxLines: 1,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration:  InputDecoration(
                 // isCollapsed: true,
                  suffixIcon: Padding(
                    padding:  EdgeInsets.only(top: 5.h),
                    child: Text(
                      "cm",
                      style: googleFont.copyWith(
                          fontSize: 22.w,
                          fontWeight: FontWeight.w600,
                          color: colorMainText),
                    ),
                  ),
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
                style: googleFont.copyWith(
                    fontSize: 22.w,
                    fontWeight: FontWeight.w600,
                    color: colorMainText)),
          ),
        ));
  }

  Widget textField(String headline, TextEditingController? controller,
      String? value, IconData icon, TextInputType inputType, String? errorText,
      {bool isReadOnly = false, VoidCallback? callback,}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 15.h, left: 15.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            headline,
            style: googleFont.copyWith(
                fontSize: 10.w,
                fontWeight: FontWeight.w500,
                color: colorSubText),
          ),
          TextField(
            onTap: () => callback?.call(),
            readOnly: isReadOnly,
            onChanged: (text) {
              _bloc.onChangeInfo(
                  nameController.text,
                  surnameController.text,
                  heightController.text,
                  emailController.text);
            },
            controller: controller,
            keyboardType: inputType,
            style: googleFont.copyWith(
                fontSize: 22.w,
                fontWeight: FontWeight.w600,
                color: colorMainText),
            cursorColor: colorMainText,
            decoration: InputDecoration(
              errorText: errorText,
              errorStyle: typoW400.copyWith(color: Colors.red),
              suffixIcon: Icon(
                icon,
                color: colorGrey20,
              ),
              border: const UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: colorWhite,
                  )),
              focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: colorText65)),
              enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: colorText65)),
            ),
          ),
        ],
      ),
    );
  }

  Widget test(String headline, TextEditingController? controller,
      String? value, IconData icon, TextInputType inputType, String? errorText,
      {bool isReadOnly = false, VoidCallback? callback,}) {
    return TextField(
      onTap: () => callback?.call(),
      readOnly: isReadOnly,
      onChanged: (text) {
        _bloc.onChangeInfo(
            nameController.text,
            surnameController.text,
            heightController.text,
            emailController.text
        );
      },
      controller: controller,
      keyboardType: inputType,
      style: googleFont.copyWith(
          fontSize: 22.w,
          fontWeight: FontWeight.w600,
          color: colorMainText),
      cursorColor: colorMainText,
      decoration: InputDecoration(
        errorText: errorText,
        errorStyle: typoW400.copyWith(color: Colors.red),
        suffixIcon: Icon(
          icon,
          color: colorGrey20,
        ),
        border: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: colorWhite,
            )),
        focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: colorText65)),
        enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: colorText65)),
      ),
    );
  }

  Widget typeProfile() {
    return BlocBuilder<EditAccountCubit, EditAccountState>(
      bloc: _bloc,
      builder: (c, s) => InkWell(
        splashColor: colorTransparent,
        onTap: () {
          _bloc.showTypeDialog(c);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 15.w),
              child: AppText(
                LocaleKeys.account_type.tr(),
                style: googleFont.copyWith(
                    fontSize: 10.w, fontWeight: FontWeight.w500, color: colorSubText),
              ),
            ),
            Padding(
                padding: EdgeInsets.only(left: 15.w, top: 10.h,right: 15.w,bottom: 10.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText(
                      s.typeProfile!.type,
                      style: googleFont.copyWith(
                          fontSize: 22.w,
                          fontWeight: FontWeight.w600,
                          color: colorMainText),
                    ),
                    const Icon(Icons.public,color: colorGrey20,)
                  ],
                )),
            Padding(
              padding: EdgeInsets.only(left: 15.w, bottom: 20.h),
              child: Container(height: 1,color: colorText65,),
            )
          ],
        ),
      ),
    );
  }

  @override
  int get tabIndex => widget.routePage;
  }

