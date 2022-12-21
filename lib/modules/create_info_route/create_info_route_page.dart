import 'package:base_bloc/base/hex_color.dart';
import 'package:base_bloc/components/app_scalford.dart';
import 'package:base_bloc/components/app_text.dart';
import 'package:base_bloc/components/app_text_field.dart';
import 'package:base_bloc/components/appbar_widget.dart';
import 'package:base_bloc/components/gradient_button.dart';
import 'package:base_bloc/data/globals.dart' as globals;
import 'package:base_bloc/data/model/holds_param.dart';
import 'package:base_bloc/data/model/info_route_model.dart';
import 'package:base_bloc/data/model/routes_model.dart';
import 'package:base_bloc/extenstion/string_extension.dart';
import 'package:base_bloc/modules/create_info_route/create_info_route_cubit.dart';
import 'package:base_bloc/modules/create_info_route/create_info_route_state.dart';
import 'package:base_bloc/theme/colors.dart';
import 'package:base_bloc/utils/app_utils.dart';
import 'package:base_bloc/utils/log_utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../data/model/hold_set_model.dart';
import '../../gen/assets.gen.dart';
import '../../localization/locale_keys.dart';
import '../../theme/app_styles.dart';
class CreateInfoRoutePage extends StatefulWidget {
  final List<HoldSetModel>? lHoldSet;
  final List<HoldParam>? lHoldParams;
  final RoutesModel? routeModel;
  final bool isEdit;
  final bool isPublish;
  final InfoRouteModel? infoRouteModel;

  const CreateInfoRoutePage(
      {Key? key,
      this.lHoldParams,
      this.lHoldSet,
      this.infoRouteModel,
      this.routeModel,
      this.isEdit = false,
      this.isPublish = true})
      : super(key: key);

  @override
  State<CreateInfoRoutePage> createState() => _CreateInfoRoutePageState();
}

class _CreateInfoRoutePageState extends State<CreateInfoRoutePage> {
  late CreateInfoRouteCubit _bloc;
  var routeNameController = TextEditingController();

