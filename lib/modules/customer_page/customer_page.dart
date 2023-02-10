import 'package:base_bloc/base/base_state.dart';
import 'package:base_bloc/components/app_scalford.dart';
import 'package:base_bloc/theme/app_styles.dart';
import 'package:base_bloc/theme/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../components/app_text.dart';
import '../../data/model/customer_model.dart';
import 'customer_cubit.dart';
import 'customer_state.dart';

class CustomerPage extends StatefulWidget {
  final int routePage;

  const CustomerPage({Key? key, required this.routePage}) : super(key: key);

  @override
  State<CustomerPage> createState() => _CustomerPageState();
}

class _CustomerPageState extends BasePopState<CustomerPage> {
  late CustomerCubit _bloc;

  @override
  void initState() {
    _bloc = CustomerCubit();
    super.initState();
  }

  @override
  Widget buildWidget(BuildContext context) {
    return AppScaffold(
      backgroundColor: colorText5,
      appbar: AppBar(
        backgroundColor: colorGreen60,
        title: AppText(
          "Khách hàng",
          style: typoW600,
        ),
      ),
      body: BlocBuilder<CustomerCubit, CustomerState>(
        bloc: _bloc,
        builder: (c, s) => ListView.separated(
          shrinkWrap: true,
          padding: const EdgeInsets.only(top: 8),
          itemBuilder: (BuildContext context, int index) {
            return itemCustomer(fakeDataCustomer()[index]);
          },
          separatorBuilder: (BuildContext context, int index) => SizedBox(
            height: 5.h,
          ),
          itemCount: fakeDataCustomer().length,
        ),
      ),
    );
  }

  Widget itemCustomer(CustomerModel model) {
    return InkWell(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: colorPrimaryBlue20,
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
              ],
            ),
            SizedBox(
              height: 15.h,
            ),
            Row(
              children: [
                AppText(
                  "Tổng tiền mua hàng:",
                  style: typoW600.copyWith(color: colorBlack, fontSize: 15.sp),
                ),
                Spacer(),
                AppText(
                  model.price.toString(),
                  style:
                      typoW600.copyWith(color: colorGreen50, fontSize: 16.sp),
                )
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
