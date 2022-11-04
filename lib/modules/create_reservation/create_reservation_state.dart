import 'package:base_bloc/data/model/address_model.dart';
import 'package:base_bloc/data/model/places_model.dart';
import 'package:equatable/equatable.dart';

class CreateReservationState extends Equatable {
  final double startTime;
  final double endTime;
  final AddressModel? addressModel;
  final PlacesModel? placesModel;

  const CreateReservationState(
      {this.addressModel,
      this.startTime = 6,
      this.endTime = 15,
      this.placesModel});

  CreateReservationState copyOf(
          {double? startTime,
          double? endTime,
          AddressModel? addressModel,
          PlacesModel? placesModel}) =>
      CreateReservationState(
          placesModel: placesModel ?? this.placesModel,
          addressModel: addressModel ?? this.addressModel,
          startTime: startTime ?? this.startTime,
          endTime: endTime ?? this.endTime);

  @override
  List<Object?> get props => [startTime, endTime, addressModel, placesModel];
}
