import 'package:base_bloc/data/model/address_model.dart';
import 'package:base_bloc/modules/tab_reservation/tab_reservation_state.dart';
import 'package:equatable/equatable.dart';

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
