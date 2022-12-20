import 'package:base_bloc/base/base_state.dart';
import 'package:base_bloc/base/hex_color.dart';
import 'package:base_bloc/components/app_circle_loading.dart';
import 'package:base_bloc/components/app_network_image.dart';
import 'package:base_bloc/components/app_scalford.dart';
import 'package:base_bloc/components/app_text.dart';
import 'package:base_bloc/components/appbar_widget.dart';
import 'package:base_bloc/components/gradient_button.dart';
import 'package:base_bloc/config/constant.dart';
import 'package:base_bloc/data/model/hold_set_model.dart';
import 'package:base_bloc/modules/hold_set/hold_set_cubit.dart';
import 'package:base_bloc/modules/hold_set/hold_set_state.dart';
import 'package:base_bloc/theme/colors.dart';
import 'package:base_bloc/utils/app_utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../components/app_text_field.dart';
import '../../data/globals.dart';
import '../../localization/locale_keys.dart';
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
        body: Column(
          children: [
            Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width,
                        height: 0.1,
                        color: colorText45),
                    itemSpace(),
                    BlocBuilder<HoldSetCubit, HoldSetState>(
                        bloc: _bloc,
                        builder: (c, state) => Row(
                          children: [
                            filterButton(
                                onTab: () => _bloc.setFilter(SelectType.ALL),
                                lColor: state.type == SelectType.ALL
                                    ? [colorOrange100, colorOrange40]
                                    : [colorBlack30, colorBlack30],
                                title: LocaleKeys.all.tr()),
                            const SizedBox(
                              width: 10,
                            ),
                            filterButton(
                                onTab: () =>
                                    _bloc.setFilter(SelectType.FAVOURITE),
                                lColor: state.type == SelectType.FAVOURITE
                                    ? [colorOrange100, colorOrange40]
                                    : [colorBlack30, colorBlack30],
                                title: LocaleKeys.favourite.tr()),
                          ],
                        )),
                    itemSpace(),
                    BlocBuilder<HoldSetCubit, HoldSetState>(
                        bloc: _bloc,
                        builder: (c, state) => textFieldWidget(
                            TextEditingController(
                                text: state.type == SelectType.ALL
                                    ? LocaleKeys.all.tr()
                                    : LocaleKeys.favourite.tr()),
                            context,
                            LocaleKeys.type.tr(), () {
                          Utils.hideKeyboard(context);
                        })),
                    itemSpace(),
                    InkWell(
                      child: AppText(
                        LocaleKeys.double_tab_to_see_3d_preview.tr(),
                        style: typoW400.copyWith(
                            fontSize: 12.sp, color: colorText0.withOpacity(0.6)),
                      ),
                      onTap: () => _bloc.detailOnclick(context),
                    ),
                    itemSpace(),
                    Expanded(child: holdSetWidget(context)),
                    itemSpace(height: 20),
                  ],
                )),
            BlocBuilder<HoldSetCubit, HoldSetState>(
              bloc: _bloc,
              builder: (c, state) => selectButton(
                onTab: () => _bloc.selectOnClick(
                    state.lHoldSet[state.currentIndex], context),
              ),
            ),
          ],
        ));
  }

  Widget holdSetWidget(BuildContext context) =>
      BlocBuilder<HoldSetCubit, HoldSetState>(
          bloc: _bloc,
          builder: (i, state) => state.status == HoldSetStatus.INITITAL
              ? const Center(child: AppCircleLoading())
              : GridView.builder(
                  shrinkWrap: true,
                  itemCount: state.lHoldSet.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  itemBuilder: (c, i) => itemHoldSetWidget(
                      context, i, state.lHoldSet[i], state.currentIndex),
                ));

  Widget itemHoldSetWidget(
          BuildContext context, int index, HoldSetModel model, int currentIndex) =>
      Padding(
        padding: const EdgeInsets.all(1.8),
        child: InkWell(
          child: Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    border: Border.all(
                        color: currentIndex == index
                            ? HexColor('FF5A00')
                            : Colors.transparent),
                    color: currentIndex == index ? colorPink30 : colorWhite,
                    borderRadius: BorderRadius.circular(8)),
                  child: AppNetworkImage(
                      source: Utils.getUrlHoldSet(model.id??0)
                  )),
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 2, top: 2),
                  child: Icon(
                    Icons.check_circle,
                    color: currentIndex == index
                        ? HexColor('403B38')
                        : Colors.transparent,
                  ),
                ),
              )
            ],
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
              textStyle: typoW400.copyWith(
                  fontSize: 16, color: colorText0.withOpacity(0.87)),
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
            child: AppText(title,
                style: typoW400.copyWith(
                    color: colorText0.withOpacity(0.6), fontSize: 12.sp)),
          ),
        ],
      );

  Widget itemSpace({double height = 10}) => SizedBox(
        height: height,
      );

  Widget selectButton({
    required VoidCallback onTab,
  }) =>
      GradientButton(
          height: 36.h,
          isCenter: true,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              gradient: Utils.backgroundGradientOrangeButton(),
              borderRadius: BorderRadius.circular(30)),
          onTap: () => onTab.call(),
          widget: AppText(LocaleKeys.select.tr(),
              textAlign: TextAlign.center,
              style: typoW600.copyWith(color: colorText0, fontSize: 12.5.sp)),
          borderRadius: BorderRadius.circular(30));

  Widget filterButton(
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
            style: typoW600.copyWith(color: colorText0, fontSize: 12.5.sp),
          ),
        ),
      );

  PreferredSizeWidget appbar(BuildContext context) => appBarWidget(
      context: context,
      titleStr: LocaleKeys.select_hold.tr(),
      isHideBottomBar: true);

  @override
  int get tabIndex => BottomNavigationConstant.TAB_ROUTES;
}
