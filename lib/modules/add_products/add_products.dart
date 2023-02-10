import 'package:base_bloc/base/base_state.dart';
import 'package:base_bloc/components/app_scalford.dart';
import 'package:base_bloc/data/globals.dart';
import 'package:base_bloc/data/model/goods_model.dart';
import 'package:base_bloc/theme/app_styles.dart';
import 'package:base_bloc/theme/colors.dart';
import 'package:base_bloc/utils/toast_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../components/app_text.dart';
import '../../gen/assets.gen.dart';

class AddProducts extends StatefulWidget {
  final int routePage;

  const AddProducts({Key? key, required this.routePage}) : super(key: key);

  @override
  State<AddProducts> createState() => _AddProductsState();
}

class _AddProductsState extends BasePopState<AddProducts> {
  final nameController = TextEditingController();
  final idController = TextEditingController();
  final barCodeController = TextEditingController();
  final inventoryLevelController = TextEditingController();
  final typeController = TextEditingController();
  final priceController = TextEditingController();
  final costController = TextEditingController();
  final inventoryController = TextEditingController();

  @override
  Widget buildWidget(BuildContext context) {
    return AppScaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: colorText5,
        appbar: AppBar(
          actions: [
            InkWell(
                onTap: () => addProduct(),
                child: const Icon(
                  Icons.save,
                  color: colorWhite,
                )),
            SizedBox(
              width: 10.w,
            )
          ],
          title: AppText(
            "Thêm sản phẩm",
            style: typoW400,
          ),
          backgroundColor: colorGreen60,
        ),
        body: Column(
          children: [
            image(),
            item(text: "Tên sản phẩm", text2: "", nameController),
            item(text: "Mã hàng", text2: "", idController),
            item(text: "Mã vạch", text2: "", barCodeController),
            item(text: "Loại hàng", text2: "", typeController),
            item(text: "Định mức tồn", text2: "", inventoryLevelController),
            item(
                text: "Giá bán",
                text2: "",
                priceController,
                textInputType: TextInputType.number),
            item(
                text: "Giá vốn",
                text2: "",
                costController,
                textInputType: TextInputType.number),
            item(
                text: "Tồn kho",
                text2: "",
                inventoryController,
                textInputType: TextInputType.number),
          ],
        ));
  }

  Widget image() {
    return Container(
      height: 100.h,
      width: MediaQuery.of(context).size.width,
      child: Icon(
        Icons.add_a_photo,
        size: 40,
      ),
      color: colorGrey5,
    );
  }

  Widget textField(TextEditingController controller,
      {TextInputType textInputType = TextInputType.text}) {
    return Expanded(
      flex: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 35.h,
            child: TextField(
              keyboardType: textInputType,
              // onTap: () => callback?.call(),
              // readOnly: isReadOnly,
              onChanged: (text) {},
              controller: controller,
              // keyboardType: inputType!,
              style: googleFont.copyWith(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  color: colorBlack),
              cursorColor: colorBlack,
              decoration: InputDecoration(
                // errorText: errorText ?? '',
                errorStyle: typoW400.copyWith(color: Colors.red),
                border: const UnderlineInputBorder(
                    borderSide: BorderSide(
                  color: colorWhite,
                )),
                focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: colorText65)),
                enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: colorText65)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget item(TextEditingController controller,
      {String? text, String? text2, TextInputType? textInputType}) {
    return Container(
      color: colorWhite,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                    flex: 2,
                    child: AppText(
                      text!,
                      style: googleFont.copyWith(
                          color: colorGrey70, fontSize: 15.sp),
                    )),
                textField(controller,
                    textInputType: textInputType ?? TextInputType.text)
                // Expanded(
                //     flex: 3,
                //     child: AppText(text2 ?? "",
                //         style: googleFont.copyWith(
                //             color: colorBlack, fontSize: 15.sp))),
              ],
            ),
          ),
          // Visibility(
          //     visible: !isDivider,
          //     child: Container(
          //       margin: EdgeInsets.only(left: 140.w, bottom: 5.h),
          //       height: 1,
          //       color: colorGrey50,
          //     ))
        ],
      ),
    );
  }

  void addProduct() {
    var productModel = ProductModel(
        id: idController.text,
        barCode: barCodeController.text,
        categoryId: 1029,
        name: nameController.text,
        type: typeController.text,
        inventoryLevel: inventoryLevelController.text,
        description: 'Test',
        price: int.parse(priceController.text),
        inventory: int.parse(inventoryController.text),
        image: Assets.png.bb.path,
        cost: costController.text,
        status: 'new',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now());
    fakeDataProducts.add(productModel);
    toast("Thêm sản phẩm thành công");
  }

  @override
  int get tabIndex => widget.routePage;
}
