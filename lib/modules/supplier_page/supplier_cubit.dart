import 'package:base_bloc/data/model/supplier_model.dart';
import 'package:base_bloc/modules/supplier_page/supplier_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SupplierCubit extends Cubit<SupplierState> {
  SupplierCubit() : super (SupplierState()) {
  }
}

List<SupplierModel> fakeDataSupplier() => [
  SupplierModel(name: "Timi Koon", phone: "0956238612",allMoney: "1.000.000"),
  SupplierModel(name: "Cowin", phone: "0984562871",allMoney: "5.000.000"),
  SupplierModel(name: "ChocoB", phone: "0333265845",allMoney: "2.000.000"),
];