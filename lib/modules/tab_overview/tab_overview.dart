import 'package:base_bloc/modules/tab_overview/tab_overview_cubit.dart';
import 'package:base_bloc/modules/tab_overview/tab_overview_state.dart';
import 'package:base_bloc/theme/app_styles.dart';
import 'package:base_bloc/theme/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../components/app_scalford.dart';
import '../../components/app_text.dart';
import '../../data/model/goods_model.dart';
import '../tab_goods/tab_goods_cubit.dart';

class TabOverView extends StatefulWidget {
  const TabOverView({Key? key}) : super(key: key);

  @override
  State<TabOverView> createState() => _TabOverViewState();
}

class _TabOverViewState extends State<TabOverView>
    with AutomaticKeepAliveClientMixin {
  final _scrollController = ScrollController();
  late final TabOverViewCubit _bloc;

  @override
  void initState() {
    _bloc = TabOverViewCubit();
    // _bloc.checkLocationPermission();
    paging();
    super.initState();
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  void paging() {
    _scrollController.addListener(() {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.offset;
      if (currentScroll >= (maxScroll * 0.9)) _bloc.getFeed(isPaging: true);
    });
  }

  void jumToTop() => _scrollController.animateTo(0,
      duration: const Duration(seconds: 2),
      curve: Curves.fastLinearToSlowEaseIn);

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
        appbar: AppBar(
          backgroundColor: colorGreen60,
          title: Row(
            children: [
              Icon(
                Icons.account_balance_wallet,
                color: colorSecondary10,
              ),
              SizedBox(
                width: 10.w,
              ),
              AppText(
                "Smart Management",
                style: googleFont.copyWith(
                    color: colorSecondary10, fontWeight: FontWeight.w700),
              )
            ],
          ),
          actions: [
            const Icon(
              Icons.email,
              color: colorWhite,
            ),
            SizedBox(
              width: 15.w,
            )
          ],
        ),
        backgroundColor: colorText5,
        body: Column(
          children: [
            calender(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    billandreturngoods(),
                    orderandinventory(),
                    products()
                  ],
                ),
              ),
            )
          ],
        ));
  }

  Widget calender() {
    return BlocBuilder<TabOverViewCubit,TabOverViewState>(
      bloc: _bloc,
      builder: (c,s) =>
       InkWell(
        splashColor: colorTransparent,
        onTap: () {
          _bloc.onClickCalender(context);
        },
        child: Container(
          margin: EdgeInsets.only(bottom: 5.h),
          height: 45,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            color: colorWhite,
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(20),
                bottomLeft: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: colorGrey30,
                spreadRadius: 2.7,
                blurRadius: 0.5,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                const Icon(
                  Icons.calendar_month,
                  color: colorBlue60,
                ),
                SizedBox(
                  width: 10.w,
                ),
                AppText(
                  s.calender?.name ?? 'Hôm nay',
                  style: googleFont.copyWith(
                      color: colorBlack, fontWeight: FontWeight.w500),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget billandreturngoods() {
    return Padding(
      padding: EdgeInsets.only(left: 7.w, right: 7.w, top: 8.h),
      child: Container(
        height: 60.h,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: colorWhite,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: colorGrey30,
              spreadRadius: 1.2,
              blurRadius: 0.3,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 8.h),
              child: Column(
                children: [
                  AppText(
                    "Hóa đơn",
                    style: googleFont.copyWith(
                        color: colorBlack,
                        fontWeight: FontWeight.w700,
                        fontSize: 15.sp),
                  ),
                  AppText(
                    "10",
                    style: googleFont.copyWith(
                        color: colorBlue60,
                        fontWeight: FontWeight.w700,
                        fontSize: 15.sp),
                  ),
                ],
              ),
            ),
            Container(
              height: 50.h,
              color: colorBlue60,
              width: 2.w,
            ),
            Padding(
              padding: EdgeInsets.only(top: 8.h),
              child: Column(
                children: [
                  AppText(
                    "Trả hàng",
                    style: googleFont.copyWith(
                        color: colorBlack,
                        fontWeight: FontWeight.w700,
                        fontSize: 15.sp),
                  ),
                  AppText(
                    "0",
                    style: googleFont.copyWith(
                        color: colorBlue60,
                        fontWeight: FontWeight.w700,
                        fontSize: 15.sp),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget orderandinventory() {
    return Padding(
      padding: EdgeInsets.only(top: 18.h, left: 7.w, right: 7.w),
      child: Container(
        height: 120.h,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: colorWhite,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: colorGrey30,
              spreadRadius: 1.2,
              blurRadius: 0.3,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        "Đặt hàng",
                        style: googleFont.copyWith(
                            color: colorGreen60,
                            fontWeight: FontWeight.w700,
                            fontSize: 15.sp),
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      AppText("10" + "  phiếu đặt",
                          style: googleFont.copyWith(
                              color: colorBlack,
                              fontWeight: FontWeight.w200,
                              fontSize: 14.sp)),
                    ],
                  ),
                  const Spacer(),
                  AppText("0",
                      style: googleFont.copyWith(
                          color: colorGreen60,
                          fontWeight: FontWeight.w700,
                          fontSize: 14.sp))
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 5.h, bottom: 5.h),
                height: 1,
                color: colorGrey50,
              ),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText("Tồn kho",
                          style: googleFont.copyWith(
                              color: colorRed80,
                              fontWeight: FontWeight.w700,
                              fontSize: 15.sp)),
                      SizedBox(
                        height: 5.h,
                      ),
                      AppText("338" + "  sản phẩm",
                          style: googleFont.copyWith(
                              color: colorBlack,
                              fontWeight: FontWeight.w200,
                              fontSize: 14.sp))
                    ],
                  ),
                  const Spacer(),
                  AppText("3,412,000",
                      style: googleFont.copyWith(
                          color: colorRed80,
                          fontWeight: FontWeight.w700,
                          fontSize: 15.sp))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget products() {
    return Padding(
      padding: EdgeInsets.only(left: 7.w, right: 7.w, top: 18.h, bottom: 10.h),
      child: Container(
        height: 450.h,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(boxShadow: const [
          BoxShadow(
            color: colorGrey30,
            spreadRadius: 1.2,
            blurRadius: 0.3,
          ),
        ], color: colorWhite, borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: AppText(
                "Sản phẩm bán chạy",
                style: googleFont.copyWith(
                    color: colorYellow70, fontWeight: FontWeight.w700),
              ),
            ),
            Expanded(child: ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.only(top: 10),
              itemBuilder: (BuildContext context, int index) {
                return itemProducts(fakeDataProducts()[index]);
              },
              separatorBuilder: (BuildContext context, int index) => SizedBox(
                height: 10.h,
              ),
              itemCount: fakeDataProducts().length,
            ))
          ],
        ),
      ),
    );
  }

  Widget itemProducts (GoodsModel model) {
    return Container(
      margin: EdgeInsets.only(left: 15.w),
      child: Column(
        children: [
          Row(
            children: [
              FittedBox(fit: BoxFit.cover,child: SizedBox(height: 60,width: 60,child: Image.asset(model.image),)),
              SizedBox(width: 10.w,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(model.name,style: googleFont.copyWith(color: colorBlack,fontWeight: FontWeight.w600,fontSize: 16.sp)),
                  SizedBox(height: 3.h,),
                  AppText(model.codeProducts,style: googleFont.copyWith(color: colorGrey70,fontWeight: FontWeight.w500,fontSize: 13.sp))
                ],
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AppText(model.price,style: googleFont.copyWith(color: colorBlack,fontSize: 16.sp,fontWeight: FontWeight.w500),),
                  SizedBox(height: 15.h,),
                  AppText(model.inventory,style: googleFont.copyWith(color: colorBlue40,fontSize: 15.sp),)
                ],
              ),
              SizedBox(width: 10.w,)
            ],
          ),
          SizedBox(height: 20.h,),
          Container(height: 0.5,color: colorGrey50,)
        ],
      ),
    );
  }

  bool get wantKeepAlive => true;
}
