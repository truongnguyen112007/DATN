import 'package:base_bloc/base/base_state.dart';
import 'package:base_bloc/components/app_circle_loading.dart';
import 'package:base_bloc/components/app_scalford.dart';
import 'package:base_bloc/components/app_text.dart';
import 'package:base_bloc/components/app_text_field.dart';
import 'package:base_bloc/components/appbar_widget.dart';
import 'package:base_bloc/config/constant.dart';
import 'package:base_bloc/data/globals.dart';
import 'package:base_bloc/data/model/address_model.dart';
import 'package:base_bloc/modules/filter_address/filter_addess_cubit.dart';
import 'package:base_bloc/modules/filter_address/filter_address_state.dart';
import 'package:base_bloc/router/router_utils.dart';
import 'package:base_bloc/theme/app_styles.dart';
import 'package:base_bloc/theme/colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rxdart/rxdart.dart';

import '../../localization/locale_keys.dart';
import '../persons_page/persons_page_state.dart';


class FilterAddressPage extends StatefulWidget {
  const FilterAddressPage({Key? key}) : super(key: key);

  @override
  State<FilterAddressPage> createState() => _FilterAddressPageState();
}

class _FilterAddressPageState extends BasePopState<FilterAddressPage> {
  late FilterAddressCubit _bloc;
  final searchOnChange = BehaviorSubject<String>();
  final _scrollController = ScrollController();

  @override
  void initState() {
    _bloc = FilterAddressCubit();
    listenSearch();
    paging();
    super.initState();
  }

  void paging() {
    _scrollController.addListener(() {
      var maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.offset;
      if (currentScroll >= (maxScroll * 0.9)) {
        _bloc.getAddressDefault(isPaging: true);
      }
    });
  }

  void listenSearch() => searchOnChange
      .debounceTime(const Duration(seconds: 1))
      .listen((query) => _bloc.search(query));

  @override
  Widget buildWidget(BuildContext context) {
    return AppScaffold(
      resizeToAvoidBottomInset: false,
      padding: EdgeInsets.all(contentPadding),
      backgroundColor: colorBackgroundColor,
      body: RefreshIndicator(
        child: SingleChildScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                LocaleKeys.reclimb_available_in.tr().toUpperCase(),
                style: typoW600.copyWith(
                  fontSize: 11.sp,
                  color: colorText0.withOpacity(0.87),
                ),
              ),
              itemSpace(),
              BlocBuilder<FilterAddressCubit, FilterAddressState>(
                builder: (c, state) {
                  switch (state.status) {
                    case StatusType.refresh:
                    case StatusType.initial:
                    case StatusType.search:
                      return Container(
                        height: MediaQuery.of(context).size.height / 1.4,
                        alignment: Alignment.center,
                        child: const AppCircleLoading(),
                      );
                    case StatusType.success:
                      return lAddressWidget(state);
                    default:
                      return const SizedBox();
                  }
                },
                bloc: _bloc,
              ),
            ],
          ),
        ),
        onRefresh: () async => _bloc.onRefresh(),
      ),
      appbar: appbar(context),
    );
  }

  Widget itemSpace() => const SizedBox(
        height: 10,
      );

  Widget lAddressWidget(FilterAddressState state) => ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (c, i) => (i == state.lAddress.length)
          ? const Center(
              child: AppCircleLoading(),
            )
          : itemAddress(c, state.lAddress[i]),
      separatorBuilder: (c, i) => const SizedBox(
            height: 10,
          ),
      itemCount: !state.isReadEnd && state.isLoading
          ? state.lAddress.length + 1
          : state.lAddress.length);

  Widget itemAddress(BuildContext context, AddressModel model) => InkWell(
        child: Container(
          alignment: Alignment.center,
          height: 72.h,
          decoration: BoxDecoration(
              color: colorBlack90, borderRadius: BorderRadius.circular(13)),
          padding: EdgeInsets.all(contentPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                model.city,
                style: typoW600.copyWith(
                    fontSize: 20.sp, color: colorText0.withOpacity(0.87)),
              ),
              const SizedBox(
                height: 3,
              ),
              Row(
                children: [
                  AppText(
                    '${model.country}          ',
                    style: typoW400.copyWith(
                        color: colorText0.withOpacity(0.66), fontSize: 14.sp),
                  ),
                  const Icon(
                    Icons.brightness_1,
                    size: 5,
                    color: colorText45,
                  ),
                  AppText(
                    '  ${model.distance}km',
                    style: typoW400.copyWith(
                        color: colorText0.withOpacity(0.66), fontSize: 14.sp),
                  )
                ],
              )
            ],
          ),
        ),
        onTap: () {
          RouterUtils.pop(context, result: model);
        },
      );

  PreferredSizeWidget appbar(BuildContext context) => appBarWidget(
      backgroundColor: colorBackgroundColor,
      context: context,
      titleSpacing: 0,
      leadingWidth: 40.w,
      toolbarHeight: 50.h,
      title: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 100),
        child: AppTextField(
          onChanged: (text) => searchOnChange.add(text),
          isShowErrorText: false,
          textStyle: typoW400.copyWith(color: colorText0, fontSize: 14.5.sp),
          cursorColor: Colors.white60,
          decoration: decorTextField.copyWith(
              prefixIcon: const Icon(
                Icons.search,
                color: colorText45,
              ),
              hintStyle: typoW400.copyWith(
                  color: colorText0.withOpacity(0.6), fontSize: 14.5.sp),
              hintText: LocaleKeys.find_city.tr(),
              contentPadding: EdgeInsets.all(15.h),
              fillColor: colorBlack10,
              border: border,
              enabledBorder: border,
              focusedBorder: border),
        ),
      ));
  var border = const OutlineInputBorder(
    borderSide: BorderSide(color: Colors.transparent),
    borderRadius: BorderRadius.all(Radius.circular(50)),
  );

  @override
  int get tabIndex => BottomNavigationConstant.TAB_RESERVATIONS;
}
