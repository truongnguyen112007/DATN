import 'package:base_bloc/data/model/notification_model.dart';
import 'package:equatable/equatable.dart';

enum NotificationsStatus { initial, success, failure, refresh }

class NotificationsState extends Equatable {
  final bool isLoading;
  final NotificationsStatus status;
  final List<NotificationModel> lInvitations;
  final List<NotificationModel> lActivities;
  final bool readEnd;
  final int currentPage;

  const NotificationsState({this.readEnd = false,
    this.isLoading = true,
    this.currentPage = 1,
    this.lInvitations = const <NotificationModel>[],
    this.lActivities = const <NotificationModel>[],
    this.status = NotificationsStatus.initial});

  @override
  List<Object?> get props =>
      [lInvitations, lActivities, currentPage, readEnd, status, isLoading];

  NotificationsState copyOf(
      {bool? isLoading,
        List<NotificationModel>? lInvitations,
        List<NotificationModel>? lActivities,
        bool? readEnd,
        int? currentPage,
        NotificationsStatus? status}) =>
      NotificationsState(
          isLoading: isLoading ?? this.isLoading,
          lInvitations: lInvitations ?? this.lInvitations,
          lActivities: lActivities ?? this.lActivities,
          readEnd: readEnd ?? this.readEnd,
          currentPage: currentPage ?? this.currentPage,
          status: status ?? this.status);
}
