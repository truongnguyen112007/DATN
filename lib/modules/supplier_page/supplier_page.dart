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
      appbar: AppBar(backgroundColor: colorGreen60,title: AppText("Nhà cung cấp",style: typoW600,),actions: [
        Icon(Icons.search),
        Padding(
          padding:  EdgeInsets.only(left: 15.w,right: 15.w),
          child: Icon(Icons.edit),
        ),
        Icon(Icons.add),
        SizedBox(width: 8.w,)
      ],),
        body: BlocBuilder<SupplierCubit,SupplierState>(
          bloc: _bloc,
          builder: (c,s) =>
           ListView.separated(
            shrinkWrap: true,
            padding: const EdgeInsets.only(top: 10),
            itemBuilder: (BuildContext context, int index) {
              return itemSupplier(fakeDataSupplier()[index]);
            },
            separatorBuilder: (BuildContext context, int index) => SizedBox(
              height: 10.h,
            ),
            itemCount: fakeDataSupplier().length,
          ),
        ),);
  }

  Widget itemSupplier(SupplierModel model) {
    return InkWell(
      onTap: (){},
      child: Column(
        children: [
          Row(children: [
            AppText(model.name),
            SizedBox(width: 20.w,),
            AppText(model.phone),
            Spacer(),
            Icon(Icons.navigate_next)
          ],),
          Row(children: [
            AppText("Tong tien nhap hang"),
            SizedBox(width: 30.w,),
            AppText(model.allMoney ?? "")
          ],)
        ],
      ),
    );
  }

  @override
  int get tabIndex => widget.routePage;
}
