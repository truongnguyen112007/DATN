class ReservationModel {
  final DateTime calendar;
  final String startTime;
  final String endTime;
  final String address;
  final String status;
  final String city;
  final bool isCheck;

  ReservationModel({
    required this.calendar,
    required this.startTime,
    required this.city,
    required this.endTime,
    required this.address,
    required this.status,
    required this.isCheck,
  });
}
