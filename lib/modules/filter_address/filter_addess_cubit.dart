import 'dart:async';
import 'package:base_bloc/modules/filter_address/filter_address_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/model/address_model.dart';
import '../persons_page/persons_page_state.dart';

class FilterAddressCubit extends Cubit<FilterAddressState> {
  FilterAddressCubit() : super(const FilterAddressState()) {
    getAddressDefault();
  }

  void getAddressDefault({bool isPaging = false}) {
    if (state.isReadEnd) return;
    if (isPaging) {
      if(state.isLoading) return;
      emit(state.copyOf(isLoading: true));
      Timer(
          const Duration(milliseconds: 500),
          () => emit(state.copyOf(
              lAddress: state.lAddress..addAll(fakeData()),
              status: StatusType.success,
              isLoading: false,
              isReadEnd: true)));
    } else {
      Timer(
          const Duration(milliseconds: 500),
          () => emit(state.copyOf(
              isLoading: false,
              lAddress: fakeData(),
              status: StatusType.success)));
    }
  }

  void onRefresh() {
    emit(const FilterAddressState(status: StatusType.refresh));
    getAddressDefault();
  }

  void search(String text) {
    emit(const FilterAddressState(status: StatusType.search));
    getAddressDefault();
  }

  List<AddressModel> fakeData() => [
        AddressModel(city: 'Warsaw', country: 'Poland', distance: 2.2),
        AddressModel(city: 'Cracow', country: 'Poland', distance: 3.0),
        AddressModel(city: 'New York', country: 'USA', distance: 100.0),
        AddressModel(city: 'Warsaw', country: 'Poland', distance: 2.2),
        AddressModel(city: 'Cracow', country: 'Poland', distance: 3.0),
        AddressModel(city: 'New York', country: 'USA', distance: 100.0),
        AddressModel(city: 'Warsaw', country: 'Poland', distance: 2.2),
        AddressModel(city: 'Cracow', country: 'Poland', distance: 3.0),
        AddressModel(city: 'New York', country: 'USA', distance: 100.0)
      ];
}
