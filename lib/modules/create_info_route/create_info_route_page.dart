import 'package:base_bloc/base/hex_color.dart';
import 'package:base_bloc/components/app_scalford.dart';
import 'package:base_bloc/components/app_text.dart';
import 'package:base_bloc/components/app_text_field.dart';
import 'package:base_bloc/components/appbar_widget.dart';
import 'package:base_bloc/components/gradient_button.dart';
import 'package:base_bloc/data/globals.dart';
import 'package:base_bloc/data/model/routes_model.dart';
import 'package:base_bloc/extenstion/string_extension.dart';
import 'package:base_bloc/localizations/app_localazations.dart';
import 'package:base_bloc/modules/create_info_route/create_info_route_cubit.dart';
import 'package:base_bloc/modules/create_info_route/create_info_route_state.dart';
import 'package:base_bloc/theme/colors.dart';
import 'package:base_bloc/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../data/model/hold_set_model.dart';
import '../../gen/assets.gen.dart';
import '../../theme/app_styles.dart';

class CreateInfoRoutePage extends StatefulWidget {
  final List<HoldSetModel> lHoldSet;
  final RoutesModel? model;
  final bool isEdit;

  const CreateInfoRoutePage(
      {Key? key, required this.lHoldSet, this.model, this.isEdit = false})
      : super(key: key);

  @override
  State<CreateInfoRoutePage> createState() => _CreateInfoRoutePageState();
}

class _CreateInfoRoutePageState extends State<CreateInfoRoutePage> {
  late CreateInfoRouteCubit _bloc;
  var routeNameController = TextEditingController();

  @override
  void initState() {
    _bloc = CreateInfoRouteCubit(widget.lHoldSet);
    if(widget.model!=null) routeNameController.text = widget.model?.name??'';
    _bloc.setData(widget.model);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      padding: EdgeInsets.only(top: contentPadding, left: contentPadding),
      appbar: appbar(context),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          titleWidget(LocaleKeys.route_name),
          routeNameWidget(),
          space(),
          titleWidget(LocaleKeys.who_can_see_this_route),
          space(height: 6),
          Row(
            children: [
              SvgPicture.asset(Assets.svg.friend),
              const SizedBox(width: 10),
              AppText(LocaleKeys.friend, style: typoContent)
            ],
          ),
          space(),
          line(),
          space(),
          titleWidget(LocaleKeys.grade),
          space(),
          gradeWidget(context),
          space(),
          line(),
          space(),
          cornerWidget(),
          space(),
          line()
        ],
      ),
    );
  }

  Widget cornerWidget() => Row(
        children: [
          AppText(
            LocaleKeys.corner.toCapitalize(),
            style: typoW400.copyWith(fontSize: 16),
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
                            child: Center(
                                child: Icon(Icons.remove,
                                    color: colorBlack.withOpacity(0.87))))),
                    Container(
                        height: MediaQuery.of(context).size.height,
                        width: 1,
                        color: colorWhite),
                    Expanded(
                        flex: 3,
                        child: Center(
                            child: AppText(state.grade, style: typoContent))),
                    Container(
                        height: MediaQuery.of(context).size.height,
                        width: 1,
                        color: colorWhite),
                    Expanded(
                        flex: 2,
                        child: InkWell(
                            onTap: () => _bloc.increase(),
                            child: Center(
                                child: Icon(Icons.add,
                                    color: colorBlack.withOpacity(0.87)))))
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
                  contentPadding: EdgeInsets.only(bottom: contentPadding),
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
            padding: EdgeInsets.all(contentPadding),
            child: GradientButton(
                height: 20.h,
                borderRadius: BorderRadius.circular(20),
                decoration: BoxDecoration(
                    gradient: Utils.backgroundGradientOrangeButton(),
                    borderRadius: BorderRadius.circular(20)),
                onTap: () => _bloc.publishOnclick(routeNameController.text,context),
                widget: Row(
                  children: [
                    const SizedBox(width: 5),
                    AppText(LocaleKeys.publish, style: typoW400),
                    const SizedBox(width: 3),
                    SvgPicture.asset(Assets.svg.fly),
                    const SizedBox(width: 5),
                  ],
                )))
      ]);
}