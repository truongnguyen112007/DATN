import 'package:base_bloc/data/model/address_model.dart';
import 'package:base_bloc/data/model/list_places_model.dart';
import 'package:equatable/equatable.dart';

class ConfirmCreateReservationState extends Equatable {
  final PlacesModel? placesModel;
  final AddressModel? addressModel;
  final DateTime? dateTime;

  const ConfirmCreateReservationState(
      {this.dateTime, this.placesModel, this.addressModel});

  ConfirmCreateReservationState copyOf(
          {PlacesModel? placesModel,
          AddressModel? addressModel,
          DateTime? dateTime}) =>
      ConfirmCreateReservationState(
          dateTime: dateTime ?? this.dateTime,
          placesModel: placesModel ?? this.placesModel,
          addressModel: addressModel ?? this.addressModel);

  @override
  List<Object?> get props => [placesModel, addressModel];
}
