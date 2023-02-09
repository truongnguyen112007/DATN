import 'package:base_bloc/modules/tab_goods/tab_goods_state.dart';
import 'package:base_bloc/router/router.dart';
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
  TabGoodsCubit() : super(const TabGoodsState()) {
    iosGetBlueState(const Duration(seconds: 0));
    androidGetBlueLack(const Duration(seconds: 0));
  }

  void iosGetBlueState(timer) {
    FlutterBlueElves.instance.iosCheckBluetoothState().then((value) => emit(
        state.copyOf(
            isBluetooth: value == IosBluetoothState.poweredOn ? true : false)));
  }

  void androidGetBlueLack(timer) {
    FlutterBlueElves.instance.androidCheckBlueLackWhat().then((values) async {
      if (values.contains(AndroidBluetoothLack.bluetoothFunction)) {
        emit(state.copyOf(isBluetooth: false));
      } else {
        emit(state.copyOf(isBluetooth: true));
        var isGps = await checkTurnOnGps();
        emit(state.copyOf(isGps: isGps));
      }
    });
  }

  void onClickNotification(BuildContext context) =>
      /*toast(LocaleKeys.thisFeatureIsUnder);*/
      RouterUtils.pushClimb(
          context: context,
          route: GoodsRouters.notifications,
          argument: BottomNavigationConstant.TAB_CLIMB);

  void onClickSearch(BuildContext context) => RouterUtils.pushClimb(
      context: context,
      route: GoodsRouters.search,
      argument: BottomNavigationConstant.TAB_CLIMB);

  void onClickLogin(BuildContext context) async {
    await RouterUtils.pushClimb(
        context: context,
        route: GoodsRouters.login,
        argument: BottomNavigationConstant.TAB_CLIMB);
    emit(TabGoodsState(timeStamp: DateTime.now().microsecondsSinceEpoch));
  }

  void onClickAddProducts(BuildContext context) {
    RouterUtils.pushClimb(
        context: context,
        route: GoodsRouters.routesAddProducts,
        argument: BottomNavigationConstant.TAB_CLIMB);
  }

  void openProductDetail(BuildContext context, GoodsModel model) {
    RouterUtils.pushClimb(
        context: context,
        route: GoodsRouters.routesProductsDetail,
        argument: [BottomNavigationConstant.TAB_CLIMB, model]);
  }
}

Future<bool> checkTurnOnGps() async =>
    await Geolocator.isLocationServiceEnabled();

List<PlacesModel> fakeData() => [
      PlacesModel(
          namePlace: 'Murall',
          nameCity: 'Warsaw',
          distance: 2.2,
          lat: 21.0484124195535,
          lng: 105.80959985686454),
      PlacesModel(
          namePlace: 'Makak',
          nameCity: 'Warsaw',
          distance: 2.2,
          lat: 21.061288097479334,
          lng: 105.80934959954087),
      PlacesModel(
          namePlace: 'Murall',
          nameCity: 'Warsaw',
          distance: 2.2,
          lat: 21.079085115322442,
          lng: 105.8124170251354),
    ];

List<GoodsModel> fakeDataProducts() => [
      GoodsModel(Assets.png.pho.path, "Hộp phở bò", "SP00020", "10,000", "8"),
      GoodsModel(Assets.png.coca.path, "Cocacola", "SP00021", "12,000", "14"),
      GoodsModel(Assets.png.mt.path, "Mì ba miền", "SP00022", "3,500", "40"),
      GoodsModel(Assets.png.bk.path, "Thịt bò khô", "SP00023", "35,000", "12"),
      GoodsModel(Assets.png.dnm.path, "Kẹo dynamite", "SP00024", "2,000", "34"),
      GoodsModel(
          Assets.png.ps.path, "Kem đánh răng PS", "SP00025", "31,000", "15"),
      GoodsModel(
          Assets.png.bb.path, "Bút thiên long", "SP00026", "4,000", "30"),
      GoodsModel(Assets.png.tbc.path, "Tẩy bút chì", "SP00027", "3,000", "12"),
      GoodsModel(Assets.png.bctb.path, "Bánh cáy", "SP00028", "41,000", "10"),
      GoodsModel(
          Assets.png.scbv.path, "Sữa chua Ba Vì", "SP00029", "4,000", "34"),
      GoodsModel(Assets.png.cn.path, "Cốc nhựa", "SP00030", "15,000", "24"),
      GoodsModel(
          Assets.png.tdr.path, "Túi đựng rác", "SP00031", "30,000", "22"),
      GoodsModel(Assets.png.tg.path, "Trà gừng", "SP00032", "42,000", "11"),
      GoodsModel(
          Assets.png.trclh.path, "Thạch rau câu", "SP00033", "54,000", "43"),
      GoodsModel(Assets.png.bcdr.path, "Bàn chải đánh răng", "SP00034",
          "31,000", "29"),
    ];
