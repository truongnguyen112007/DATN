import 'package:base_bloc/data/model/reservation_model.dart';
import 'package:equatable/equatable.dart';

enum StatusType { initial, search, success, failure, refresh }

class TabNotificationState extends Equatable {
  final bool isLoading;
  final StatusType status;
  final List<ReservationModel> lToday;
  final List<ReservationModel> lTomorrow;
  final List<ReservationModel> lNextWeek;
  final bool readEnd;
  final int currentPage;
  final int? timeStamp;

  const TabNotificationState({
    this.readEnd = false,
    this.isLoading = true,
    this.currentPage = 1,
    this.lToday = const <ReservationModel>[],
    this.lTomorrow = const <ReservationModel>[],
    this.lNextWeek = const <ReservationModel>[],
    this.status = StatusType.initial,
    this.timeStamp,
  });

  @override
  List<Object?> get props => [
        lToday,
        lTomorrow,
        lNextWeek,
        currentPage,
        readEnd,
        status,
        isLoading,
        timeStamp
      ];

  TabNotificationState copyOf(
          {List<ReservationModel>? lToday,
          bool? isLoading,
          List<ReservationModel>? lTomorrow,
          List<ReservationModel>? lNextWeek,
          bool? readEnd,
          int? currentPage,
          StatusType? status,
          int? timeStamp}) =>
      TabNotificationState(
          isLoading: isLoading ?? this.isLoading,
          lToday: lToday ?? this.lToday,
          lTomorrow: lTomorrow ?? this.lTomorrow,
          lNextWeek: lNextWeek ?? this.lNextWeek,
          readEnd: readEnd ?? this.readEnd,
          currentPage: currentPage ?? this.currentPage,
          status: status ?? this.status,
          timeStamp: timeStamp ?? this.timeStamp);
}
