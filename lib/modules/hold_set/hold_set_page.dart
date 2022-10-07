import 'package:base_bloc/base/base_state.dart';
import 'package:base_bloc/components/app_button.dart';
import 'package:base_bloc/components/app_scalford.dart';
import 'package:base_bloc/components/app_text.dart';
import 'package:base_bloc/components/appbar_widget.dart';
import 'package:base_bloc/config/constant.dart';
import 'package:base_bloc/localizations/app_localazations.dart';
import 'package:base_bloc/modules/hold_set/hold_set_cubit.dart';
import 'package:base_bloc/modules/hold_set/hold_set_state.dart';
import 'package:base_bloc/theme/colors.dart';
import 'package:base_bloc/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../components/app_text_field.dart';
import '../../data/globals.dart';
import '../../gen/assets.gen.dart';
import '../../theme/app_styles.dart';

class HoldSetPage extends StatefulWidget {
  const HoldSetPage({Key? key}) : super(key: key);

  @override
  State<HoldSetPage> createState() => _HoldSetPageState();
}

class _HoldSetPageState extends BasePopState<HoldSetPage> {
  late HoldSetCubit _bloc;

  @override
  void initState() {
    _bloc = HoldSetCubit();
    super.initState();
  }

  @override
  Widget buildWidget(BuildContext context) {
    return AppScaffold(
      padding: EdgeInsets.all(contentPadding),
      backgroundColor: colorBlack90,
      appbar: appbar(context),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 0.1,
              color: colorText45,
            ),
            itemSpace(),
            BlocBuilder<HoldSetCubit, HoldSetState>(
                bloc: _bloc,
                builder: (c, state) => Row(
                      children: [
                        button(
                            onTab: () => _bloc.setFilter(SelectType.ALL),
                            lColor: state.type == SelectType.ALL
                                ? [colorOrange100, colorOrange40]
                                : [colorBlack30, colorBlack30],
                            title: LocaleKeys.all),
                        const SizedBox(
                          width: 10,
                        ),
                        button(
                            onTab: () => _bloc.setFilter(SelectType.FAVOURITE),
                            lColor: state.type == SelectType.FAVOURITE
                                ? [colorOrange100, colorOrange40]
                                : [colorBlack30, colorBlack30],
                            title: LocaleKeys.favourite),
                      ],
                    )),
            itemSpace(),
            BlocBuilder<HoldSetCubit, HoldSetState>(
                bloc: _bloc,
                builder: (c, state) => textFieldWidget(
                        TextEditingController(
                            text: state.type == SelectType.ALL
                                ? LocaleKeys.all
                                : LocaleKeys.favourite),
                        context,
                        LocaleKeys.type, () {
                      Utils.hideKeyboard(context);
                    })),
            itemSpace(height: 20),
            AppText(
              LocaleKeys.double_tab_to_see_3d_preview,
              style: typoSmallTextRegular.copyWith(color: colorText45),
            ),
            itemSpace(),
            holdSetWidget(context),
            itemSpace(height: 20),
            button(
                onTab: () {},
                padding: EdgeInsets.only(
                    top: contentPadding, bottom: contentPadding),
                lColor: [colorOrange100, colorOrange40],
                title: LocaleKeys.favourite,
                width: MediaQuery.of(context).size.width),
          ],
        ),
      ),
    );
  }

  Widget holdSetWidget(BuildContext context) =>
      BlocBuilder<HoldSetCubit, HoldSetState>(
          bloc: _bloc,
          builder: (i, state) => GridView.builder(
                shrinkWrap: true,
                itemCount: state.lHoldSet.length,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemBuilder: (c, i) => itemHoldSetWidget(
                    context, i, state.lHoldSet[i], state.currentIndex),
              ));

  Widget itemHoldSetWidget(
          BuildContext context, int index, String icon, int currentIndex) =>
      Padding(
        padding: const EdgeInsets.all(1.5),
        child: InkWell(
          child: Container(
            decoration: BoxDecoration(
                color: currentIndex == index ? colorPink30 : colorWhite,
                borderRadius: BorderRadius.circular(8)),
            child: Image.asset(icon),
          ),
          onTap: () => _bloc.setIndex(index),
        ),
      );

  Widget textFieldWidget(TextEditingController controller, BuildContext context,
          String title, VoidCallback onTap) =>
      Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 9.h),
            child: AppTextField(
              controller: controller,
              onTap: () => onTap.call(),
              isShowErrorText: false,
              textStyle: typoSmallTextRegular.copyWith(
                color: colorText0,
              ),
              cursorColor: Colors.white60,
              decoration: decorTextField.copyWith(
                  fillColor: Colors.transparent,
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 16)),
            ),
          ),
          Container(
            color: colorBlack90,
            margin: EdgeInsets.only(left: contentPadding),
            padding: const EdgeInsets.only(left: 3, right: 7),
            child: AppText(
              title,
              style: typoSmallTextRegular.copyWith(
                  color: colorText62, backgroundColor: colorBlack90),
            ),
          ),
        ],
      );

  Widget itemSpace({double height = 10}) => SizedBox(
        height: height,
      );

  Widget button(
          {required List<Color> lColor,
          required String title,
          required VoidCallback onTab,
          double? width,
          EdgeInsetsGeometry? padding}) =>
      InkWell(
        onTap: () => onTab.call(),
        child: Container(
          alignment: Alignment.center,
          width: width,
          padding: padding ??
              const EdgeInsets.only(left: 12, right: 12, top: 8, bottom: 8),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: lColor,
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter),
              borderRadius: BorderRadius.circular(30)),
          child: AppText(
            title,
            style: typoSmallTextRegular.copyWith(color: colorText0),
          ),
        ),
      );

  PreferredSizeWidget appbar(BuildContext context) =>
      appBarWidget(context: context, titleStr: LocaleKeys.select_hold);

  @override
  int get tabIndex => BottomNavigationConstant.TAB_ROUTES;

  @override
  bool get isNewPage => true;
}
