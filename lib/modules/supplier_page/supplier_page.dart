import 'package:base_bloc/base/base_state.dart';
import 'package:base_bloc/components/app_scalford.dart';
import 'package:base_bloc/components/app_text.dart';
import 'package:base_bloc/data/model/supplier_model.dart';
import 'package:base_bloc/modules/supplier_page/supplier_cubit.dart';
import 'package:base_bloc/modules/supplier_page/supplier_state.dart';
import 'package:base_bloc/theme/app_styles.dart';
import 'package:base_bloc/theme/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SupplierPage extends StatefulWidget {
  final int routePage;

  const SupplierPage({Key? key, required this.routePage}) : super(key: key);

  @override
  State<SupplierPage> createState() => _SupplierPageState();
}

class _SupplierPageState extends BasePopState<SupplierPage> {
  late SupplierCubit _bloc;

  @override
  void initState() {
    _bloc = SupplierCubit();
    super.initState();
  }

  @override
  Widget buildWidget(BuildContext context) {
    return AppScaffold(
      backgroundColor: colorText5,
      appbar: AppBar(
        backgroundColor: colorGreen60,
        title: AppText(
          "Nhà cung cấp",
          style: typoW600,
        ),
        actions: [
          Icon(Icons.search),
          Padding(
            padding: EdgeInsets.only(left: 15.w, right: 15.w),
            child: Icon(Icons.edit),
          ),
          Icon(Icons.add),
          SizedBox(
            width: 8.w,
          )
        ],
      ),
      body: BlocBuilder<SupplierCubit, SupplierState>(
        bloc: _bloc,
        builder: (c, s) => ListView.separated(
          shrinkWrap: true,
          padding: const EdgeInsets.only(top: 8),
          itemBuilder: (BuildContext context, int index) {
            return itemSupplier(fakeDataSupplier()[index]);
          },
          separatorBuilder: (BuildContext context, int index) => SizedBox(
            height: 5.h,
          ),
          itemCount: fakeDataSupplier().length,
        ),
      ),
    );
  }

  Widget itemSupplier(SupplierModel model) {
    return InkWell(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: colorPrimaryOrange40,
          boxShadow: const [
            BoxShadow(
              color: colorGrey30,
              spreadRadius: 1.3,
              blurRadius: 0.7,
            ),
          ],
        ),
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                    flex: 2,
                    child: AppText(
                      model.name,
                      style:
                          typoW700.copyWith(color: colorBlack, fontSize: 18.sp),
                    )),
                SizedBox(
                  width: 20.w,
                ),
                Icon(Icons.phone),
                AppText(
                  model.phone,
                  style: typoW600.copyWith(color: colorBlue40, fontSize: 15.sp),
                ),
                const Spacer(),
                const Icon(Icons.navigate_next)
              ],
            ),
            SizedBox(
              height: 15.h,
            ),
            Row(
              children: [
                AppText(
                  "Tổng tiền nhập hàng:",
                  style: typoW600.copyWith(color: colorBlack, fontSize: 15.sp),
                ),
                SizedBox(
                  width: 40.w,
                ),
                AppText(model.allMoney ?? "")
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  int get tabIndex => widget.routePage;
}
