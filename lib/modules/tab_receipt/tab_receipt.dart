import 'package:base_bloc/components/app_text.dart';
import 'package:base_bloc/data/model/calender_param.dart';
import 'package:base_bloc/modules/tab_receipt/tab_receipt_cubit.dart';
import 'package:base_bloc/modules/tab_receipt/tab_receipt_state.dart';
import 'package:base_bloc/theme/app_styles.dart';
import 'package:base_bloc/theme/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import '../../components/app_scalford.dart';
import '../../data/model/bill_model.dart';
import '../../gen/assets.gen.dart';

class TabReceipt extends StatefulWidget {
  const TabReceipt({Key? key}) : super(key: key);

  @override
  State<TabReceipt> createState() => _TabReceiptState();
}

class _TabReceiptState extends State<TabReceipt>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late TabController _tabController;
  late final TabReceiptCubit _bloc;

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);
    _bloc = TabReceiptCubit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
        resizeToAvoidBottomInset: false,
        appbar : AppBar(
          backgroundColor: colorGreen60,
          title: AppText(
            "Hóa đơn",
            style: googleFont.copyWith(
                color: colorSecondary10,
                fontSize: 20.sp,
                fontWeight: FontWeight.w700),
          ),
          actions: [
            const Icon(
              Icons.search,
              color: colorWhite,
            ),
            SizedBox(width: 10.w),
            const Icon(
              Icons.swap_vert,
              color: colorWhite,
            ),
            SizedBox(width: 10.w),
            const Icon(
              Icons.add,
              color: colorWhite,
            ),
            SizedBox(width: 10.w),
          ],
        ),
        backgroundColor: colorText5,
        body: Column(
          children: [calender(), listItems()],
        ));
  }

  Widget calender() {
    return BlocBuilder<TabReceiptCubit, TabReceiptState>(
      bloc: _bloc,
      builder: (c, s) => InkWell(
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
                spreadRadius: 1.2,
                blurRadius: 0.3,
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

  Widget listItems() {
    return BlocBuilder<TabReceiptCubit, TabReceiptState>(
      bloc: _bloc,
      builder: (c, s) => Expanded(
          child: ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.only(top: 10),
              itemBuilder: (BuildContext context, int index) {
                return itemBill(fakeDataBill()[index]);
              },
              separatorBuilder: (BuildContext context, int index) => SizedBox(),
              itemCount: s.calender?.name == "Hôm nay"
                  ? fakeDataBill().length - 6
                  : s.calender?.name == "Hôm qua"
                      ? fakeDataBill().length - 8
                      : fakeDataBill().length)),
    );
  }

  Widget itemBill(BillModel model) {
    return BlocBuilder<TabReceiptCubit, TabReceiptState>(
      bloc: _bloc,
      builder: (c, s) => InkWell(
        onTap: () {
          _bloc.openBillDetail(context,model);
        },
        child: Container(
          margin: EdgeInsets.only(bottom: 10.h, left: 10.w, right: 10.w),
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
                    AppText(
                      "${model.codeOrder}-",
                      style: googleFont.copyWith(
                          color: colorBlack, fontWeight: FontWeight.w600),
                    ),
                    AppText(model.nameCustomer,
                        style: googleFont.copyWith(
                            color: colorBlack, fontWeight: FontWeight.w600))
                  ],
                ),
              ),
              Container(
                height: 0.5,
                color: colorGrey50,
              ),
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 15.w, top: 5, bottom: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          "Số lượng sản phẩm: ${model.amount}",
                          style: googleFont.copyWith(color: colorGrey80),
                        ),
                        AppText("Tổng hóa đơn : ${model.price} VNĐ",
                            style: googleFont.copyWith(color: colorGrey80))
                      ],
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.navigate_next)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }


  @override
  bool get wantKeepAlive => true;
}
