import 'package:base_bloc/data/model/supplier_model.dart';
import 'package:base_bloc/modules/supplier_page/supplier_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SupplierCubit extends Cubit<SupplierState> {
  SupplierCubit() : super (SupplierState()) {
  }
}

List<SupplierModel> fakeDataSupplier() => [
  SupplierModel(name: "aaaaaa", phone: "0259354215",allMoney: "1.000.000"),
  SupplierModel(name: "bbbbbb", phone: "0123454453",allMoney: "8.256.245"),
  SupplierModel(name: "cccccc", phone: "6546124155",allMoney: "2.165.646"),
];