import 'package:base_bloc/base/base_state.dart';
import 'package:base_bloc/components/app_text.dart';
import 'package:base_bloc/data/globals.dart';
import 'package:base_bloc/data/model/profile_model.dart';
import 'package:base_bloc/modules/tab_profile/edit_settings/edit_account/edit_account_state.dart';
import 'package:base_bloc/theme/app_styles.dart';
import 'package:base_bloc/theme/colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../components/app_scalford.dart';
import '../../../../components/appbar_widget.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../localization/locale_keys.dart';
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
  static double _avatarSize = 56.w;

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
            context: context, titleStr: LocaleKeys.settingsAccount.tr()),
        body: editAccountListView());
  }

  Widget editAccountListView() {
    return BlocBuilder<EditAccountCubit, EditAccountState>(
      bloc: _bloc,
      builder: (BuildContext context, state) {
        return ListView.builder(
          padding: EdgeInsets.only(
              top: 2.0 * contentPadding,
              left: 2.0 * contentPadding,
              bottom: 50.w),
          itemCount: _bloc.commonFieldList(context).length + 1,
          itemBuilder: (context, index) {
            return index == 0
                ? changeAvatarView()
                : commonEditProfileView(index - 1);
          },
        );
      },
    );
  }

  Widget changeAvatarView() {
    return Container(
      child: BlocBuilder<EditAccountCubit, EditAccountState>(
        bloc: _bloc,
        builder: (c, s) => Row(
          children: [
            CircleAvatar(
              radius: _avatarSize / 2.0,
              backgroundColor: Colors.transparent,
              child: ClipOval(
                  child: Image.network(
                s.model?.photo ?? '',
                fit: BoxFit.cover,
                width: _avatarSize,
                height: _avatarSize,
              )),
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
                onPressed: () => {print('CHANGE PHOTO')},
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  child: Text(LocaleKeys.account_change_photo.tr(),
                      style: googleFont.copyWith(
                          fontSize: 14.w,
                          fontWeight: FontWeight.w400,
                          color: colorMainText)),
                ))
          ],
        ),
      ),
    );
  }

  Widget commonEditProfileView(int index) {
    AccountFieldType fieldType =
        _bloc.commonFieldList(context).keys.elementAt(index);
    String? value = _bloc.commonFieldList(context).values.elementAt(index);
    final textEditingController = TextEditingController(text: value);

    return Container(
      padding: EdgeInsets.only(top: contentPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(fieldType.title,
              style: googleFont.copyWith(
                  fontSize: 10.w,
                  fontWeight: FontWeight.w500,
                  color: colorSubText)),
          Row(
            children: [
              Expanded(
                  child: TextField(
                controller: textEditingController,
                style: googleFont.copyWith(
                    fontSize: 22.w,
                    fontWeight: FontWeight.w600,
                    color: colorMainText),
                cursorColor: colorMainText,
                decoration: InputDecoration(
                  hintText: '',
                  border: InputBorder.none,
                ),
              )),
              Transform.scale(
                scale: 0.7,
                child: IconButton(
                  onPressed: () {},
                  splashRadius: 24.w,
                  icon: index % 2 == 0
                      ? Assets.png.icFriends.image(color: Colors.white70)
                      : index % 3 == 0
                          ? Assets.png.icPrivate.image(color: Colors.white70)
                          : Assets.png.icPublic.image(color: Colors.white70),
                ),
              ),
              SizedBox(width: 8.w)
            ],
          ),
          Divider(
            color: colorDivider,
            thickness: 1.0.w,
          )
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
