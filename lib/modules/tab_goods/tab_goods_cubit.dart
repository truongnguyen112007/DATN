import 'package:base_bloc/data/repository/user_repository.dart';
import 'package:base_bloc/modules/tab_goods/tab_goods_state.dart';
import 'package:base_bloc/modules/tab_overview/tab_overview_state.dart';
import 'package:base_bloc/router/router.dart';
import 'package:base_bloc/utils/log_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_elves/flutter_blue_elves.dart';
import 'package:geolocator/geolocator.dart';

import '../../config/constant.dart';
import '../../data/model/goods_model.dart';
import '../../data/model/places_model.dart';
import '../../gen/assets.gen.dart';
import '../../router/router_utils.dart';

class TabGoodsCubit extends Cubit<TabGoodsState> {
  var repository = UserRepository();

  TabGoodsCubit() : super(const TabGoodsState()) {
    getAllProduct();
  }

  void getAllProduct() async {
    var response = await repository.getAllProduct();
    if (response.error != null) {
      emit(state.copyOf(status: FeedStatus.failure));
    } else {
      var lresponse = productModelFromJson(response.data['data']);
      logE("TAG lRESPONSE: ${lresponse.length}");
      emit(state.copyOf(
          status: FeedStatus.success,
          lProduct: productModelFromJson(response.data['data'])));
    }
  }

  void onClickAddProducts(BuildContext context) {
    RouterUtils.pushClimb(
        context: context,
        route: GoodsRouters.routesAddProducts,
        argument: BottomNavigationConstant.TAB_CLIMB);
  }

  void openProductDetail(BuildContext context, ProductModel model) {
    RouterUtils.pushClimb(
        context: context,
        route: GoodsRouters.routesProductsDetail,
        argument: [BottomNavigationConstant.TAB_CLIMB, model]);
  }
}

Future<bool> checkTurnOnGps() async =>
    await Geolocator.isLocationServiceEnabled();

List<ProductModel> fakeDataProducts() => [
      ProductModel(image: "",
        id: 1,
        name: "Hộp phở bò",
        price: 100000,
        shopId: 1,
        categoryId: 1,
        sku: '',
        upcCode: '',
        description: '',
        inStock: 11,
        unit: '',
        status: '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      ProductModel(image: "",
        id: 1,
        name: "Cocacola",
        price: 100000,
        shopId: 1,
        categoryId: 1,
        sku: '',
        upcCode: '',
        description: '',
        inStock: 11,
        unit: '',
        status: '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      ProductModel(image: "",
        id: 1,
        name: "Mì ba miền",
        price: 100000,
        shopId: 1,
        categoryId: 1,
        sku: '',
        upcCode: '',
        description: '',
        inStock: 11,
        unit: '',
        status: '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      ProductModel(image: "",
        id: 1,
        name: "Thịt bò khô",
        price: 100000,
        shopId: 1,
        categoryId: 1,
        sku: '',
        upcCode: '',
        description: '',
        inStock: 11,
        unit: '',
        status: '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      ProductModel(image: "",
        id: 1,
        name: "Kẹo dynamite",
        price: 100000,
        shopId: 1,
        categoryId: 1,
        sku: '',
        upcCode: '',
        description: '',
        inStock: 11,
        unit: '',
        status: '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];
