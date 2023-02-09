import 'package:base_bloc/base/base_state.dart';
import 'package:base_bloc/components/app_scalford.dart';
import 'package:base_bloc/theme/app_styles.dart';
import 'package:base_bloc/theme/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../components/app_text.dart';

class AddProducts extends StatefulWidget {
  final int routePage;

  const AddProducts({Key? key, required this.routePage}) : super(key: key);

  @override
  State<AddProducts> createState() => _AddProductsState();
}

class _AddProductsState extends BasePopState<AddProducts> {
  @override
  Widget buildWidget(BuildContext context) {
    return AppScaffold(
      backgroundColor: colorText5,
        appbar: AppBar(
      title: AppText("Thêm sản phẩm",style: typoW400,),
      backgroundColor: colorGreen60,
    ), body: Column(
      children: [
        image()
      ],
    ));
  }

  Widget image() {
    return Container(height: 100.h,color: colorGrey5,);
  }


  @override
  int get tabIndex => widget.routePage;
}
