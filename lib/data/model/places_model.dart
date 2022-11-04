import 'package:base_bloc/data/app_database.dart';

class PlacesModel {

  final int? idType;
  final String namePlace;
  final String nameCity;
  final double distance;
  final double lat, lng;

  static const String id = '_id';
  static const String name = 'namePlace';
  static const String city = 'nameCity';
  static const String km = 'distance';
  static const String lt = 'lat';
  static const String lg = 'lng';

  PlacesModel(
      {this.idType,
      required this.namePlace,
      required this.nameCity,
      required this.distance,
      required this.lat,
      required this.lng});

  static PlacesModel fromJson(Map<String, Object?> json) => PlacesModel(
      idType: json[PlacesModel.id] as int,
      nameCity: json[PlaceField.nameCity] as String,
      namePlace: json[PlaceField.namePlace] as String,
      distance: json[PlaceField.distance] as double,
      lng: json[PlaceField.lng] as double,
      lat: json[PlaceField.lat] as double);

  Map<String, Object?> toJson() => {
        PlaceField.id: idType,
        PlaceField.nameCity: nameCity,
        PlaceField.namePlace: namePlace,
        PlaceField.distance: distance,
        PlaceField.lat: lat,
        PlaceField.lng: lng,
      };
}
