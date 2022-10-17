class PlacesModel {
  final String? idType;
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
      {this.idType = null,
      required this.namePlace,
      required this.nameCity,
      required this.distance,
      required this.lat,
      required this.lng});
}
