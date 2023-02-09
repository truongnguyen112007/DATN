import 'package:base_bloc/base/base_state.dart';
import 'package:base_bloc/components/app_scalford.dart';
import 'package:base_bloc/components/app_text.dart';
import 'package:base_bloc/data/model/bill_model.dart';
import 'package:base_bloc/theme/app_styles.dart';
import 'package:base_bloc/theme/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BillDetail extends StatefulWidget {
  final int routePage;
  final BillModel model;

  const BillDetail({Key? key, required this.routePage, required this.model})
      : super(key: key);

  @override
  State<BillDetail> createState() => _BillDetailState();
}

class _BillDetailState extends BasePopState<BillDetail> {
  @override
  Widget buildWidget(BuildContext context) {
    return AppScaffold(
        backgroundColor: colorText5,
        appbar: AppBar(
          backgroundColor: colorGreen60,
          title: AppText(
            "Chi tiết hóa đơn",
            style: googleFont.copyWith(color: colorWhite),
          ),
        ),
        body: Container(
          height: 700,
          margin: EdgeInsets.all(15),
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
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  children: [
                    AppText("${widget.model.codeOrder} - ",style: googleFont.copyWith(color: colorBlue40,fontWeight: FontWeight.w600,fontSize: 18.sp)),
                    AppText(widget.model.nameCustomer,style: googleFont.copyWith(color: colorBlack,fontWeight: FontWeight.w600,fontSize: 18.sp))
                  ],
                ),
              ),
              Container(
                height: 1,
                color: colorGrey5,
              ),
              Padding(padding: EdgeInsets.all(8),child: Row(
                children: [
                  AppText("Sản phẩm đã mua",style: googleFont.copyWith(color: colorBlack,fontWeight: FontWeight.w600,fontSize: 16.sp),),
                  Spacer(),
                  AppText("Giá bán",style: googleFont.copyWith(color: colorBlack,fontWeight: FontWeight.w600,fontSize: 16.sp))
                ],),),
              Spacer(),
              Container(height: 1.h,color: colorGrey50,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(children: [
                  AppText("Tổng tiền",style: googleFont.copyWith(color: colorBlack,fontWeight: FontWeight.w600,fontSize: 16.sp)),
                  Spacer(),
                  AppText(widget.model.price,style: googleFont.copyWith(color: colorBlack,fontWeight: FontWeight.w600,fontSize: 16.sp))
                ],),
              )
            ],
          ),
        ));
  }

  @override
  int get tabIndex => widget.routePage;
}
