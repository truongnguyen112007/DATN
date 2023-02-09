import 'package:base_bloc/data/model/address_model.dart';
import 'package:equatable/equatable.dart';

import '../persons_page/persons_page_state.dart';

class FilterAddressState extends Equatable {
  final List<AddressModel> lAddress;
  final bool isReadEnd;
  final bool isLoading;
  final StatusType status;

  const FilterAddressState(
      {this.lAddress = const <AddressModel>[],
      this.isReadEnd = false,
      this.isLoading = true,
      this.status = StatusType.initial});

  FilterAddressState copyOf(
          {List<AddressModel>? lAddress,
          bool? isReadEnd,
          bool? isLoading,
          StatusType? status}) =>
      FilterAddressState(
          lAddress: lAddress ?? this.lAddress,
          isReadEnd: isReadEnd ?? this.isReadEnd,
          isLoading: isLoading ?? this.isLoading,
          status: status ?? this.status);

  @override
  List<Object?> get props => [lAddress, isReadEnd, isLoading, status];
}
