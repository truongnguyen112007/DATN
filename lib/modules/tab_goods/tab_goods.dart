import 'dart:async';
import 'dart:io';
import 'package:base_bloc/components/app_circle_loading.dart';
import 'package:base_bloc/components/app_not_data_widget.dart';
import 'package:base_bloc/components/app_scalford.dart';
import 'package:base_bloc/modules/tab_goods/tab_goods_cubit.dart';
import 'package:base_bloc/modules/tab_goods/tab_goods_state.dart';
import 'package:base_bloc/modules/tab_overview/tab_overview_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import '../../components/app_text.dart';
import '../../data/model/goods_model.dart';
import '../../gen/assets.gen.dart';
import '../../theme/app_styles.dart';
import '../../theme/colors.dart';

class TabGoods extends StatefulWidget {
  const TabGoods({Key? key}) : super(key: key);

  @override
  State<TabGoods> createState() => _TabGoodsState();
}

class _TabGoodsState extends State<TabGoods> with TickerProviderStateMixin {
  var isShowMap = false;

  late TabGoodsCubit _bloc;

  @override
  void initState() {
    _bloc = TabGoodsCubit();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
        floatingActionButton: BlocBuilder<TabGoodsCubit, TabGoodsState>(
          bloc: _bloc,
          builder: (c, s) => SpeedDial(
              icon: Icons.add,
              activeIcon: Icons.close,
              backgroundColor: colorGreen60,
              children: [
                SpeedDialChild(
                    onTap: () {
                      _bloc.onClickAddProducts(context);
                    },
                    child: Icon(Icons.add),
                    label: "Thêm sản phẩm",
                    labelStyle: typoW600.copyWith(color: colorBlack),
                    backgroundColor: Colors.yellow),
                SpeedDialChild(
                    child: Icon(Icons.add),
                    label: "Thêm dịch vụ",
                    labelStyle: typoW600.copyWith(color: colorBlack),
                    backgroundColor: Colors.yellow)
              ]),
        ),
        appbar: AppBar(
            backgroundColor: colorGreen60,
            title: AppText("Hàng hóa",
                style: googleFont.copyWith(
                    color: colorSecondary10, fontWeight: FontWeight.w700)),
            actions: [
              const Icon(
                Icons.search,
                color: colorWhite,
              ),
              SizedBox(
                width: 10.w,
              ),
              const Icon(
                Icons.swap_vert,
                color: colorWhite,
              ),
              SizedBox(
                width: 10.w,
              ),
            ]),
        backgroundColor: colorText5,
        body: Column(
          children: [
            Container(
              height: 10.w,
              color: colorGrey45,
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      AppText("15",
                          style: googleFont.copyWith(color: colorBlue40)),
                      AppText(" hàng hóa - Tổng tồn ",
                          style: googleFont.copyWith(color: colorGrey70)),
                      AppText("338",
                          style: googleFont.copyWith(color: colorBlue40)),
                      const Spacer(),
                      Row(
                        children: [
                          AppText(
                            "Giá bán",
                            style: googleFont.copyWith(color: colorGrey70),
                          ),
                          const Icon(Icons.arrow_drop_down_outlined)
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 0.5,
                  color: colorGrey50,
                )
              ],
            ),
            Expanded(
              child: BlocBuilder<TabGoodsCubit, TabGoodsState>(
                  bloc: _bloc,
                  builder: (c, state) => /*state.status == FeedStatus.initial
                      ? Center(
                          child: AppCircleLoading(),
                        )
                      : state.status == FeedStatus.failure
                          ? Center(child: AppNotDataWidget())
                          :*/ ListView.separated(
                              shrinkWrap: true,
                              padding: const EdgeInsets.only(top: 10),
                              itemBuilder: (BuildContext context, int index) {
                                return itemProducts(fakeDataProducts()[index]);
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) => SizedBox(
                                height: 10.h,
                              ),
                              itemCount: fakeDataProducts().length,
                            )),
            )
          ],
        ));
  }

  Widget itemProducts(ProductModel model) {
    return BlocBuilder<TabGoodsCubit, TabGoodsState>(
      bloc: _bloc,
      builder: (c, s) => InkWell(
        onTap: () {
          _bloc.openProductDetail(context, model);
        },
        child: Container(
          margin: EdgeInsets.only(left: 15.w),
          child: Column(
            children: [
              Row(
                children: [
                  FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                        height: 60,
                        width: 60,
                        child: Image.asset(model.image??''),
                      )),
                  SizedBox(
                    width: 10.w,
                  ),
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(model.name,
                          style: googleFont.copyWith(
                              color: colorBlack,
                              fontWeight: FontWeight.w600,
                              fontSize: 16.sp)),
                      SizedBox(
                        height: 3.h,
                      ),
                      AppText(model.id.toString(),
                          style: googleFont.copyWith(
                              color: colorGrey70,
                              fontWeight: FontWeight.w500,
                              fontSize: 13.sp))
                    ],
                  )),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      AppText(
                        model.price.toString(),
                        style: googleFont.copyWith(
                            color: colorBlack,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      AppText(
                        model.inventory.toString(),
                        style: googleFont.copyWith(
                            color: colorBlue40, fontSize: 15.sp),
                      )
                    ],
                  ),
                  SizedBox(
                    width: 10.w,
                  )
                ],
              ),
              SizedBox(
                height: 20.h,
              ),
              Container(
                height: 0.5,
                color: colorGrey50,
              )
            ],
          ),
        ),
      ),
    );
  }
}