  @override
  void initState() {
    _bloc = CreateInfoRouteCubit(
        widget.lHoldSet, widget.lHoldParams, widget.isEdit);
    if (widget.routeModel != null) {
      routeNameController.text = widget.routeModel?.name ?? '';
    } else if (widget.infoRouteModel != null) {
      routeNameController.text = widget.infoRouteModel?.routeName ?? '';
    } else{
      routeNameController.text =
          '${globals.firstName} ${globals.lastName} ${Utils.convertDateToYYYYMMDD(DateTime.now())}';
    }
    _bloc.setData(widget.routeModel, widget.infoRouteModel);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(resizeToAvoidBottomInset: false,
      padding: EdgeInsets.only(
          top: globals.contentPadding, left: globals.contentPadding),
      appbar: appbar(context),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          titleWidget(LocaleKeys.route_name.tr()),
          routeNameWidget(),
          space(),
          titleWidget(LocaleKeys.who_can_see_this_route.tr()),
          space(height: 6),
          Row(
            children: [
              SvgPicture.asset(Assets.svg.friend),
              const SizedBox(width: 10),
              BlocBuilder<CreateInfoRouteCubit, CreateInfoRouteState>(
                  bloc: _bloc,
                  builder: (c, state) => InkWell(
                      child:
                          AppText(state.visibilityType.name, style: typoContent),
                      onTap: () => _bloc.visibilityOnClick(context)))
            ],
          ),
          space(),
          line(),
          space(),
          titleWidget(LocaleKeys.grade.tr()),
          space(),
          gradeWidget(context),
          space(),
          line(),
          space(),
          cornerWidget(),
          space(),
          line(),
          space(),
          heightWidget(),
          space(),
          line()
        ],
      ),
    );
  }

  Widget cornerWidget() => Row(
        children: [
          AppText(
            LocaleKeys.corner.tr().toCapitalize(),
            style: typoW400.copyWith(
                fontSize: 15.sp, color: colorText0.withOpacity(0.87)),
          ),
          const Spacer(),
          BlocBuilder<CreateInfoRouteCubit, CreateInfoRouteState>(
              bloc: _bloc,
              builder: (c, state) => Switch(
                    value: state.isCorner,
                    activeColor: HexColor('FF6B00'),
                    onChanged: (bool value) => _bloc.setCorner(),
                  ))
        ],
      );

  Widget heightWidget() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
            AppText(LocaleKeys.height.tr().toCapitalize(),
                style: typoW400.copyWith(
                    fontSize: 15.sp, color: colorText0.withOpacity(0.87))),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
                const SizedBox(width: 10),
                itemHeightWidget(3),
                itemHeightWidget(6),
                itemHeightWidget(9),
                itemHeightWidget(12),
                const SizedBox(width: 10),
              ],
        )
      ]);

  Widget itemHeightWidget(int value) =>
      BlocBuilder<CreateInfoRouteCubit, CreateInfoRouteState>(
          bloc: _bloc,
          builder: (c, state) => Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Radio<int>(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    activeColor: colorOrange100,
                    fillColor: value != state.height
                        ? MaterialStateProperty.all(colorWhite.withOpacity(0.6))
                        : null,
                    value: value,
                    groupValue: state.height,
                    onChanged: (int? value) {
                      if (widget.isEdit || widget.isPublish) return;
                      _bloc.changeHeight(value!);
                    },
                  ),
                  InkWell(
                      child: AppText('${value}m', style: typoW400),
                      onTap: () {
                        if (widget.isEdit || widget.isPublish) return;
                        _bloc.changeHeight(value);
                      })
                ],
              ));

  Widget gradeWidget(BuildContext context) =>
      BlocBuilder<CreateInfoRouteCubit, CreateInfoRouteState>(
          bloc: _bloc,
          builder: (c, state) => Center(
                  child: Container(
                height: 42.h,
                width: MediaQuery.of(context).size.width / 2.2,
                decoration: BoxDecoration(
                    border: Border.all(color: colorWhite),
                    borderRadius: BorderRadius.circular(13)),
                child: Row(
                  children: [
                    Expanded(
                        flex: 2,
                        child: InkWell(
                            onTap: () => _bloc.decrease(),
                            child: const Center(
                                child: Icon(Icons.remove, color: colorWhite)))),
                    Container(
                        height: MediaQuery.of(context).size.height,
                        width: 1,
                        color: colorWhite),
                    Expanded(
                        flex: 3,
                        child: Center(
                            child: AppText(Utils.getGrade(state.grade), style: typoContent))),
                    Container(
                        height: MediaQuery.of(context).size.height,
                        width: 1,
                        color: colorWhite),
                    Expanded(
                        flex: 2,
                        child: InkWell(
                            onTap: () => _bloc.increase(),
                            child: const Center(
                                child: Icon(Icons.add, color: colorWhite))))
                  ],
                ),
              )));

  Widget line() => Container(
      height: 0.7, width: MediaQuery.of(context).size.width, color: colorLine);

  Widget space({double height = 15}) => SizedBox(height: height);

  TextStyle get typoContent => typoW600.copyWith(
      height: 1.2, fontSize: 20.sp, color: colorText0.withOpacity(0.87));

  Widget routeNameWidget() =>
      BlocBuilder<CreateInfoRouteCubit, CreateInfoRouteState>(
          bloc: _bloc,
          builder: (c, state) => AppTextField(
              errorStyle: typoW400.copyWith(
                  color: colorSemanticRed100, fontSize: 10.sp),
              errorText: state.errorRouteName,
              controller: routeNameController,
              cursorColor: colorOrange100,
              textStyle: typoContent,
              decoration: InputDecoration(
                  prefixIconConstraints:
                      const BoxConstraints(maxWidth: 40, maxHeight: 40),
                  isDense: true,
                  contentPadding: EdgeInsets.only(bottom: globals.contentPadding),
                  filled: true,
                  enabled: true,
                  enabledBorder: border,
                  border: border,
                  focusedBorder: border,
                  disabledBorder: border)));

  Color get colorLine => HexColor('515151');

  UnderlineInputBorder get border => UnderlineInputBorder(
      borderSide: BorderSide(color: colorLine, width: 0.7));

  Widget titleWidget(String title) => AppText(title.toUpperCase(),
      style: typoW500.copyWith(
          fontSize: 10.sp, color: colorText0.withOpacity(0.6)));

  PreferredSizeWidget appbar(BuildContext context) =>
      appBarWidget(context: context, action: [
        Padding(
            padding: EdgeInsets.all(globals.contentPadding),
            child: GradientButton(
                height: 20.h,
                borderRadius: BorderRadius.circular(20),
                decoration: BoxDecoration(
                    gradient: Utils.backgroundGradientOrangeButton(),
                    borderRadius: BorderRadius.circular(20)),
                onTap: () => _bloc.publishOnclick(
                    widget.isPublish, routeNameController.text, context,widget.routeModel),
                widget: Row(
                  children: [
                    const SizedBox(width: 15),
                    AppText(
                        widget.isPublish
                            ? LocaleKeys.publish.tr()
                            : LocaleKeys.next.tr(),
                        style: typoW400),
                    const SizedBox(width: 3),
                    SvgPicture.asset(Assets.svg.fly),
                    const SizedBox(width: 12)
                  ],
                )))
      ]);
}
