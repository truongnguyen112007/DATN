import 'package:base_bloc/base/base_state.dart';
import 'package:base_bloc/components/app_scalford.dart';
import 'package:base_bloc/components/app_text.dart';
import 'package:base_bloc/data/model/goods_model.dart';
import 'package:base_bloc/theme/app_styles.dart';
import 'package:base_bloc/theme/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductsDetail extends StatefulWidget {
  final int routePage;
  final GoodsModel model;
  const ProductsDetail({Key? key, required this.routePage, required this.model}) : super(key: key);

  @override
  State<ProductsDetail> createState() => _ProductsDetailState();
}

class _ProductsDetailState extends BasePopState<ProductsDetail> {

  @override
  Widget buildWidget(BuildContext context) {
    return AppScaffold(
      backgroundColor: colorPrimaryBrand10,
      appbar: AppBar(
        backgroundColor: colorGreen60,
        actions: [
          Icon(Icons.edit),
          SizedBox(
            width: 20.w,
          ),
          Icon(Icons.more_horiz),
          SizedBox(
            width: 10.w,
          ),
        ],
      ),
        body:
        SingleChildScrollView(child: Column( crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FittedBox(fit:BoxFit.cover,child: Container(margin:const EdgeInsets.all(10),height: 100.h,width: 100.h,child: Image.asset(widget.model.image),)),
            Container(
              child: Column(
              children: [
                Container(padding: EdgeInsets.all(8),child: AppText(widget.model.name,textAlign: TextAlign.center,style: googleFont.copyWith(color: colorBlack,fontSize: 19.sp,fontWeight: FontWeight.w600),),color: colorWhite,width: MediaQuery.of(context).size.width,),
                Container(height: 1,color: colorGrey50,),
                item(text: "Mã hàng",text2: widget.model.codeProducts),
                item(text: "Mã vạch",text2: "456468223238"),
                item(text: "Loại hàng",text2: "Hàng hóa"),
                item(text: "Thương hiệu",text2: "xxx"),
                item(text: "Định mức tồn",text2: "0->40"),
                item(text: "Giá bán",text2: widget.model.price),
                item(text: "Giá vốn",text2: "2000"),
                item(text: "Tồn kho",isDivider: true,text2: widget.model.inventory),
                Container(margin:EdgeInsets.only(top: 20.h),height: 50.h,color: colorWhite,child: Row(
                  children: [SizedBox(width: 20.w,),Icon(Icons.check,color: colorBlue40,),SizedBox(width: 4.w,),AppText("Bán trực tiếp")],
                ),)
              ],
            ),)
          ],),));
  }

  Widget item({String? text,bool isDivider = false,String? text2}) {
    return Container(
      color: colorWhite,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(flex: 2,child: AppText(text!,style: googleFont.copyWith(color: colorGrey70,fontSize: 15.sp),)),
                Expanded(flex: 3,child: AppText(text2 ?? "",style: googleFont.copyWith(color: colorBlack,fontSize: 15.sp))),
              ],
            ),
          ),
          Visibility(visible: !isDivider,child: Container(margin: EdgeInsets.only(left: 140.w,bottom: 5.h),height: 1,color: colorGrey50,))
        ],
      ),
    );
  }

  @override
  int get tabIndex => widget.routePage;
}
