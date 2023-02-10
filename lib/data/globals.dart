library app.globals;

import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../gen/assets.gen.dart';
import 'model/goods_model.dart';

String accessToken = '';
String refreshToken = '';
String lang = '';
String avatar = '';
String deviceId = '';
int userId = 0;
String deviceName = '';
String deviceModel = '';
String userName = '';
String playlistId = '';
String languageCode = '';

bool isLogin = false;
bool isTokenExpired = false;
int timePackageRemaining = 0;
int timeOut = 30;

double contentPadding = 8.w;

final List<String> lHoldSet = [
  Assets.svg.holdset1,
  Assets.svg.holdset2,
  Assets.svg.holdset3,
  Assets.svg.holdset4,
  Assets.svg.holdset5
];
List<String> lHoldSetName = [
  'A',
  'B',
  'C',
  'D',
  'E',
  'F',
  'G',
  'H',
  'I',
  'J',
  'K',
  'L'
];
List<ProductModel> fakeDataProducts = [
  ProductModel(
    image: Assets.png.pho.path,
    id: "SP001",
    name: "Hộp phở bò",
    price: 14000,
    barCode: "12569845",
    categoryId: 1,
    type: 'Đồ ăn nhanh',
    cost: '10000',
    description: '',
    inventory: 18,
    inventoryLevel: '0->30',
    status: '',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
  ProductModel(
    image: Assets.png.coca.path,
    id: "SP002",
    name: "Cocacola",
    price: 10000,
    barCode: "00014587",
    categoryId: 1,
    type: 'Nước ngọt',
    cost: '5000',
    description: '',
    inventory: 5,
    inventoryLevel: '0->20',
    status: '',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
  ProductModel(
    image: Assets.png.mt.path,
    id: "SP003",
    name: "Mì ba miền",
    price: 3500,
    barCode: "12023656",
    categoryId: 1,
    type: 'Mì tôm',
    cost: '2000',
    description: '',
    inventory: 24,
    inventoryLevel: '0->50',
    status: '',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
  ProductModel(
    image: Assets.png.bk.path,
    id: "SP004",
    name: "Thịt bò khô",
    price: 120000,
    barCode: "01256985",
    categoryId: 1,
    type: 'Thịt',
    cost: '100000',
    description: '',
    inventory: 15,
    inventoryLevel: '0->30',
    status: '',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
  ProductModel(
    image: Assets.png.dnm.path,
    id: "SP005",
    name: "Kẹo dynamite",
    price: 40000,
    barCode: "01212548",
    categoryId: 1,
    type: 'Kẹo',
    cost: '35000',
    description: '',
    inventory: 4,
    inventoryLevel: '0->30',
    status: '',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
  ProductModel(
    image: Assets.png.ps.path,
    id: "SP006",
    name: "Kem đánh răng Ps",
    price: 32000,
    barCode: "12020214",
    categoryId: 1,
    type: 'Kem đánh răng',
    cost: '25000',
    description: '',
    inventory: 10,
    inventoryLevel: '0->30',
    status: '',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
  ProductModel(
    image: Assets.png.scbv.path,
    id: "SP007",
    name: "Sữa chua ba vì",
    price: 25000,
    barCode: "23658748",
    categoryId: 1,
    type: 'Sữa chua',
    cost: '20000',
    description: '',
    inventory: 12,
    inventoryLevel: '0->30',
    status: '',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
  ProductModel(
    image: Assets.png.tbc.path,
    id: "SP008",
    name: "Tẩy bút chì",
    price: 5000,
    barCode: "25455589",
    categoryId: 1,
    type: 'Dụng cụ học tập',
    cost: '2000',
    description: '',
    inventory: 20,
    inventoryLevel: '0->30',
    status: '',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
  ProductModel(
    image: Assets.png.tdr.path,
    id: "SP009",
    name: "Túi đựng rác",
    price: 65000,
    barCode: "11256369",
    categoryId: 1,
    type: 'Rác',
    cost: '60000',
    description: '',
    inventory: 11,
    inventoryLevel: '0->25',
    status: '',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
  ProductModel(
    image: Assets.png.tg.path,
    id: "SP0010",
    name: "Trà gừng",
    price: 58000,
    barCode: "21035598",
    categoryId: 1,
    type: 'Trà',
    cost: '50000',
    description: '',
    inventory: 12,
    inventoryLevel: '0->30',
    status: '',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
  ProductModel(
    image: Assets.png.trclh.path,
    id: "SP0011",
    name: "Thạch rau câu Long Hải",
    price: 45000,
    barCode: "02356984",
    categoryId: 1,
    type: 'Thạch',
    cost: '40000',
    description: '',
    inventory: 14,
    inventoryLevel: '0->30',
    status: '',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
];
