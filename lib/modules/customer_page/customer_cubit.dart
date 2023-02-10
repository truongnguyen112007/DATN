import 'package:base_bloc/data/model/customer_model.dart';
import 'package:base_bloc/data/model/supplier_model.dart';
import 'package:base_bloc/modules/supplier_page/supplier_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'customer_state.dart';

class CustomerCubit extends Cubit<CustomerState> {
  CustomerCubit() : super (CustomerState()) {
  }
}

List<CustomerModel> fakeDataCustomer() => [
  CustomerModel(name: "Nguyễn Thị Hồng", phone: "0985687412",price: 400000),
  CustomerModel(name: "Phạm Tiến Đức", phone: "0981236512",price: 200000 ),
  CustomerModel(name: "Trần Quang Thọ", phone: "0332569845",price: 150000),
  CustomerModel(name: "Lê Đức Độ", phone: "0935154845",price: 190000),
  CustomerModel(name: "Bùi Việt Hoàng", phone: "0854774712",price: 350000),
  CustomerModel(name: "Quách Thị Tâm", phone: "0963665668",price: 120000),
  CustomerModel(name: "Vũ Thu Trang", phone: "0335689541",price: 260000),
  CustomerModel(name: "Lý Công Nam", phone: "0332241111",price: 160000),
];