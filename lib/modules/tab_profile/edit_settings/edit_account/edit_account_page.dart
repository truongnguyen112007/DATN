import 'package:base_bloc/base/base_state.dart';
import 'package:base_bloc/components/app_text.dart';
import 'package:base_bloc/data/globals.dart';
import 'package:base_bloc/data/model/profile_model.dart';
import 'package:base_bloc/modules/tab_profile/edit_settings/edit_account/edit_account_state.dart';
import 'package:base_bloc/theme/app_styles.dart';
import 'package:base_bloc/theme/colors.dart';
import 'package:base_bloc/utils/log_utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rxdart/rxdart.dart';
import '../../../../components/app_scalford.dart';
import '../../../../components/appbar_widget.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../localization/locale_keys.dart';
import '../../../../utils/app_utils.dart';
import 'edit_account_cubit.dart';

class EditAccountPage extends StatefulWidget {
  const EditAccountPage({Key? key}) : super(key: key);

  @override
  State<EditAccountPage> createState() => _EditAccountState();
}

class _EditAccountState extends BaseState<EditAccountPage>
    with AutomaticKeepAliveClientMixin {
  final _scrollController = ScrollController();
  late final EditAccountCubit _bloc;
  final nickname = TextEditingController();
  final name = TextEditingController();
  final surname = TextEditingController();
  final type = TextEditingController();
  final height = TextEditingController();
  final favorite = TextEditingController();
  final email = TextEditingController();

  @override
  void initState() {
    _bloc = EditAccountCubit();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      backgroundColor: colorGreyBackground,
      appbar: appBarWidget(
          context: context,
          titleStr: LocaleKeys.settingsAccount.tr(),
          action: [
            BlocBuilder<EditAccountCubit, EditAccountState>(
              bloc: _bloc,
              builder: (c, s) => s.isOnChangeInfo!
                  ? IconButton(
                      onPressed: () {
                        _bloc.saveInfo();
                      },
                      icon: const Icon(Icons.check_circle_outline, size: 30),
                      splashRadius: 20,
                    )
                  : const SizedBox(),
            )
          ]),
      body: BlocBuilder<EditAccountCubit, EditAccountState>(
        bloc: _bloc,
        builder: (c, s) {
          logE(s.model?.height??"dsds");
          return SingleChildScrollView(
            child: Column(
              children: [
                changeAvatarView(),
                textField(LocaleKeys.account_nickname.tr(), nickname,
                    s.model?.username??"", Icons.public),
                textField(LocaleKeys.account_name.tr(), name,
                    s.model?.firstName??"", Icons.people_alt_outlined),
                textField(LocaleKeys.account_surname.tr(), surname,
                    s.model?.lastName??"", Icons.people_alt_outlined),
                textField(LocaleKeys.account_type.tr(), type, s.model?.role??"",
                    Icons.public),
                textField(LocaleKeys.account_height.tr(), height, s.model?.height?? "0", Icons.lock_outline),
                textField(LocaleKeys.account_favorite_route_grade.tr(),
                    favorite, "5A+", Icons.lock_outline),
                textField(LocaleKeys.account_email.tr(), email, s.model?.email??"",
                    Icons.lock_outline),
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
                s.model?.photo ?? '',
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

  Widget textField(String headline, TextEditingController controller,
      String value, IconData icon) {
    if (controller.text.isEmpty) {
      controller.text = value ?? "";
    }
    return Padding(
      padding: EdgeInsets.only(bottom: 15.h,left: 15.w),
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
            onChanged: (text) {
              _bloc.onChangeInfo();
            },
            controller: controller,

            style: googleFont.copyWith(
                fontSize: 22.w,
                fontWeight: FontWeight.w600,
                color: colorMainText),
            cursorColor: colorMainText,
            decoration: InputDecoration(
              suffixIcon: Icon(
                icon,
                color: colorGrey20,
              ),
              border: const UnderlineInputBorder(
                borderSide: BorderSide(color: colorWhite,)
              ),
              focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color:colorText65)),
              // disabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: colorWhite)),
              enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: colorText65)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
