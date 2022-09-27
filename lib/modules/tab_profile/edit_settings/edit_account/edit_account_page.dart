import 'package:base_bloc/base/base_state.dart';
import 'package:base_bloc/components/app_text.dart';
import 'package:base_bloc/data/model/user_model.dart';
import 'package:base_bloc/extenstion/string_extension.dart';
import 'package:base_bloc/localizations/app_localazations.dart';
import 'package:base_bloc/theme/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../components/app_scalford.dart';
import '../../../../components/appbar_widget.dart';
import '../../../../gen/assets.gen.dart';
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
        backgroundColor: colorBlack20,
        appbar: appBarWidget(
            context: context,
            titleStr: AppLocalizations.of(context)!.settingsAccount),
        body: editAccountListView());
  }

  Widget editAccountListView() {
    return BlocBuilder(
      bloc: _bloc,
      builder: (BuildContext context, state) {
        return ListView.builder(
          padding: EdgeInsets.only(top: 10.0, bottom: 50.h),
          itemCount: _bloc.commonFieldList(context).length + 1,
          itemBuilder: (context, index) {
            return index == 0
                ? changeAvatarView(_bloc.getCurrentUser())
                : commonEditProfileView(index - 1);
          },
        );
      },
    );
  }

  Widget changeAvatarView(UserModel userModel) {
    return Container(
      padding: EdgeInsets.only(top: 15.h, left: 20.h, bottom: 15.h),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40.0,
            backgroundColor: Colors.transparent,
            child: ClipOval(
                child: Image.network(
              userModel.avatar ?? '',
              fit: BoxFit.cover,
              width: 80.0,
              height: 80.0,
            )),
          ),
          const SizedBox(width: 20.0),
          TextButton(
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                child: Text(AppLocalizations.of(context)!.account_change_photo,
                    style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w500)),
              ),
              style: TextButton.styleFrom(
                primary: Colors.white70,
                onSurface: Colors.black,
                side: BorderSide(color: Colors.white70, width: 1.5),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25))),
              ),
              onPressed: () => {print('CHANGE PHOTO')})
        ],
      ),
    );
  }

  Widget commonEditProfileView(int index) {
    AccountFieldType fieldType = _bloc.commonFieldList(context).keys.elementAt(index);
    String? value = _bloc.commonFieldList(context).values.elementAt(index);
    final textEditingController = TextEditingController(text: value);

    return Container(
      padding: EdgeInsets.only(top: 15.h, left: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(fieldType.title(context),
              style: TextStyle(color: Colors.white60, fontSize: 12.0)),
          Row(
            children: [
              Expanded(
                  child: TextField(
                    controller: textEditingController,
                style: TextStyle(color: Colors.white70, fontSize: 24.0, fontWeight: FontWeight.w600),
                cursorColor: Colors.grey,
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
                  icon: index % 2 == 0 ? Assets.png.icFriends.image(color: Colors.white70) : index % 3 == 0 ? Assets.png.icPrivate.image(color: Colors.white70) : Assets.png.icPublic.image(color: Colors.white70),
                ),
              ),
              SizedBox(width: 8.w)
            ],
          ),
          SizedBox(height: 0.h),
          Divider(
            color: Colors.white30,
            height: 0.5.h,
          )
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
