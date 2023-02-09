class WallModel {
  final String deviceId;
  final String? name;
  final int? numberPlayer;
  final String? rank;
  final String? reservation;

  WallModel(
    this.deviceId, {
    this.reservation,
    this.name,
    this.numberPlayer,
    this.rank,
  });
}
