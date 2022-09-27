class ReservationModel {
  final DateTime calendar;
  final String startTime;
  final String endTime;
  final String address;
  final String status;
  final bool isCheck;

  ReservationModel({
    required this.calendar,
    required this.startTime,
    required this.endTime,
    required this.address,
    required this.status,
    required this.isCheck,
  });
}
