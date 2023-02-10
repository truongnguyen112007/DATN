import 'package:base_bloc/base/base_state.dart';
import 'package:base_bloc/components/app_scalford.dart';
import 'package:base_bloc/components/app_text.dart';
import 'package:base_bloc/data/globals.dart';
import 'package:base_bloc/data/model/goods_model.dart';
import 'package:base_bloc/theme/app_styles.dart';
import 'package:base_bloc/theme/colors.dart';
import 'package:base_bloc/utils/log_utils.dart';
import 'package:base_bloc/utils/toast_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductsDetail extends StatefulWidget {
  final int routePage;
  final ProductModel model;
  final int currentIndex;

  const ProductsDetail(
      {Key? key,
      required this.routePage,
      required this.model,
      required this.currentIndex})
      : super(key: key);

  @override
  State<ProductsDetail> createState() => _ProductsDetailState();
}

class _ProductsDetailState extends BasePopState<ProductsDetail> {
  var idController = TextEditingController();
  var codeController = TextEditingController();
  var typeController = TextEditingController();
  var brandController = TextEditingController();
  var inventoryLevelController = TextEditingController();
  var priceController = TextEditingController();
  var costPriceController = TextEditingController();
  var inventoryController = TextEditingController();

  @override
  void initState() {
    setData();
    super.initState();
  }

  void setData() {
    idController.text = widget.model.id;
    codeController.text = widget.model.cost;
    typeController.text = widget.model.type;
    brandController.text = widget.model.barCode;
    inventoryLevelController.text = widget.model.inventoryLevel.toString();
    priceController.text = widget.model.price.toString();
    costPriceController.text = widget.model.cost;
    inventoryController.text = widget.model.inventory.toString();
  }

  @override
  Widget buildWidget(BuildContext context) {
    return AppScaffold(
        backgroundColor: colorPrimaryBrand10,
        appbar: AppBar(
          backgroundColor: colorGreen60,
          actions: [
            InkWell(
              child: Icon(Icons.edit),
              onTap: () => editProductOnclick(),
            ),
            SizedBox(
              width: 20.w,
            ),
            Icon(Icons.more_horiz),
            SizedBox(
              width: 10.w,
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FittedBox(
                  fit: BoxFit.cover,
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    height: 100.h,
                    width: 100.h,
                    child: Image.asset(widget.model.image),
                  )),
              Container(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      color: colorWhite,
                      width: MediaQuery.of(context).size.width,
                      child: AppText(
                        widget.model.name,
                        textAlign: TextAlign.center,
                        style: googleFont.copyWith(
                            color: colorBlack,
                            fontSize: 19.sp,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Container(
                      height: 1,
                      color: colorGrey50,
                    ),
                    item(
                        text: "Mã hàng",
                        text2: widget.model.id.toString(),
                        controller: idController),
                    item(
                        text: "Mã vạch",
                        text2: widget.model.barCode,
                        controller: codeController),
                    item(
                        text: "Loại hàng",
                        text2: widget.model.type,
                        controller: typeController),
                    item(
                        text: "Thương hiệu",
                        text2: "xxx",
                        controller: brandController),
                    item(
                        text: "Định mức tồn",
                        text2: widget.model.inventoryLevel,
                        controller: inventoryLevelController),
                    item(
                        text: "Giá bán",
                        text2: widget.model.price.toString(),
                        controller: priceController),
                    item(
                        text: "Giá vốn",
                        text2: widget.model.cost,
                        controller: costPriceController),
                    item(
                        text: "Tồn kho",
                        isDivider: true,
                        text2: widget.model.inventory.toString(),
                        controller: inventoryLevelController),
                    Container(
                      margin: EdgeInsets.only(top: 20.h),
                      height: 50.h,
                      color: colorWhite,
                      child: Row(
                        children: [
                          SizedBox(
                            width: 20.w,
                          ),
                          Icon(
                            Icons.check,
                            color: colorBlue40,
                          ),
                          SizedBox(
                            width: 4.w,
                          ),
                          AppText("Bán trực tiếp")
                        ],
                      ),
                    )
                  ],
                ),
              ),
              // textField()
            ],
          ),
        ));
  }

  void editProductOnclick() {
    var productModel = widget.model.copyOff(
        id: idController.text,
        barCode: codeController.text,
        type: typeController.text,
        inventoryLevel: inventoryLevelController.text,
        price: int.parse(priceController.text),
        cost: costPriceController.text,
        inventory: int.parse(inventoryController.text));
    fakeDataProducts[widget.currentIndex] = productModel;
    toast("Update thông tin thành công");
  }

  Widget item(
      {String? text,
      bool isDivider = false,
      String? text2,
      required TextEditingController controller}) {
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
                textField(controller)
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

  Widget textField(TextEditingController controller) {
    return Expanded(
      flex: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 35.h,
            child: TextField(
              controller: controller,
              // onTap: () => callback?.call(),
              // readOnly: isReadOnly,
              onChanged: (text) {},
              // controller: controller,
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

  @override
  int get tabIndex => widget.routePage;
}
